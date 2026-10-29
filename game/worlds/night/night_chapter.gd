class_name NightChapter
extends ChapterBase
## ch07_night (docs/09): da Washington Street ao desmaio no corte de mato.
## Cidade noturna construída por grade de quadras (geometria cinza identificada).
## Coordenadas: +x leste (mar), −x oeste, +z sul, −z norte (desfiladeiro, pântano, Rowley).

const N = preload("res://data/night_text.gd")
const G = preload("res://data/gilman_text.gd")
const CELL := 4.0
const GX0 := -112.0
const GZ0 := -16.0
const GW := 29
const GD := 48

# Ruas: Rect2(x, z, largura, profundidade) — alinhadas à grade [C nomes; volumetria O].
const STREETS: Array[Rect2] = [
	Rect2(-44, -16, 20, 176),   # Washington
	Rect2(-100, 52, 92, 12),    # Bates
	Rect2(-72, 52, 12, 112),    # Lafayette
	Rect2(-72, 100, 76, 16),    # South (aberta até o mar; a leste de x = −9 é só vista)
	Rect2(-72, 144, 48, 8),     # Babson
	Rect2(-100, -16, 8, 80),    # Adams
]
const C1 := Vector2(-34, 108)   # espaço aberto Eliot × Washington × South
const C1_R := 18.0
const C2 := Vector2(-66, 150)   # espaço aberto Eliot × Babson × Lafayette
const C2_R := 10.0
const ELIOT_A := Vector2(-34, 108)
const ELIOT_B := Vector2(-110, 208)
const ELIOT_W := 4.5
const SEA_Y := -13.5
const VESTIBULES: Dictionary = {
	"v_bates": Rect2(-48, 44, 4, 4),
	"v_portal": Rect2(-48, 128, 4, 4),
	"v_babson1": Rect2(-52, 140, 4, 4),
	"v_babson2": Rect2(-60, 140, 4, 4),
	"v_lafayette": Rect2(-76, 84, 4, 4),
	"v_adams": Rect2(-104, 28, 4, 4),
}

var director := PatrolDirector.new()
var _rng := RandomNumberGenerator.new()
var _group_nodes: Dictionary = {}
var _reef_flashes: Array[MeshInstance3D] = []
var _cupola_flash: MeshInstance3D
var _cupola_light: OmniLight3D
var _reef_glow: MeshInstance3D
var _swimmers: MultiMeshInstance3D
var _swim_pos: Array[Vector3] = []
var _rowboat: Node3D
var _column: Array[MeshInstance3D] = []
var _car: Node3D
var _car_sound: AudioStreamPlayer3D
var _federal_sound: AudioStreamPlayer3D
var _flop: AudioStreamPlayer3D
var _amb_wind: AudioStreamPlayer
var _amb_sea: AudioStreamPlayer3D
var _amb_falls: AudioStreamPlayer3D
var _amb_drone: AudioStreamPlayer
var _procession: Array[Dictionary] = []
var _cards: Array[Dictionary] = []
var _proc_t := -1.0
var _eyes_closed_t := 0.0
var _eyes_open_since := -1.0
var _eyes := 0.0
var _eyes_forced := false
var _gaze_t := 0.0
var _signal_t := -1.0
var _swim_t := -1.0
var _bates_t := -1.0
var _ipswich_t := -1.0
var _band_stage := 0
var _croak_t := 4.0
var _drunk: Node3D
var _drunk_t := -1.0
var _bats: Array[Dictionary] = []
var _leader: Node3D
## QA: o andarilho automático testa geometria sem ser percebido pelos grupos.
var qa_ghost := false


func _objectives() -> Dictionary:
	return N.OBJECTIVES


func _hints() -> Dictionary:
	return N.HINTS


func _docs() -> Dictionary:
	return G.DOCS


func _apply_chapter_settings(_v: Dictionary) -> void:
	director.assisted = assisted
	if player:
		player.camera.far = 1300.0


# ================================================================ início

func begin(s: StoryState) -> void:
	state = s
	_rng.seed = 1927
	_init_world()
	_set_night(0.009)
	_build_town()
	_build_sea()
	_build_bank_and_gorge()
	_build_marsh()
	# Tudo o que é estático até aqui vira uma malha por material (docs/19: chamadas de desenho).
	# Elementos dinâmicos ainda ocultos (clarões, coluna, bote) são preservados.
	WorldKit.merge_static(_world)
	_build_audio()
	_make_player()
	player.has_flashlight = state.has_item("item_flashlight")
	director.assisted = assisted
	director.los = _los
	_build_sentinels()
	_restore(state.checkpoint)


func _restore(cp: String) -> void:
	var order := ["cp07_washington", "cp07_south_crossing", "cp07_babson", "cp07_bank_street", "cp07_bridge", "cp07_cut"]
	var stage := order.find(cp)
	if stage >= 1:
		state.set_fact("bates_passed")
	if stage >= 2:
		for f: String in ["reef_signals_seen", "swimmers_seen", "motor_heard", "railway_plan"]:
			state.set_fact(f)
		_note(N.NOTES["signals"])
		_note(N.NOTES["swimmers"])
		_note(N.NOTES["plan"])
		_show_signals_static()
	if stage >= 3:
		for f2: String in ["ipswich_party_seen", "rowboat_seen", "band_passed", "drunk_seen", "bank_reached"]:
			state.set_fact(f2)
		_note(N.NOTES["ipswich"])
		_note(N.NOTES["band"])
	if stage >= 4:
		state.set_fact("bats_seen")
	if stage >= 5:
		for f3: String in ["gap_jumped", "marsh_reached", "column_seen"]:
			state.set_fact(f3)
		_note(N.NOTES["column"])
	match cp:
		"cp07_washington":
			_spawn(Vector3(-27.0, 0.05, -4.5), PI)
			_set_phase("washington")
			if not capture_mode:
				app.ui.chapter_card(N.CHAPTER_CARD, 4.5)
				_after(4.0, func() -> void: _think(N.THOUGHTS["start"]))
		"cp07_south_crossing":
			_spawn(Vector3(-34.0, 0.05, 82.0), PI)
			_set_phase("crossing")
		"cp07_babson":
			_spawn(Vector3(-46.0, 0.05, 130.5), PI)
			_set_phase("babson")
		"cp07_bank_street":
			_spawn(Vector3(-96.0, 0.05, -22.0), PI / 2)
			_set_phase("bank")
		"cp07_bridge":
			_spawn(Vector3(-220.0, 0.05, -24.0), 0.0)
			_set_phase("bridge")
		"cp07_cut":
			_spawn(Vector3(-220.0, 0.05, -200.0), 0.0)
			_set_phase("cut")
			_start_wind_shift()


# ================================================================ cidade (grade de quadras)

func _is_open(p: Vector2) -> bool:
	for r: Rect2 in STREETS:
		if r.has_point(p):
			return true
	if p.distance_to(C1) < C1_R or p.distance_to(C2) < C2_R:
		return true
	if _dist_to_eliot(p) < ELIOT_W:
		return true
	for v: Rect2 in VESTIBULES.values():
		if v.has_point(p):
			return true
	return false


func _dist_to_eliot(p: Vector2) -> float:
	var ab := ELIOT_B - ELIOT_A
	var t := clampf((p - ELIOT_A).dot(ab) / ab.length_squared(), 0.0, 1.0)
	return p.distance_to(ELIOT_A + ab * t)


