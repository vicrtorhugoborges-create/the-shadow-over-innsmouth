class_name AppRoot
extends Node
## Compõe sistemas e o capítulo ativo (docs/17). Único ponto de composição: sem autoloads.

const RETRO_SHADER := preload("res://shaders/retro_post.gdshader")

var settings := SettingsStore.new()
var saves := SaveService.new()
var synth := SoundSynth.new()
var ui: UiRoot
var container: SubViewportContainer
var viewport: SubViewport
var chapter: ChapterBase
var state: StoryState
var fail_counts: Dictionary = {}
var mode := "menu"

var _dialog_cb: Callable = Callable()
var _retro_mat: ShaderMaterial
var _capture_event := ""
var _bench := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	settings.load_from_disk()
	InputSetup.apply(settings.get_value("keys"))
	_ensure_buses()
	synth.build()
	_build_view()
	ui = UiRoot.new()
	add_child(ui)
	_connect_ui()
	_apply_settings()
	get_viewport().size_changed.connect(_update_shrink)
	if _capture_mode():
		return
	if bool(settings.get_value("content_warning_seen")):
		_to_menu()
	else:
		ui.show_warning()


func _build_view() -> void:
	container = SubViewportContainer.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.stretch = true
	container.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_retro_mat = ShaderMaterial.new()
	_retro_mat.shader = RETRO_SHADER
	container.material = _retro_mat
	add_child(container)
	viewport = SubViewport.new()
	viewport.own_world_3d = true
	viewport.audio_listener_enable_3d = true
	viewport.handle_input_locally = false
	viewport.msaa_3d = Viewport.MSAA_DISABLED
	viewport.positional_shadow_atlas_size = 1024
	container.add_child(viewport)
	_update_shrink()


func _update_shrink() -> void:
	if container == null:
		return
	var h := float(get_viewport().get_visible_rect().size.y)
	var target := float(int(settings.get_value("internal_height")))
	container.stretch_shrink = maxi(1, int(round(h / target)))


func _connect_ui() -> void:
	ui.warning_accepted.connect(func() -> void:
		settings.set_value("content_warning_seen", true)
		settings.save_to_disk()
		_to_menu())
	ui.new_game_requested.connect(_new_game)
	ui.chapter_requested.connect(start_from)
	ui.continue_requested.connect(_continue_game)
	ui.quit_requested.connect(func() -> void: get_tree().quit())
	ui.resume_requested.connect(_resume)
	ui.retry_requested.connect(_retry)
	ui.checkpoint_requested.connect(_retry)
	ui.menu_requested.connect(_to_menu)
	ui.setting_changed.connect(func(key: String, v: Variant) -> void:
		settings.set_value(key, v)
		settings.save_to_disk()
		_apply_settings())
	ui.key_rebound.connect(func(action: String, code: int) -> void:
		var keys: Dictionary = settings.get_value("keys").duplicate()
		keys[action] = code
		settings.set_value("keys", keys)
		settings.save_to_disk()
		InputSetup.apply(settings.get_value("keys")))
	ui.journal_requested.connect(func() -> void:
		if chapter and mode == "paused":
			_open_journal())
	ui.dialog_choice.connect(_on_dialog_choice)
	ui.modal_closed.connect(func(_kind: String) -> void: _resume())
	ui.hint_requested.connect(func() -> void:
		if chapter:
			chapter.request_hint()
			var j := chapter.get_journal()
			ui.update_journal_hint(j["hint"], j["can_hint"]))


func _ensure_buses() -> void:
	## Canais de mixagem (docs/15): ambiente (laços) e efeitos (sons pontuais), ambos no Master.
	for bus_name: String in ["Ambience", "Effects"]:
		if AudioServer.get_bus_index(bus_name) == -1:
			AudioServer.add_bus()
			var idx := AudioServer.bus_count - 1
			AudioServer.set_bus_name(idx, bus_name)
			AudioServer.set_bus_send(idx, &"Master")


func _bus_db(linear: float) -> float:
	return linear_to_db(maxf(0.0001, linear))


