extends Node
## Gravador do autoteste gráfico (QA, fora do export). Ativado por `-- --record=<pasta>`:
## fotografa o mundo a cada mudança de capítulo ou fase (e a cada 25 s reais), mede luminância
## média e fração de pixels quase pretos (legibilidade), tempo de quadro e chamadas de desenho
## por capítulo, e monta folhas de contato. Em modo headless não faz nada.

var app: AppRoot
var label := ""
var out_dir := ""
var shots: Array = []
var stats: Dictionary = {}

var _last_key := ""
var _since := 0.0
var _pending := -1.0
var _last_us := 0


static func wanted() -> String:
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--record="):
			return a.substr(9)
	return ""


func setup(a: AppRoot, suite: String, dir: String) -> void:
	app = a
	label = suite
	out_dir = dir
	DirAccess.make_dir_recursive_absolute(out_dir)
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	var now := Time.get_ticks_usec()
	var frame_ms := 0.0 if _last_us == 0 else (now - _last_us) / 1000.0
	_last_us = now
	if app == null or app.chapter == null or not is_instance_valid(app.chapter):
		return
	var ch := str(app.chapter.get_script().get_global_name())
	if frame_ms > 0.0:
		var s: Dictionary = stats.get(ch, {"frames": 0, "total_ms": 0.0, "worst_ms": 0.0, "over_33": 0, "draws_max": 0, "prims_max": 0})
		s["frames"] = int(s["frames"]) + 1
		s["total_ms"] = float(s["total_ms"]) + frame_ms
		s["worst_ms"] = maxf(float(s["worst_ms"]), frame_ms)
		if frame_ms > 33.4:
			s["over_33"] = int(s["over_33"]) + 1
		s["draws_max"] = maxi(int(s["draws_max"]), int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
		s["prims_max"] = maxi(int(s["prims_max"]), int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)))
		stats[ch] = s
	var key := "%s/%s" % [ch, app.chapter.phase]
	_since += frame_ms / 1000.0
	if key != _last_key:
		_last_key = key
		_pending = 0.6
	if _pending >= 0.0:
		_pending -= frame_ms / 1000.0
		if _pending < 0.0:
			_shoot(key)
	elif _since > 25.0:
		_shoot(key)


func _shoot(key: String) -> void:
	_since = 0.0
	if app.mode != "game":
		return
	var world := app.viewport.get_texture().get_image()
	var full := get_viewport().get_texture().get_image()
	var lum := 0.0
	var dark := 0
	var n := 0
	for y in range(0, world.get_height(), 2):
		for x in range(0, world.get_width(), 2):
			var c := world.get_pixel(x, y)
			var l := 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b
			lum += l
			if l < 0.03:
				dark += 1
			n += 1
	var name := "%s_%03d_%s.png" % [label, shots.size(), key.replace("/", "_")]
	full.resize(640, 360, Image.INTERPOLATE_BILINEAR)
	full.save_png(out_dir.path_join(name))
	shots.append({"file": name, "key": key, "lum": snappedf(lum / maxi(n, 1), 0.001), "dark": snappedf(float(dark) / maxi(n, 1), 0.001)})


func finish() -> void:
	## Grava o relatório JSON e as folhas de contato (4 × 3 por folha).
	var report := {"suite": label, "shots": shots, "chapters": {}}
	for ch: String in stats.keys():
		var s: Dictionary = stats[ch]
		var frames := maxi(int(s["frames"]), 1)
		report["chapters"][ch] = {
			"frames": frames,
			"avg_ms": snappedf(float(s["total_ms"]) / frames, 0.01),
			"worst_ms": snappedf(float(s["worst_ms"]), 0.01),
			"over_33_pct": snappedf(100.0 * int(s["over_33"]) / frames, 0.1),
			"draws_max": s["draws_max"],
			"prims_max": s["prims_max"],
		}
	var f := FileAccess.open(out_dir.path_join("%s-relatorio.json" % label), FileAccess.WRITE)
	f.store_string(JSON.stringify(report, "\t"))
	f.close()
	var per := 12
	var sheet_i := 0
	var i := 0
	while i < shots.size():
		var sheet := Image.create(4 * 320, 3 * 180, false, Image.FORMAT_RGB8)
		for k in per:
			if i + k >= shots.size():
				break
			var img := Image.load_from_file(out_dir.path_join(str(shots[i + k]["file"])))
			img.convert(Image.FORMAT_RGB8)
			img.resize(320, 180, Image.INTERPOLATE_BILINEAR)
			sheet.blit_rect(img, Rect2i(0, 0, 320, 180), Vector2i((k % 4) * 320, (k / 4) * 180))
		sheet.save_png(out_dir.path_join("%s-folha-%02d.png" % [label, sheet_i]))
		sheet_i += 1
		i += per