func _custom(p: Vector2) -> bool:
	# Gilman House e arredores imediatos são construídos à parte.
	return p.x > -8.0 and p.y < 14.0


func _build_town() -> void:
	WorldKit.box(_world, Vector3(-65.0, -0.1, 79.0), Vector3(98.0, 0.2, 190.0), M_COBBLE)
	WorldKit.box(_world, Vector3(-6.0, -0.1, 42.0), Vector3(20.0, 0.2, 116.0), M_COBBLE)
	WorldKit.box(_world, Vector3(-6.0, -0.1, 145.0), Vector3(20.0, 0.2, 58.0), M_COBBLE)
	var solid: Array = []
	for j in GD:
		var row: Array = []
		for i in GW:
			var c := Vector2(GX0 + (i + 0.5) * CELL, GZ0 + (j + 0.5) * CELL)
			row.append(not _is_open(c) and not _custom(c))
		solid.append(row)
	# Cada fileira vira trechos de 2–3 células com alturas variadas: massa contínua de casas.
	for j in GD:
		var i := 0
		while i < GW:
			if not solid[j][i]:
				i += 1
				continue
			var run := 1
			var maxrun := _rng.randi_range(2, 3)
			while i + run < GW and solid[j][i + run] and run < maxrun:
				run += 1
			var x0 := GX0 + i * CELL
			var z0 := GZ0 + j * CELL
			var center := Vector2(x0 + run * CELL * 0.5, z0 + CELL * 0.5)
			var h := _rng.randf_range(5.0, 9.0)
			if center.distance_to(C1) < 34.0:
				h = _rng.randf_range(4.0, 5.5)
			var mat: Material = M_CLAP if _rng.randf() < 0.6 else M_BRICK
			WorldKit.box(_world, Vector3(center.x, h * 0.5, center.y), Vector3(run * CELL, h, CELL), mat)
			if _rng.randf() < 0.45:
				var roof := WorldKit.box(_world, Vector3(center.x, h + 0.8, center.y), Vector3(run * CELL, 0.3, CELL * 0.8), M_SLATE, false)
				roof.rotation.x = 0.35 if _rng.randf() < 0.5 else -0.35
			_windows(Vector2(x0, z0), run, h, solid, i, j)
			i += run
	_build_vestibules()
	# Gilman House com a cúpula a nordeste (sinais de resposta) [C].
	WorldKit.box(_world, Vector3(0.5, 6.5, -2.0), Vector3(11.0, 13.0, 24.0), M_CLAP)
	WorldKit.box(_world, Vector3(1.5, 16.0, -2.0), Vector3(3.0, 6.0, 3.0), TexFactory.flat(Color(0.30, 0.27, 0.16)))
	_cupola_flash = WorldKit.box(_world, Vector3(1.5, 20.0, -2.0), Vector3(1.6, 1.6, 1.6), _nofog(Color(1.0, 0.85, 0.5), true), false)
	_cupola_flash.visible = false
	_cupola_light = WorldKit.omni(_world, Vector3(1.5, 21.0, -2.0), Color(1.0, 0.8, 0.5), 0.0, 70.0)
	# Campanários e telhados que brilham ao luar, vistos do pântano [C].
	for q: Vector3 in [Vector3(-60, 15, 30), Vector3(-20, 17, 70), Vector3(-80, 14, 120)]:
		WorldKit.box(_world, q, Vector3(3.0, 30.0, 3.0), _nofog(Color(0.42, 0.40, 0.32)), false)
		WorldKit.box(_world, q + Vector3(0, 16.5, 0), Vector3(1.6, 3.0, 1.6), _nofog(Color(0.46, 0.44, 0.35)), false)
	# Barreiras: a Federal e as estradas nunca são acessíveis [C]; ruas vigiadas ao fundo.
	WorldKit.blocker(_world, Vector3(-34, 3, -13), Vector3(20, 6, 1))
	WorldKit.blocker(_world, Vector3(-9, 3, 108), Vector3(1, 6, 16))
	WorldKit.blocker(_world, Vector3(-34, 3, 161), Vector3(20, 6, 1))
	WorldKit.blocker(_world, Vector3(-66, 3, 163), Vector3(14, 6, 1))
	WorldKit.blocker(_world, Vector3(-101, 3, 58), Vector3(1, 6, 12))
	WorldKit.blocker(_world, Vector3(-9, 3, 58), Vector3(1, 6, 12))
	WorldKit.blocker(_world, Vector3(-80, 3, 172), Vector3(30, 6, 1))
	var eliot_dir := (ELIOT_B - ELIOT_A).normalized()
	var stop := C2 + eliot_dir * 14.0
	var eb := WorldKit.blocker(_world, Vector3(stop.x, 3, stop.y), Vector3(12, 6, 1))
	eb.rotation.y = atan2(eliot_dir.x, eliot_dir.y)


func _windows(origin: Vector2, run: int, h: float, solid: Array, i: int, j: int) -> void:
	## Janelas escuras nas faces voltadas para espaços abertos; algumas tábuas pregadas.
	var dark := TexFactory.flat(Color(0.02, 0.02, 0.03))
	var board := M_WOOD
	for k in run:
		var cx := origin.x + (k + 0.5) * CELL
		var faces := [[0, -1, Vector3(cx, 0, origin.y - 0.03), false], [0, 1, Vector3(cx, 0, origin.y + CELL + 0.03), false]]
		for f: Array in faces:
			var jj: int = j + int(f[1])
			if jj < 0 or jj >= GD or solid[jj][i + k]:
				continue
			for fl: float in [1.5, 4.2]:
				if fl + 1.0 > h:
					continue
				var p: Vector3 = f[2]
				WorldKit.box(_world, Vector3(p.x, fl, p.z), Vector3(1.0, 1.3, 0.04), board if _rng.randf() < 0.3 else dark, false)
	for side: int in [-1, 1]:
		var ii := i + (run if side == 1 else -1)
		if ii < 0 or ii >= GW or solid[j][ii]:
			continue
		var x := origin.x + (run * CELL if side == 1 else 0.0) + 0.03 * side
		for fl2: float in [1.5, 4.2]:
			if fl2 + 1.0 > h:
				continue
			WorldKit.box(_world, Vector3(x, fl2, origin.y + CELL * 0.5), Vector3(0.04, 1.3, 1.0), board if _rng.randf() < 0.3 else dark, false)


func _build_vestibules() -> void:
	## Portais escuros e fundos [C "yawning vestibule", "gaping doorway"]: a célula de 4 m fica vazia
	## (as casas vizinhas da grade são as paredes); só a verga e a escuridão interna são acrescentadas.
	var dark := TexFactory.flat(Color(0.015, 0.015, 0.02))
	for id: String in VESTIBULES.keys():
		var r: Rect2 = VESTIBULES[id]
		var c := r.get_center()
		WorldKit.box(_world, Vector3(c.x, 3.4, c.y), Vector3(r.size.x, 1.6, r.size.y), M_CLAP)
		WorldKit.box(_world, Vector3(c.x, 1.3, c.y), Vector3(r.size.x - 0.4, 2.6, r.size.y - 0.4), dark, false)
	_inter("map_portal", Vector3(-46.0, 1.2, 130.0), Vector3(1.6, 2.0, 1.6),
		func() -> String: return "Consultar o mapa à lanterna" if phase == "plan" else "",
		func(_i: Interactable) -> void: _consult_map())