func _apply_settings() -> void:
	var v: Dictionary = settings.values
	AudioServer.set_bus_volume_db(0, _bus_db(float(v["master_volume"])))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), _bus_db(float(v["ambience_volume"])))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), _bus_db(float(v["effects_volume"])))
	ui.set_settings_values(v)
	ui.apply_text_size(int(v["text_size"]))
	_retro_mat.set_shader_parameter("enabled", bool(v["dither"]))
	_retro_mat.set_shader_parameter("strength", float(v["retro_strength"]))
	_retro_mat.set_shader_parameter("gamma", float(v["brightness"]))
	if DisplayServer.get_name() != "headless" and not _capture_requested():
		var want_full := bool(v["fullscreen"])
		var is_full := DisplayServer.window_get_mode() in [DisplayServer.WINDOW_MODE_FULLSCREEN, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]
		if want_full != is_full:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if want_full else DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if bool(v["vsync"]) else DisplayServer.VSYNC_DISABLED)
	_update_shrink()
	if chapter:
		chapter.apply_settings(v)


func _capture_requested() -> bool:
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--capture="):
			return true
	return false


func _unlock_chapter(cp: String) -> void:
	## Libera no menu o início do capítulo que contém `cp` (docs/16 §2.1). Progresso fica nas
	## configurações para sobreviver a uma nova partida.
	var start := SettingsStore.chapter_start_for(cp)
	if start == "":
		return
	var list: Array = (settings.get_value("chapters_unlocked") as Array).duplicate()
	if list.has(start):
		return
	list.append(start)
	settings.set_value("chapters_unlocked", list)
	settings.save_to_disk()
	ui.set_settings_values(settings.values)


# ---------------------------------------------------------------- fluxo

func _clear_chapter() -> void:
	if chapter:
		chapter.queue_free()
		chapter = null
	ui.clear_subtitles()
	ui.set_prompt("")
	ui.set_status("")
	ui.set_eyes(0.0)


func _to_menu() -> void:
	get_tree().paused = false
	_clear_chapter()
	mode = "menu"
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.fade_to(0.0, 0.3)
	ui.show_main(saves.has_save())


func _new_game() -> void:
	start_from("cp00_frame")


const CHAPTER_STARTS: Array = [
	["Moldura e I — A Viagem", "cp00_frame"],
	["II — A Cidade Esquecida", "cp02_bus_ride"],
	["III — Os Segredos de Innsmouth", "cp03_grocery"],
	["IV — O Testemunho de Zadok Allen", "cp04_wharf"],
	["V — A Armadilha", "cp05_return"],
	["VI — Fuga do Gilman House", "cp06_knock"],
	["VII — A Noite de Innsmouth", "cp07_washington"],
	["VIII — A Herança de Innsmouth", "cp08_rain"],
]


func start_from(cp: String) -> void:
	## Nova partida a partir de um capítulo. Concede só o que o narrador teria naquele ponto;
	## cada capítulo completa os fatos anteriores ao restaurar o checkpoint.
	saves.delete_all()
	fail_counts.clear()
	state = StoryState.new()
	for it: String in ["item_valise", "item_keyring_tool", "item_watch"]:
		state.give_item(it)
	var order: Array[String] = ["cp00", "cp01", "cp02", "cp03", "cp04", "cp05", "cp06", "cp07", "cp08"]
	var stage := order.find(cp.substr(0, 4))
	if stage >= 4:
		state.give_item("item_sketch_map")
		state.add_doc("doc_sketch_map")
		state.give_item("item_crackers")
	if stage >= 5:
		state.add_doc("doc_zadok_record")
	if stage >= 6:
		state.give_item("item_flashlight")
	state.set_checkpoint(cp)
	saves.save_state(state)
	_unlock_chapter(cp)
	_start_chapter()


func _continue_game() -> void:
	var s := saves.load_state()
	if s == null:
		ui.show_main(false)
		return
	if saves.load_reports_recovery():
		push_warning("Save primário inválido; backup usado.")
	state = s
	_start_chapter()
	# Resumo "Até aqui" ao carregar (docs/16 §5, cognição).
	if chapter:
		var j := chapter.get_journal()
		say("Até aqui — " + str(j["objective"]), 7.0, "thought")


func _retry() -> void:
	var s := saves.load_state()
	if s == null:
		_to_menu()
		return
	state = s
	_start_chapter()