func is_hidden() -> bool:
	if player.is_flashlight_on():
		return false
	var p := Vector2(player.global_position.x, player.global_position.z)
	for r: Rect2 in VESTIBULES.values():
		if r.grow(-0.2).has_point(p):
			return true
	if phase in ["cut", "procession"] and player.crouching and p.y < -232.0 and p.y > -250.0:
		return true
	return false


func is_in_moon() -> bool:
	var p := Vector2(player.global_position.x, player.global_position.z)
	if p.distance_to(C1) < C1_R + 2.0 or p.distance_to(C2) < C2_R + 2.0:
		return true
	if Rect2(-72, 100, 64, 16).has_point(p):
		return true
	return _dist_to_eliot(p) < ELIOT_W and p.y < 160.0


func _nofog(c: Color, emissive: bool = false) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.roughness = 1.0
	m.disable_fog = true
	if emissive:
		m.emission_enabled = true
		m.emission = c
		m.emission_energy_multiplier = 2.5
	return m


# ================================================================ mar e Devil Reef

func _build_sea() -> void:
	# A South Street desce em declive até o porto [C "a slight declivity to the waterfront"]:
	# a cidade fica ~12 m acima do mar, e da praça se domina a vista do recife.
	var slope_len := sqrt(78.0 * 78.0 + 12.0 * 12.0)
	var down := WorldKit.box(_world, Vector3(23, -6.1, 108), Vector3(slope_len, 0.2, 16), M_COBBLE)
	down.rotation.z = -atan(12.0 / 78.0)
	for x in range(-6, 38, 8):
		for side: float in [96.0, 120.0]:
			var h := _rng.randf_range(4.0, 7.0)
			var base := _ground_y(x + 4.0)
			WorldKit.box(_world, Vector3(x + 4.0, base + (h - 3.0) * 0.5, side), Vector3(8.0, h + 3.0, 8.0), M_CLAP if _rng.randf() < 0.5 else M_BRICK)
	var water := StandardMaterial3D.new()
	water.albedo_color = Color(0.03, 0.05, 0.08)
	water.roughness = 0.25
	water.metallic_specular = 0.7
	WorldKit.box(_world, Vector3(480, SEA_Y, 110), Vector3(840, 0.1, 900), water, false)
	for wz: float in [96.0, 104.0, 118.0, 126.0]:
		WorldKit.box(_world, Vector3(74, SEA_Y + 0.9, wz), Vector3(24, 0.5, 2.5), M_WOOD, false)
	WorldKit.box(_world, Vector3(150, SEA_Y + 0.7, 60), Vector3(5, 1.6, 120), _nofog(Color(0.08, 0.08, 0.09)), false)
	# Devil Reef: linha negra baixa a mais de uma milha (comprimida) [C].
	WorldKit.box(_world, Vector3(260, SEA_Y + 0.6, 110), Vector3(8, 1.6, 120), _nofog(Color(0.0, 0.0, 0.0)), false)
	for rz: float in [70.0, 112.0, 150.0]:
		var f := WorldKit.box(_world, Vector3(256, SEA_Y + 3.5, rz), Vector3(6, 6, 6), _nofog(Color(1.0, 0.9, 0.7), true), false)
		f.visible = false
		_reef_flashes.append(f)
	_reef_glow = WorldKit.box(_world, Vector3(256, SEA_Y + 2.7, 110), Vector3(6, 4, 18), _nofog(Color(0.45, 0.55, 0.35), true), false)
	_reef_glow.visible = false
	# Lua quase cheia, amarelada [C "mocking yellow moon"].
	var moon := MeshInstance3D.new()
	var ms := SphereMesh.new()
	ms.radial_segments = 8
	ms.rings = 4
	ms.radius = 22.0
	ms.height = 44.0
	moon.mesh = ms
	moon.material_override = _nofog(Color(0.95, 0.90, 0.70), true)
	moon.position = Vector3(-500, 420, 700)
	_world.add_child(moon)
	# Caminho de luar na água: as cabeças escuras aparecem em silhueta [O, recurso de leitura].
	WorldKit.box(_world, Vector3(180, SEA_Y + 0.08, 110), Vector3(240, 0.04, 22), _nofog(Color(0.17, 0.19, 0.23)), false)
	# Nadadores: cabeças e braços escuros rumo à cidade (MultiMesh barato).
	_swimmers = MultiMeshInstance3D.new()
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	var sm := SphereMesh.new()
	sm.radial_segments = 8
	sm.rings = 4
	sm.radius = 1.2
	sm.height = 2.2
	mm.mesh = sm
	mm.instance_count = 110
	for k in mm.instance_count:
		var p := Vector3(_rng.randf_range(95, 245), SEA_Y + 0.4, _rng.randf_range(99, 121))
		_swim_pos.append(p)
		mm.set_instance_transform(k, Transform3D(Basis.IDENTITY, p))
	_swimmers.multimesh = mm
	_swimmers.material_override = _nofog(Color(0.02, 0.03, 0.03))
	_swimmers.visible = false
	_world.add_child(_swimmers)
	# Bote com carga volumosa sob lona [C].
	_rowboat = Node3D.new()
	_rowboat.position = Vector3(200, SEA_Y + 0.5, 112)
	_world.add_child(_rowboat)
	WorldKit.box(_rowboat, Vector3(0, 0, 0), Vector3(6, 0.8, 2.4), _nofog(Color(0.05, 0.04, 0.03)), false)
	WorldKit.box(_rowboat, Vector3(0.5, 0.9, 0), Vector3(2.6, 1.2, 1.8), _nofog(Color(0.16, 0.15, 0.11)), false)
	_rowboat.visible = false


func _ground_y(x: float) -> float:
	## Encosta da South Street: começa na borda da praça (x = −16) e desce 12 m até o porto.
	return -12.0 * clampf((x + 16.0) / 78.0, 0.0, 1.0)


func _show_signals_static() -> void:
	_swimmers.visible = true


# ================================================================ Bank Street, estação, desfiladeiro, ponte

func _build_bank_and_gorge() -> void:
	WorldKit.box(_world, Vector3(-146, -0.1, -18), Vector3(108, 0.2, 20), M_COBBLE)
	# Armazéns enormes de tijolo ao sul da Bank Street [C].
	for k in 4:
		var x := -110.0 - k * 20.0
		WorldKit.box(_world, Vector3(x, 6.0, -13.0), Vector3(19.0, 12.0, 14.0), M_BRICK)
	WorldKit.box(_world, Vector3(-190, 4.0, -10), Vector3(12, 8, 8), M_BRICK)
	# Parapeito do desfiladeiro [C].
	WorldKit.box(_world, Vector3(-152, 0.5, -28.3), Vector3(116, 1.0, 0.2), TexFactory.flat(Color(0.10, 0.10, 0.11)), false)
	WorldKit.blocker(_world, Vector3(-153.5, 2, -28.6), Vector3(127, 4, 0.5))
	WorldKit.blocker(_world, Vector3(-251.5, 2, -80.5), Vector3(57, 4, 0.5))
	WorldKit.blocker(_world, Vector3(-188.5, 2, -80.5), Vector3(57, 4, 0.5))
	WorldKit.blocker(_world, Vector3(-91.5, 2, -22), Vector3(0.5, 4, 12))
	WorldKit.box(_world, Vector3(-219, -0.1, -17), Vector3(40, 0.2, 22), M_DIRT)
	WorldKit.blocker(_world, Vector3(-251, 2, -28.6), Vector3(56, 4, 0.5))
	WorldKit.blocker(_world, Vector3(-238, 2, -20), Vector3(1, 4, 20))
	# Fundo do desfiladeiro e rio Manuxet lá embaixo.
	WorldKit.box(_world, Vector3(-170, -30, -54), Vector3(220, 0.4, 52), TexFactory.flat(Color(0.02, 0.03, 0.04)), true)
	# Estação em arcadas [C].
	var st := Node3D.new()
	_world.add_child(st)
	WorldKit.box(st, Vector3(-190, 4.6, -22), Vector3(12, 0.4, 12), M_SLATE, false)
	for px: float in [-195.5, -192, -188.5, -185]:
		for pz: float in [-27.5, -16.5]:
			WorldKit.box(st, Vector3(px, 2.2, pz), Vector3(0.7, 4.4, 0.7), M_BRICK)
	# Trilhos: da estação para oeste pela beira, depois para o norte pela ponte.
	_rails(Vector3(-196, 0, -22), Vector3(-220, 0, -22))
	_rails(Vector3(-220, 0, -22), Vector3(-220, 0, -28))
	# Ponte coberta, longa como um celeiro [C].
	var y0 := 0.0
	WorldKit.box(_world, Vector3(-220, y0 - 0.1, -40.0), Vector3(6, 0.2, 24.0), M_WOOD)
	WorldKit.box(_world, Vector3(-220, y0 - 0.1, -67.25), Vector3(6, 0.2, 25.5), M_WOOD)
	for z in range(-29, -80, -1):
		if z <= -52 and z >= -54:
			continue
		WorldKit.box(_world, Vector3(-220, y0 + 0.03, z), Vector3(2.6, 0.06, 0.25), TexFactory.flat(Color(0.12, 0.08, 0.05)), false)
	for side: float in [-223.2, -216.8]:
		WorldKit.wall_z(_world, side, -80.0, -28.0, 0.0, 4.2, M_WOOD, [Vector4(-62.0, -60.5, 1.4, 2.2), Vector4(-40.0, -38.5, 1.4, 2.2)], 0.2)
	WorldKit.box(_world, Vector3(-220, 4.3, -40.25), Vector3(6.8, 0.2, 24.5), M_SLATE, false)
	WorldKit.box(_world, Vector3(-220, 4.3, -67.0), Vector3(6.8, 0.2, 26.0), M_SLATE, false)
	# Abertura no telhado sobre o vão: o luar revela o perigo antes da lanterna.
	WorldKit.omni(_world, Vector3(-220, 3.6, -53.2), Color(0.55, 0.62, 0.85), 0.9, 5.0)
	_inter("bridge_gap", Vector3(-220, 0.6, -51.6), Vector3(3.0, 1.2, 0.6),
		func() -> String: return "Saltar o vão" if phase == "bridge" else "",
		func(_i: Interactable) -> void: _jump_gap())
	# Margem norte, River Street.
	WorldKit.box(_world, Vector3(-220, -0.3, -230), Vector3(260, 0.2, 300), TexFactory.material("marsh", 3.0))
	WorldKit.box(_world, Vector3(-220, -0.15, -87), Vector3(160, 0.1, 6), M_DIRT, false)


func _rails(a: Vector3, b: Vector3) -> void:
	var d := b - a
	var mid := (a + b) * 0.5
	var yaw := atan2(d.x, d.z)
	WorldKit.box(_world, Vector3(mid.x, -0.02, mid.z), Vector3(3.0, 0.1, d.length() + 1.0), TexFactory.material("ballast", 2.0), false, yaw)
	for off: float in [-0.72, 0.72]:
		var o := Vector3(cos(yaw), 0, -sin(yaw)) * off
		WorldKit.box(_world, Vector3(mid.x, 0.12, mid.z) + o, Vector3(0.1, 0.12, d.length()), TexFactory.flat(Color(0.20, 0.13, 0.09)), false, yaw)


# ================================================================ pântano, corte, estrada de Rowley

func _build_marsh() -> void:
	# Aterro baixo e trilhos para noroeste (comprimido para o norte) [C].
	WorldKit.box(_world, Vector3(-220, -0.15, -142), Vector3(6, 0.3, 124), M_DIRT)
	_rails(Vector3(-220, 0, -80), Vector3(-220, 0, -250))
	WorldKit.blocker(_world, Vector3(-236, 2, -165), Vector3(1, 4, 170))
	WorldKit.blocker(_world, Vector3(-204, 2, -165), Vector3(1, 4, 170))
	WorldKit.blocker(_world, Vector3(-220, 2, -252), Vector3(40, 4, 1))
	var water := TexFactory.flat(Color(0.03, 0.05, 0.06))
	for k in 14:
		var p := Vector3(_rng.randf_range(-300, -140), -0.18, _rng.randf_range(-330, -90))
		if absf(p.x + 220) < 10:
			continue
		WorldKit.box(_world, p, Vector3(_rng.randf_range(8, 22), 0.05, _rng.randf_range(6, 18)), water, false)
	# Mato e espinheiros ao longo do aterro.
	var bush := TexFactory.flat(Color(0.09, 0.12, 0.07))
	for k2 in 160:
		var side := -1.0 if k2 % 2 == 0 else 1.0
		var z := _rng.randf_range(-245, -88)
		var x := -220 + side * _rng.randf_range(3.4, 12.0)
		var h := _rng.randf_range(0.6, 1.6)
		WorldKit.box(_world, Vector3(x, h * 0.5 - 0.2, z), Vector3(_rng.randf_range(0.8, 2.0), h, _rng.randf_range(0.8, 2.0)), bush, false, _rng.randf() * PI)
	# Corte raso entre barrancos com arbustos [C]; termina onde as paredes se aplainam.
	for sx: float in [-226.0, -214.0]:
		WorldKit.box(_world, Vector3(sx, 1.2, -222), Vector3(6, 2.6, 34), M_DIRT)
		for k3 in 10:
			WorldKit.box(_world, Vector3(sx + (2.6 if sx < -220 else -2.6), 2.8, -238 + k3 * 3.4), Vector3(1.6, 1.0, 1.8), bush, false)
	WorldKit.slope(_world, Vector3(-226, 0.6, -242.5), Vector3(6, 0.2, 5.5), -0.42, M_DIRT)
	WorldKit.slope(_world, Vector3(-214, 0.6, -242.5), Vector3(6, 0.2, 5.5), -0.42, M_DIRT)
	for k4 in 6:
		WorldKit.box(_world, Vector3(-222.8 + (k4 % 2) * 5.6, 0.25, -234 - k4 * 1.5), Vector3(1.2, 0.7, 1.2), bush, false)
	# Estrada de Rowley, cruzando a linha à frente do corte.
	WorldKit.box(_world, Vector3(-240, -0.12, -266), Vector3(300, 0.1, 7), M_DIRT, false)
	# Coluna ondulante distante na estrada de Ipswich [C], vista de costas para a cidade.
	for k5 in 60:
		var c := WorldKit.box(_world, Vector3(-260 + k5 * 3.0, 0.8, 470 + sin(k5 * 0.5) * 6.0), Vector3(1.2, 1.4, 1.2), _nofog(Color(0.45, 0.52, 0.45), true), false)
		c.visible = false
		_column.append(c)