static func chapter_for(s: StoryState) -> ChapterBase:
	## Escolhe o capítulo pelo checkpoint gravado. Retorna null para conteúdo ainda não produzido
	## ou quando o manuscrito já terminou.
	var cp := s.checkpoint
	if s.has_fact("ch08_done"):
		return null
	if cp.begins_with("cp00") or cp.begins_with("cp01"):
		return NewburyportChapter.new()
	if cp.begins_with("cp02") or cp.begins_with("cp03") or cp.begins_with("cp04"):
		return DayChapter.new()
	if cp.begins_with("cp05") or cp.begins_with("cp06"):
		return GilmanChapter.new()
	if cp.begins_with("cp07"):
		return NightChapter.new()
	if cp.begins_with("cp08"):
		return InheritanceChapter.new()
	return null


func _start_chapter() -> void:
	get_tree().paused = false
	_clear_chapter()
	chapter = chapter_for(state)
	if chapter == null:
		mode = "end"
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_show_end()
		return
	chapter.app = self
	viewport.add_child(chapter)
	chapter.apply_settings(settings.values)
	chapter.failed.connect(_on_failed)
	chapter.finished.connect(_on_finished)
	ui.show_hud()
	mode = "game"
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.fade_to(1.0, 0.0)
	chapter.begin(state)
	ui.fade_to(0.0, 1.2)


func _on_failed(text: String) -> void:
	mode = "fail"
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.fade_to(1.0, 0.6)
	await get_tree().create_timer(0.8, true).timeout
	if mode == "fail":
		ui.show_fail(text)


func _on_finished() -> void:
	# O capítulo seguinte começa do checkpoint que o anterior acabou de gravar.
	if chapter_for(state) != null:
		_start_chapter()
		return
	mode = "end"
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_show_end()


func _resume() -> void:
	if mode != "game" and mode != "modal" and mode != "paused":
		return
	mode = "game"
	ui.show_hud()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _open_journal() -> void:
	var j := chapter.get_journal()
	_open_modal()
	ui.show_journal(j["objective"], j["hint"], j["can_hint"], j["notes"], j["docs"])


func _open_modal() -> void:
	mode = "modal"
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.set_prompt("")


# ---------------------------------------------------------------- serviços ao capítulo

func save_checkpoint(cp: String) -> void:
	state.set_checkpoint(cp)
	saves.save_state(state)
	if not (chapter and chapter.capture_mode):
		_unlock_chapter(cp)


func show_dialog(speaker: String, text: String, choices: Array, cb: Callable) -> void:
	_open_modal()
	_dialog_cb = cb
	ui.show_dialog(speaker, text, choices)


func _on_dialog_choice(index: int) -> void:
	var cb := _dialog_cb
	_dialog_cb = Callable()
	_resume()
	if cb.is_valid():
		cb.call(index)


func show_document(title: String, body: String) -> void:
	_open_modal()
	ui.show_document(title, body)


func say(text: String, seconds: float = 4.0, kind: String = "speech") -> void:
	ui.subtitle(text, seconds, kind)