# ================================================================ sentinelas e grupos

func _figures(id: String, count: int, opts: Dictionary = {}) -> void:
	var nodes: Array = []
	for k in count:
		var robed: bool = (opts.get("robed", []) as Array).has(k)
		var tiara: bool = (opts.get("tiara", []) as Array).has(k)
		var f := WorldKit.figure(_world, Vector3.ZERO, 1.55 + _rng.randf() * 0.35, robed, tiara)
		var light: OmniLight3D = null
		if (opts.get("lanterns", []) as Array).has(k):
			light = WorldKit.omni(f, Vector3(0.3, 1.1, -0.25), Color(1.0, 0.62, 0.3), 1.6, 7.0)
			WorldKit.box(f, Vector3(0.3, 1.0, -0.25), Vector3(0.14, 0.2, 0.14), TexFactory.flat(Color(1, 0.7, 0.3), true), false)
		var off := Vector3((k % 3 - 1) * 1.1, 0, -floorf(k / 3.0) * 1.3) if k > 0 else Vector3.ZERO
		nodes.append({"node": f, "off": off, "phase": _rng.randf() * TAU, "hop": tiara or bool(opts.get("hop_all", false)), "light": light})
	_group_nodes[id] = nodes


func _build_sentinels() -> void:
	## Ruas vigiadas ao fundo [O]: barreiras visíveis com percepção real.
	var sentries: Dictionary = {
		"sentry_south": [Vector3(14, -4.6, 108), Vector3(-1, 0, 0), 30.0],
	}
	for id: String in sentries.keys():
		var s: Array = sentries[id]
		var pos: Vector3 = s[0]
		var path: Array[Vector3] = [pos, pos + (s[1] as Vector3) * 0.5]
		var g := director.add_group(id, path, 0.0, {"range": s[2], "members": 2, "hold": true})
		g.heading = s[1]
		_figures(id, 2, {"lanterns": [0]})


func _add_bates_pair() -> void:
	var path: Array[Vector3] = [Vector3(-10, 0, 58), Vector3(-30, 0, 58), Vector3(-62, 0, 58), Vector3(-96, 0, 58)]
	director.add_group("bates_pair", path, 1.3, {"range": 24.0, "members": 2, "hold": true})
	_figures("bates_pair", 2)


func _add_ipswich() -> void:
	var start := ELIOT_A + (C2 - ELIOT_A) * 0.2
	var path: Array[Vector3] = [Vector3(start.x, 0, start.y), Vector3(C2.x, 0, C2.y), Vector3(ELIOT_B.x, 0, ELIOT_B.y)]
	director.add_group("ipswich_car", path, 9.0, {"perceive": false, "hold": true})
	director.add_group("ipswich_party", path, 2.8, {"range": 30.0, "members": 8, "hold": true})
	_figures("ipswich_party", 8, {"robed": [1, 4], "tiara": [4], "lanterns": [0, 5]})
	_car = Node3D.new()
	_world.add_child(_car)
	WorldKit.box(_car, Vector3(0, 0.9, 0), Vector3(1.8, 1.4, 4.0), TexFactory.flat(Color(0.06, 0.06, 0.06)), false)
	var hl := SpotLight3D.new()
	hl.light_color = Color(1.0, 0.85, 0.6)
	hl.light_energy = 3.0
	hl.spot_range = 22.0
	hl.position = Vector3(0, 0.9, -2.1)
	_car.add_child(hl)
	_car.position = path[0]
	_car_sound = _loop3d("sfx_motor", path[0], 2.0, 10.0)


func _add_band() -> void:
	var path: Array[Vector3] = [Vector3(-34, 0, 80), Vector3(-34, 0, 92), Vector3(-34, 0, 168)]
	var g := director.add_group("band", path, 1.6, {"range": 45.0, "min_df": 0.5, "members": 8, "hold": false})
	g.set_meta("hold_at", 1)
	_figures("band", 8, {"robed": [2], "tiara": [2], "lanterns": [0, 6]})


# ================================================================ áudio

func _build_audio() -> void:
	_amb_wind = _loop("amb_wind", -12.0)
	_amb_drone = _loop("amb_drone", -24.0)
	_amb_sea = _loop3d("amb_sea", Vector3(70, -12, 108), 4.0, 30.0)
	_amb_falls = _loop3d("amb_falls", Vector3(-150, -10, -45), 6.0, 40.0)
	_federal_sound = _loop3d("sfx_patter", Vector3(30, 0, 40), -60.0, 12.0)
	_flop = _loop3d("sfx_flop", Vector3(-120, 0, -266), -80.0, 30.0)


func _update_ambience() -> void:
	if _amb_drone == null:
		return
	var danger := phase in ["bates", "crossing", "hide_portal", "babson", "lafayette", "south2"]
	_fade_db(_amb_drone, -15.0 if danger else -24.0)
	if phase in ["marsh", "cut"]:
		_fade_db(_amb_wind, -8.0)


func _on_footstep(_surface: String, loud: float) -> void:
	var p := player.global_position
	var id := "sfx_step_stone"
	if p.x < -205.0 and p.z < -28.0:
		id = "sfx_step_wood" if p.z > -80.0 else "sfx_slate"
	app.play_sound(id, Vector3.INF, linear_to_db(0.12 + loud * 0.3), randf_range(0.9, 1.1))
	# Audição (docs/11 §4.2): corrida 14 m, passo 6 m, arrastado 3 m; quedas reduzem a 10 %.
	var radius := 6.0
	if player.running:
		radius = 14.0
	elif player.crouching:
		radius = 0.0
	elif player.shambling:
		radius = 3.0
	if p.x < -88.0 and p.z < -6.0:
		radius *= 0.1
	if radius > 0.0:
		_director_events(director.noise(p, radius))


# ================================================================ laço

func _physics_process(delta: float) -> void:
	if player == null or _failed or capture_mode:
		return
	_update_director(delta)
	_update_triggers(delta)
	_update_spectacle(delta)
	if player.global_position.y < -6.0:
		_fail("FALL_GAP" if phase == "bridge" else "FALL")


func _gait() -> String:
	var hs := Vector2(player.velocity.x, player.velocity.z).length()
	if player.running and hs > 0.5:
		return "run"
	if player.crouching:
		return "crouch"
	if hs < 0.3:
		return "still"
	if player.shambling:
		return "shamble"
	return "walk"


func _los(from: Vector3, to: Vector3) -> bool:
	var space := get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(from, to, 1)
	q.exclude = [player.get_rid()]
	return space.intersect_ray(q).is_empty()


func _update_director(delta: float) -> void:
	var info := {
		"pos": player.global_position,
		"gait": _gait(),
		"in_moon": is_in_moon(),
		"hidden": is_hidden() or qa_ghost,
		"flash": player.is_flashlight_on(),
	}
	_director_events(director.advance(delta, info))
	# Pontos de espera roteirizados (o bando para fora da vista até o jogador chegar).
	var band := director.get_group("band")
	if band and band.has_meta("hold_at") and band.state == "patrol" and band.idx > int(band.get_meta("hold_at")):
		band.remove_meta("hold_at")
		if _band_stage == 0:
			band.state = "hold"
	if band and band.state == "hold" and _band_stage == 1:
		director.release("band")
	for id: String in _group_nodes.keys():
		var g := director.get_group(id)
		if g == null:
			continue
		var nodes: Array = _group_nodes[id]
		var basis := Basis.looking_at(g.heading if g.heading.length() > 0.1 else Vector3.FORWARD, Vector3.UP)
		for n: Dictionary in nodes:
			var node: Node3D = n["node"]
			var moving := g.state in ["patrol", "chasing", "returning"]
			n["phase"] = float(n["phase"]) + delta * (8.0 if n["hop"] else 4.5) * (1.0 if moving else 0.25)
			var target := g.pos + basis * (n["off"] as Vector3)
			node.global_position = Vector3(target.x, g.pos.y + absf(sin(float(n["phase"]))) * (0.25 if n["hop"] else 0.05), target.z)
			node.basis = basis
			if n["light"]:
				(n["light"] as OmniLight3D).light_energy = 1.4 + 0.3 * sin(float(n["phase"]) * 3.0)
	var car := director.get_group("ipswich_car")
	if car and _car:
		_car.global_position = car.pos
		_car.basis = Basis.looking_at(car.heading, Vector3.UP)
		_car_sound.global_position = car.pos


func _director_events(evs: Array[String]) -> void:
	for ev: String in evs:
		var parts := ev.split(":")
		match parts[0]:
			"suspicious":
				if parts[1].begins_with("sentry"):
					_see("uma lanterna se volta para cá", 3.0)
				else:
					_see("um deles para e olha", 3.0)
				app.play_sound("sfx_croak", _group_pos(parts[1]) + Vector3(0, 1.4, 0), 0.0)
			"alert":
				app.play_sound("sfx_croak_low", _group_pos(parts[1]) + Vector3(0, 1.4, 0), 6.0)
				app.play_sound("sfx_croak", _group_pos(parts[1]) + Vector3(0, 1.4, 0), 6.0, 0.8)
				_caption("um chamado gutural — eles vêm!", 4.0)
				_think("Sair da vista deles — um portal, uma esquina!", 3.0)
			"lost":
				_caption("os passos se espalham, procurando — depois se afastam", 4.0)
			"done":
				_on_group_done(parts[1])
			"reached":
				# O grupo de Ipswich passa pelo espaço aberto da Babson: a rota adiante se abre.
				if parts[1] == "ipswich_party" and parts[2] == "1" and state.set_fact("ipswich_party_seen"):
					_note(N.NOTES["ipswich"])
					_think(N.THOUGHTS["ipswich"], 5.0)
			"fail":
				_fail(parts[1])


func _group_pos(id: String) -> Vector3:
	var g := director.get_group(id)
	return g.pos if g else player.global_position


func _on_group_done(id: String) -> void:
	match id:
		"bates_pair":
			_remove_group(id)
		"ipswich_car":
			if _car:
				_car.queue_free()
				_car = null
				_car_sound.queue_free()
			director.remove(id)
		"ipswich_party":
			_remove_group(id)
			if state.set_fact("ipswich_party_seen"):
				_note(N.NOTES["ipswich"])
		"band":
			_remove_group(id)
			if state.set_fact("band_passed"):
				_note(N.NOTES["band"])
				_think(N.THOUGHTS["band_ok"], 5.0)


func _remove_group(id: String) -> void:
	for n: Dictionary in _group_nodes.get(id, []):
		(n["node"] as Node3D).queue_free()
	_group_nodes.erase(id)
	director.remove(id)


func _fail(code: String) -> void:
	if _failed:
		return
	_failed = true
	player.controls_enabled = false
	app.play_sound("sfx_croak_low", player.global_position + Vector3(1.0, 1.4, 0.0), 6.0)
	var lan := WorldKit.omni(_world, player.global_position + Vector3(0.8, 1.6, 0.8), Color(1.0, 0.6, 0.3), 3.0, 8.0)
	lan.visible = code == "CAPTURE"
	failed.emit(N.FAIL.get(code, N.FAIL["CAPTURE"]))


# ================================================================ gatilhos da rota canônica

func _in(r: Rect2) -> bool:
	return r.has_point(Vector2(player.global_position.x, player.global_position.z))


func _update_triggers(delta: float) -> void:
	var p := player.global_position
	var p2 := Vector2(p.x, p.z)
	match phase:
		"washington":
			if p.z > 30.0 and not state.has_fact("bates_passed"):
				_add_bates_pair()
				_bates_t = 0.0
				_set_phase("bates")
				_think(N.THOUGHTS["bates_warn"], 4.0)
				_caption("passos arrastados à frente, vindos do leste pela Bates", 4.0)
		"bates":
			_bates_t += delta
			var pair := director.get_group("bates_pair")
			if pair and pair.state == "hold" and (is_hidden() or p.z > 42.0 or _bates_t > 10.0):
				director.release("bates_pair")
			if (pair == null or pair.pos.x < -66.0) and not state.has_fact("bates_passed"):
				state.set_fact("bates_passed")
				_think(N.THOUGHTS["bates_ok"], 3.0)
				_set_phase("crossing")
		"crossing":
			if p.z > 80.0 and app.state.checkpoint != "cp07_south_crossing":
				app.save_checkpoint("cp07_south_crossing")
				_think(N.THOUGHTS["open_space"], 6.0)
			if p2.distance_to(C1) < C1_R and p.z > 100.0 and p.x > -40.0 and _signal_t < 0.0:
				_start_signals()
			if _signal_t >= 0.0:
				_signal_t += delta
				if _signal_t > 5.5 and _swim_t < 0.0:
					_start_swimmers()
		"hide_portal":
			if _in(VESTIBULES["v_portal"]):
				_set_phase("plan")
				_think(N.THOUGHTS["portal"], 6.0)
		"babson":
			if p.z > 142.0 and p.x < -44.0 and _ipswich_t < 0.0:
				_add_ipswich()
				director.release("ipswich_car")
				_ipswich_t = 0.0
				_caption("um motor se aproxima pela Eliot", 3.0)
			if _ipswich_t >= 0.0:
				_ipswich_t += delta
				var party := director.get_group("ipswich_party")
				if party and party.state == "hold" and _ipswich_t > 2.0:
					director.release("ipswich_party")
					_see("um bando agachado segue o carro pela Eliot, aos saltos", 4.0)
			if state.has_fact("ipswich_party_seen") and p.x < -58.0:
				_set_phase("lafayette")
				_think(N.THOUGHTS["stragglers"], 3.5)
				_add_band()
		"lafayette":
			if Rect2(-72, 100, 12, 18).has_point(p2):
				_set_phase("south2")
				_band_stage = 1
				director.release("band")
				_rowboat.visible = true
				_reef_glow.visible = true
				_cupola_light.light_energy = 0.0
				state.set_fact("rowboat_seen")
				_think(N.THOUGHTS["rowboat"], 6.0)
				_after(3.0, func() -> void:
					_think(N.THOUGHTS["band"], 5.0)
					_caption("murmúrio de um bando, a uma quadra, na Washington", 4.0))
		"south2":
			if p.z < 64.0 and p.x < -58.0:
				_set_phase("adams")
		"adams":
			if p.x < -88.0 and p.z < 40.0 and _drunk == null and not state.has_fact("drunk_seen"):
				_start_drunk()
			if p.z < -16.0 and p.x < -88.0:
				state.set_fact("bank_reached")
				app.save_checkpoint("cp07_bank_street")
				_set_phase("bank")
				_think(N.THOUGHTS["bank"], 5.0)
		"bank":
			if p.x < -186.0:
				_set_phase("tracks")
				_think(N.THOUGHTS["station"], 5.0)
		"tracks":
			if p.x < -212.0 and p.z < -24.0:
				app.save_checkpoint("cp07_bridge")
				_set_phase("bridge")
				_think(N.THOUGHTS["bridge"], 4.0)
		"bridge":
			if p.z < -33.0 and not state.has_fact("bats_seen"):
				_start_bats()
			if p.z < -82.0:
				state.set_fact("marsh_reached")
				_set_phase("marsh")
				_think(N.THOUGHTS["marsh"], 5.0)
				_env.fog_density = 0.006
		"marsh":
			if p.z < -170.0 and not state.has_fact("column_seen"):
				state.set_fact("column_seen")
				_think(N.THOUGHTS["look_back"], 5.0)
				for c in _column:
					c.visible = true
				_after(5.0, func() -> void:
					_think(N.THOUGHTS["column"], 6.0)
					_note(N.NOTES["column"]))
			if p.z < -204.0:
				app.save_checkpoint("cp07_cut")
				_set_phase("cut")
				_start_wind_shift()
		"cut":
			if is_hidden():
				_start_procession()
	if _drunk_t >= 0.0:
		_drunk_t += delta