func play_sound(id: String, at: Vector3 = Vector3.INF, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	if chapter == null:
		return
	var stream := synth.get_stream(id)
	if stream == null:
		return
	if at == Vector3.INF:
		var p := AudioStreamPlayer.new()
		p.stream = stream
		p.volume_db = volume_db
		p.pitch_scale = pitch
		p.bus = &"Effects"
		chapter.add_child(p)
		p.play()
		p.finished.connect(p.queue_free)
	else:
		var p3 := AudioStreamPlayer3D.new()
		p3.stream = stream
		p3.volume_db = volume_db
		p3.pitch_scale = pitch
		p3.bus = &"Effects"
		p3.unit_size = 4.0
		p3.max_distance = 45.0
		chapter.add_child(p3)
		p3.global_position = at
		p3.play()
		p3.finished.connect(p3.queue_free)


# ---------------------------------------------------------------- input

func _input(event: InputEvent) -> void:
	if mode == "game" and chapter and event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		chapter.player.apply_look((event as InputEventMouseMotion).relative)


func _unhandled_input(event: InputEvent) -> void:
	if mode == "game" and chapter:
		if event.is_action_pressed("pause"):
			mode = "paused"
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			ui.set_prompt("")
			ui.show_pause(str(chapter.get_journal()["objective"]))
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("journal") and chapter.player.controls_enabled:
			_open_journal()
			get_viewport().set_input_as_handled()
		elif chapter.player.handle_input(event):
			get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	if mode == "game" and chapter and chapter.player:
		var f := chapter.player.focused
		ui.set_prompt("" if f == null else "[%s]  %s" % [InputSetup.key_name(_key_for("interact")), f.get_prompt()])
		_retro_mat.set_shader_parameter("seed", float(Engine.get_frames_drawn() % 97))


func _key_for(action: String) -> int:
	var keys: Dictionary = settings.get_value("keys")
	return int(keys.get(action, InputSetup.DEFAULT_KEYS[action]))


# ---------------------------------------------------------------- captura de tela (QA)

func _capture_mode() -> bool:
	## `-- --capture=<checkpoint> --out=<png>`: abre um checkpoint e grava uma imagem (QA visual).
	var args := OS.get_cmdline_user_args()
	var cp := ""
	var out := ""
	var yaw := 0.0
	var pitch := 0.0
	var pos := Vector3.INF
	var flash := false
	for a: String in args:
		if a.begins_with("--capture="):
			cp = a.substr(10)
		elif a.begins_with("--out="):
			out = a.substr(6)
		elif a.begins_with("--yaw="):
			yaw = deg_to_rad(float(a.substr(6)))
		elif a.begins_with("--pitch="):
			pitch = deg_to_rad(float(a.substr(8)))
		elif a.begins_with("--pos="):
			var p := a.substr(6).split(",")
			if p.size() == 3:
				pos = Vector3(float(p[0]), float(p[1]), float(p[2]))
		elif a == "--flash":
			flash = true
		elif a.begins_with("--event="):
			_capture_event = a.substr(8)
		elif a == "--bench":
			_bench = true
	if cp == "" or out == "":
		return false
	_capture(cp, out, yaw, pitch, pos, flash)
	return true


func _capture(cp: String, out: String, yaw: float, pitch: float, pos: Vector3, flash: bool) -> void:
	state = StoryState.new()
	for it: String in ["item_valise", "item_keyring_tool", "item_sketch_map", "item_watch", "item_flashlight"]:
		state.give_item(it)
	state.set_checkpoint(cp)
	saves.slot = 9
	chapter = chapter_for(state)
	chapter.app = self
	chapter.capture_mode = true
	viewport.add_child(chapter)
	chapter.apply_settings(settings.values)
	ui.show_hud()
	mode = "game"
	chapter.begin(state)
	if pos != Vector3.INF:
		chapter.player.global_position = pos
	chapter.player.set_view(yaw, pitch)
	if flash:
		chapter.player.has_flashlight = true
		chapter.player.toggle_flashlight()
	if _capture_event != "" and chapter.has_method("debug_event"):
		chapter.call("debug_event", _capture_event)
	for i in 40:
		await get_tree().process_frame
	if _bench:
		await _run_bench(cp)
	var img := get_viewport().get_texture().get_image()
	img.save_png(out)
	saves.delete_all()
	get_tree().quit()


func _run_bench(label: String) -> void:
	## Mede quadros por ~6 s com vsync desligado (QA de desempenho, docs/19). Não é benchmark oficial.
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	for i in 30:
		await get_tree().process_frame
	var times: Array[float] = []
	var t0 := Time.get_ticks_usec()
	var last := t0
	var draws := 0
	while Time.get_ticks_usec() - t0 < 6000000:
		await get_tree().process_frame
		var now := Time.get_ticks_usec()
		times.append((now - last) / 1000.0)
		last = now
		draws = maxi(draws, int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
	times.sort()
	var total := 0.0
	for x in times:
		total += x
	var avg := total / times.size()
	var p99 := times[int(times.size() * 0.99)]
	print("BENCH %s | quadros=%d | media=%.2f ms (%.0f fps) | p99=%.2f ms | pior=%.2f ms | draw calls=%d | memoria=%.0f MB" % [
		label, times.size(), avg, 1000.0 / avg, p99, times[-1], draws,
		Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0])


func _show_end() -> void:
	if state and state.has_fact("ch08_done"):
		ui.show_end(InheritanceText.END_TITLE, InheritanceText.END_BODY)
	else:
		ui.show_end()