# ================================================================ eventos

func _start_signals() -> void:
	## evt_reef_signals [C]: clarões no recife e resposta da cúpula do Gilman.
	_signal_t = 0.0
	state.set_fact("reef_signals_seen")
	_note(N.NOTES["signals"])
	_think(N.THOUGHTS["signals"], 6.0)
	_see("clarões intermitentes no recife — e uma resposta, da cúpula do Gilman, a nordeste", 5.0)


func _start_swimmers() -> void:
	## evt_swimmers [C] seguido de pânico, clamor à esquerda e motor na Federal.
	_swim_t = 0.0
	_swimmers.visible = true
	state.set_fact("swimmers_seen")
	_note(N.NOTES["swimmers"])
	_think(N.THOUGHTS["swimmers"], 5.0)
	_after(5.0, func() -> void:
		_think(N.THOUGHTS["run"], 5.0)
		_caption("clamor de perseguição à esquerda; um motor chacoalha para o sul pela Federal", 5.0)
		state.set_fact("motor_heard")
		_fade_db(_federal_sound, 4.0, 1.0)
		var tw := create_tween()
		tw.tween_property(_federal_sound, "global_position", Vector3(30, 0, 170), 18.0)
		_set_phase("hide_portal"))


func _consult_map() -> void:
	state.set_fact("railway_plan")
	_note(N.NOTES["plan"])
	app.save_checkpoint("cp07_babson")
	_set_phase("babson")
	_fade_db(_federal_sound, -60.0, 6.0)
	_open_doc("doc_sketch_map")
	_after(0.5, func() -> void: _think(N.THOUGHTS["plan"], 6.0))


func _start_drunk() -> void:
	## evt_drunk_adams [C]: susto sem perigo.
	state.set_fact("drunk_seen")
	_drunk = WorldKit.figure(_world, Vector3(-102.0, 0, 30.0), 1.7)
	_drunk.rotation.z = 0.25
	var tw := create_tween()
	tw.tween_property(_drunk, "position", Vector3(-97.5, 0, 26.5), 1.4).set_trans(Tween.TRANS_BOUNCE)
	tw.tween_property(_drunk, "rotation:z", -0.3, 1.2)
	tw.tween_property(_drunk, "position", Vector3(-99.0, 0, 34.0), 4.0)
	app.play_sound("sfx_thud", Vector3(-100.0, 1.0, 29.0), 2.0)
	app.play_sound("sfx_breath", Vector3(-99.0, 1.4, 28.0), 0.0)
	_think(N.THOUGHTS["drunk"], 5.0)
	_drunk_t = 0.0


func _start_bats() -> void:
	state.set_fact("bats_seen")
	app.play_sound("sfx_bats", Vector3(-220, 2.5, -45.0), 6.0)
	_think(N.THOUGHTS["bats"], 3.0)
	player.add_shake(0.6)
	for k in 36:
		var b := WorldKit.box(_world, Vector3(-220 + randf_range(-2, 2), randf_range(1.5, 3.6), -62.0 + randf_range(-4, 4)), Vector3(0.22, 0.05, 0.12), TexFactory.flat(Color(0.03, 0.03, 0.03)), false)
		var tw := b.create_tween()
		var target := player.global_position + Vector3(randf_range(-1.5, 1.5), randf_range(0.8, 2.6), randf_range(4, 14))
		tw.tween_property(b, "position", target, randf_range(1.0, 1.8))
		tw.tween_callback(b.queue_free)


func _jump_gap() -> void:
	## pz11_bridge_gap [C "a desperate jump which fortunately succeeded"].
	busy = true
	player.controls_enabled = false
	player.set_physics_process(false)
	_think(N.THOUGHTS["gap"], 2.0)
	var start := player.global_position
	var tw := create_tween()
	tw.tween_property(player, "global_position", Vector3(-220, start.y + 0.9, -53.2), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(player, "global_position", Vector3(-220, 0.05, -55.4), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tw.finished
	if not is_inside_tree():
		return
	app.play_sound("sfx_thud", Vector3.INF, 2.0)
	player.add_shake(1.0)
	player.set_physics_process(true)
	player.controls_enabled = true
	busy = false
	state.set_fact("gap_jumped")
	_think(N.THOUGHTS["gap_ok"], 3.0)


func _start_wind_shift() -> void:
	if state.set_fact("wind_shift_seen") or phase == "cut":
		_env.fog_density = 0.014
		_env.fog_light_color = Color(0.07, 0.08, 0.07)
		_think(N.THOUGHTS["wind"], 5.0)
		_after(4.0, func() -> void: _think(N.THOUGHTS["cut"], 5.0))
		_fade_db(_flop, -12.0, 8.0)
		_caption("murmúrios guturais a leste; um tamborilar colossal, úmido", 5.0)


# ================================================================ a procissão (evt_rowley_procession)

func _start_procession() -> void:
	_set_phase("procession")
	_proc_t = 0.0
	player.crouching = true
	player.controls_enabled = false
	player.look_enabled = true
	app.ui.set_status("Segure [%s] para fechar os olhos" % InputSetup.key_name(app._key_for("close_eyes")))
	_think(N.THOUGHTS["close"], 4.0)
	_sun.light_color = Color(1.0, 0.88, 0.58)
	# Lua amarela "leering" [C]: horizonte claro para recortar as silhuetas.
	_sky.sky_horizon_color = Color(0.22, 0.20, 0.13)
	_env.fog_density = 0.005
	_env.fog_light_color = Color(0.14, 0.13, 0.09)
	_fade_db(_flop, 4.0, 10.0)
	var rng := RandomNumberGenerator.new()
	rng.seed = 1846
	# Líder primeiro; depois tiaras, mantos e a massa. Reciclados para um fluxo "sem limite" [C].
	_leader = WorldKit.deep_one(_world, Vector3(-178, 0, -266), "leader", 1)
	_procession.append({"node": _leader, "x": -178.0, "z": -266.0, "phase": 0.0, "quad": false, "leader": true})
	for k in 36:
		var kind := "plain"
		if k % 6 == 2:
			kind = "tiara"
		elif k % 9 == 4:
			kind = "robed"
		var x := -178.0 + 3.0 + k * 2.1
		var z := -266.0 + rng.randf_range(-2.8, 2.8)
		var d := WorldKit.deep_one(_world, Vector3(x, 0, z), kind, 100 + k)
		_procession.append({"node": d, "x": x, "z": z, "phase": rng.randf() * TAU, "quad": rng.randf() < 0.35, "leader": false})
	var card_mat := TexFactory.flat(Color(0.02, 0.025, 0.025))
	for row in 3:
		for k2 in 26:
			var cx := -178.0 + k2 * 3.0 + rng.randf_range(0, 2.0)
			var cz := -272.0 - row * 4.0
			var c := WorldKit.box(_world, Vector3(cx, 0.9, cz), Vector3(0.7, 1.6 + rng.randf() * 0.5, 0.15), card_mat, false)
			_cards.append({"node": c, "x": cx, "phase": rng.randf() * TAU})


func _update_spectacle(delta: float) -> void:
	_signal_flicker(delta)
	if _swimmers.visible:
		_swim_t += delta
		var mm := _swimmers.multimesh
		for k in mm.instance_count:
			var p: Vector3 = _swim_pos[k]
			p.x = maxf(80.0, p.x - delta * 1.4)
			_swim_pos[k] = p
			var bob := sin(_swim_t * 2.5 + k) * 0.35
			mm.set_instance_transform(k, Transform3D(Basis.IDENTITY, p + Vector3(0, bob, 0)))
	if _rowboat.visible:
		_rowboat.position.x = maxf(78.0, _rowboat.position.x - delta * 2.2)
	if _column[0].visible:
		for k in _column.size():
			_column[k].position.y = 0.8 + sin(Time.get_ticks_msec() * 0.003 + k * 0.6) * 0.8
	if _proc_t >= 0.0:
		_update_procession(delta)


func _signal_flicker(_delta: float) -> void:
	if not state.has_fact("reef_signals_seen") or state.has_fact("rowboat_seen"):
		for f in _reef_flashes:
			f.visible = false
		_cupola_flash.visible = false
		return
	var t := Time.get_ticks_msec() / 1000.0
	var reef_on := fposmod(t, 1.6) < 0.35 or (fposmod(t, 4.8) > 2.0 and fposmod(t, 4.8) < 2.25)
	for f in _reef_flashes:
		f.visible = reef_on
	# Resposta com espaçamento diferente [C "differently spaced gleams"].
	var cup_on := fposmod(t + 0.8, 2.6) < 0.5
	_cupola_flash.visible = cup_on
	_cupola_light.light_energy = 2.5 if cup_on else 0.0


func _update_procession(delta: float) -> void:
	_proc_t += delta
	var holding := Input.is_action_pressed("close_eyes") and not _eyes_forced
	if holding:
		_eyes_closed_t += delta
		if _eyes_closed_t >= 18.0 or _proc_t >= 34.0:
			_eyes_forced = true
			state.set_fact("eyes_failed")
			_think(N.THOUGHTS["forced"], 5.0)
	_eyes = move_toward(_eyes, 1.0 if holding else 0.0, delta * (3.0 if holding else 1.2))
	app.ui.set_eyes(_eyes * 0.97)
	var vol := clampf(-12.0 + _proc_t * 1.2, -12.0, 6.0)
	_flop.volume_db = vol
	_flop.global_position = Vector3(player.global_position.x + 30.0 - _proc_t * 2.0, 0, -266.0)
	_croak_t -= delta
	if _croak_t <= 0.0:
		_croak_t = randf_range(0.25, 0.7)
		var id: String = "sfx_croak_low" if randi() % 3 == 0 else "sfx_croak"
		app.play_sound(id, Vector3(player.global_position.x + randf_range(-25, 25), 1.4, -266.0 + randf_range(-6, 6)), clampf(vol, -10.0, 4.0), randf_range(0.7, 1.3))
	for e: Dictionary in _procession:
		var node: Node3D = e["node"]
		e["x"] = float(e["x"]) - delta * 2.5
		if float(e["x"]) < -330.0 and not e["leader"]:
			e["x"] = float(e["x"]) + 150.0
		e["phase"] = float(e["phase"]) + delta * 7.0
		if randf() < delta * 0.15:
			e["quad"] = not e["quad"]
		var hop := absf(sin(float(e["phase"]))) * (0.45 if e["quad"] else 0.3)
		node.position = Vector3(float(e["x"]), hop, float(e["z"]))
		node.rotation.y = PI / 2 + 0.5
		(node.get_node("body") as Node3D).rotation.x = -1.0 if e["quad"] else -0.15
	for c: Dictionary in _cards:
		c["x"] = float(c["x"]) - delta * 2.5
		if float(c["x"]) < -330.0:
			c["x"] = float(c["x"]) + 78.0
		c["phase"] = float(c["phase"]) + delta * 7.0
		var cn: MeshInstance3D = c["node"]
		cn.position.x = float(c["x"])
		cn.position.y = 0.9 + absf(sin(float(c["phase"]))) * 0.3
	if _eyes < 0.3 and _proc_t > 6.0:
		if _eyes_open_since < 0.0:
			_eyes_open_since = _proc_t
			_think(N.THOUGHTS["see"], 6.0)
			_after(4.0, func() -> void: _think(N.THOUGHTS["leader"], 6.0))
		var to_leader := (_leader.global_position + Vector3(0, 1.4, 0) - player.camera.global_position).normalized()
		if -player.camera.global_basis.z.dot(to_leader) > 0.96:
			_gaze_t += delta
		var seen := _proc_t - _eyes_open_since
		if seen > 20.0 or (_gaze_t > 3.0 and seen > 8.0):
			_faint()


func debug_event(id: String) -> void:
	## Só para capturas de QA (modo --capture): encena um momento sem rodar o laço normal.
	match id:
		"signals":
			state.set_fact("reef_signals_seen")
			_swimmers.visible = true
			for f in _reef_flashes:
				f.visible = true
			_cupola_flash.visible = true
			_cupola_light.light_energy = 2.5
		"band":
			_add_band()
			var g := director.get_group("band")
			g.pos = Vector3(-34, 0, 104)
			g.heading = Vector3(0, 0, 1)
			g.state = "patrol"
			_update_director(0.016)
		"procession":
			_start_procession()
			for i in 220:
				_update_procession(0.05)


func _faint() -> void:
	## Desmaio: fim de ch07 [C "a merciful fit of fainting"].
	if _proc_t < 0.0:
		return
	_proc_t = -1.0
	app.ui.set_status("")
	state.set_fact("procession_seen")
	state.set_fact("ch07_done")
	_note(N.NOTES["procession"])
	_think(N.THOUGHTS["faint"], 6.0)
	_fade_db(_flop, -60.0, 4.0)
	await app.ui.fade_to(1.0, 4.0).finished
	if not is_inside_tree():
		return
	app.ui.set_eyes(0.0)
	app.ui.chapter_card(N.END_CARD, 3.0)
	await get_tree().create_timer(3.0, false).timeout
	app.save_checkpoint("cp08_rain")
	finished.emit()
