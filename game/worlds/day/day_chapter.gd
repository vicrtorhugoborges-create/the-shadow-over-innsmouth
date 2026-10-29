class_name DayChapter
extends ChapterBase
## ch02_forgotten_town, ch03_secrets e ch04_zadok (docs/04 §4–6): a viagem de ônibus, a cidade
## de dia com o mapa e o testemunho de Zadok Allen. Sem perigo nem falha.
## Coordenadas: +x leste (porto), −z norte; o desfiladeiro do Manuxet corre em z ∈ [−36, −20].

const D = preload("res://data/day_text.gd")
const G = preload("res://data/gilman_text.gd")
const CELL := 4.0
const GX0 := -80.0
const GZ0 := -160.0
const GW := 60
const GD := 66
const GORGE_N := -36.0
const GORGE_S := -20.0

const STREETS: Array[Rect2] = [
	Rect2(-48, -20, 56, 8),     # Paine, da praça (ao norte do Gilman) até a Washington
	Rect2(-48, -20, 8, 120),    # Washington (sul)
	Rect2(12, 8, 8, 60),        # Eliot
	Rect2(52, 0, 52, 8),        # Waite
	Rect2(100, -20, 8, 104),    # Main (sul)
	Rect2(116, -20, 8, 104),    # Fish (sul)
	Rect2(132, -20, 8, 104),    # Water (sul)
	Rect2(100, 40, 40, 8),      # travessa da orla
	Rect2(140, -20, 24, 104),   # cais da orla sul
	Rect2(24, -160, 12, 124),   # Federal (norte)
	Rect2(36, -52, 28, 8),      # rumo à Old Square
	Rect2(64, -44, 36, 8),      # margem do rio: Old Square → ponte da Main (docs/06) [I]
	Rect2(100, -148, 8, 112),   # Main (norte)
	Rect2(132, -148, 8, 112),   # Water (norte)
	Rect2(100, -88, 40, 8),     # Church
	Rect2(140, -148, 24, 112),  # cais da orla norte
	Rect2(-48, -148, 156, 8),   # Martin
	Rect2(-48, -148, 8, 112),   # Washington (norte)
	Rect2(-72, -148, 8, 112),   # Lafayette
	Rect2(-72, -100, 32, 8),    # travessa dos casarões
]
const CIRCLES: Array = [[Vector2(32, -16), 28.0], [Vector2(32, -112), 16.0], [Vector2(72, -48), 10.0]]
const CUSTOM: Array[Rect2] = [
	Rect2(-8, -16, 16, 28),     # Gilman House
	Rect2(-32, -12, 12, 8),     # quartel dos bombeiros
	Rect2(36, 12, 12, 8),       # mercearia First National
	Rect2(20, 28, 8, 8),        # loja de variedades
	Rect2(8, -124, 12, 16),     # Ordem Esotérica de Dagon
	Rect2(44, -124, 16, 16),    # igreja gótica de pedra
	Rect2(84, -60, 16, 16),     # refinaria Marsh
	Rect2(108, -104, 20, 12),   # igrejas de Main e Church
	Rect2(-64, -92, 16, 24),    # mansão Marsh
	Rect2(144, 56, 16, 10),     # armazém em ruínas junto ao cais de Zadok
]
const BRIDGES: Array = [[24.0, 36.0, "solid"], [100.0, 108.0, "solid"], [132.0, 140.0, "creaky"], [-48.0, -40.0, "creaky"]]
const LOBBY := Vector3(300, 0, 300)
const GROCERY := Vector3(330, 0, 300)
const VARIETY := Vector3(360, 0, 300)
const WHARF_SEAT := Vector3(156, 0, 72)

var _rng := RandomNumberGenerator.new()
var _bus: Node3D
var _bus_t := -1.0
var _bus_path: Array = []
var _bus_events: Dictionary = {}
var _residents: Array[Node3D] = []
var _priest: Node3D
var _zadok: Node3D
var _firemen: Array[Node3D] = []
var _order_men: Array[Node3D] = []
var _woman: Array[Node3D] = []
var _follow := false
var _boarded_t := 0.0
var _visits := 0
# Testemunho
var _move := -1
var _line := 0
var _line_t := 0.0
var _speaking := false
var _stall := false
var _stall_t := 0.0
var _early_offers := 0
var _doze_t := 0.0
var _heard_topics: Array[String] = []
var _ripple: MeshInstance3D
var _after_t := -1.0
var _amb_wind: AudioStreamPlayer
var _amb_sea: AudioStreamPlayer3D
var _amb_falls: AudioStreamPlayer3D
var _amb_room: AudioStreamPlayer
var _amb_motor: AudioStreamPlayer


func _objectives() -> Dictionary:
	return D.OBJECTIVES


func _hints() -> Dictionary:
	return D.HINTS


func _docs() -> Dictionary:
	var d: Dictionary = G.DOCS.duplicate()
	d.merge(D.DOCS, true)
	return d


func _journal_key() -> String:
	return phase


# ================================================================ início

func begin(s: StoryState) -> void:
	state = s
	_rng.seed = 1931
	_init_world()
	_build_town()
	_build_gorge()
	_build_north_country()
	_build_harbor()
	_build_landmarks()
	WorldKit.merge_static(_world)
	_build_interiors()
	_build_people()
	_build_bus()
	_amb_wind = _loop("amb_wind", -16.0)
	_amb_room = _loop("amb_room", -60.0)
	_amb_motor = _loop("sfx_motor", -60.0)
	_amb_sea = _loop3d("amb_sea", Vector3(170, 0, 40), 2.0, 30.0)
	_amb_falls = _loop3d("amb_falls", Vector3(30, -8, -28), 6.0, 20.0)
	_make_player()
	player.camera.far = 900.0
	player.has_flashlight = false
	_restore(state.checkpoint)


func _restore(cp: String) -> void:
	var order := ["cp02_bus_ride", "cp02_square", "cp03_grocery", "cp03_whiskey", "cp04_wharf"]
	var stage := order.find(cp)
	if stage >= 1:
		for f: String in ["crest_seen", "priest_seen"]:
			state.set_fact(f)
		_note(D.NOTES["priest"])
	if stage >= 2:
		state.give_item("item_sketch_map")
		state.add_doc("doc_sketch_map")
		state.give_item("item_crackers")
		for f2: String in ["valise_checked", "map_received", "grocery_people", "grocery_zadok"]:
			state.set_fact(f2)
		_note(D.NOTES["grocery"])
		_note(D.NOTES["zadok_info"])
	if stage >= 3:
		for f3: String in ["visit_refinery", "visit_waterfront", "visit_patrician", "zadok_present", "zadok_sighted"]:
			state.set_fact(f3)
		state.give_item("item_whiskey")
		_visits = 3
		_spawn_zadok_group()
	match cp:
		"cp02_bus_ride":
			_start_bus()
		"cp02_square":
			_set_day("morning")
			_spawn(Vector3(18, 0.05, -2), PI / 2)
			_set_phase("square")
		"cp03_grocery":
			_set_day("afternoon")
			_spawn(Vector3(42, 0.05, 9), 0.0)
			_set_phase("tour")
		"cp03_whiskey":
			_set_day("afternoon")
			_spawn(Vector3(16, 0.05, 32), PI)
			_zadok.global_position = Vector3(8, 0, -14)
			FigureKit.set_seated(_zadok, false)
			_set_phase("lure")
		"cp04_wharf":
			_set_day("golden")
			_start_wharf()
	_update_ambience()


# ================================================================ luz

func _set_day(tod: String) -> void:
	## tod_morning / tod_afternoon / tod_golden (docs/14).
	_env.background_mode = Environment.BG_SKY
	_env.fog_density = 0.004
	_env.ambient_light_energy = 1.0
	match tod:
		"morning":
			_sky.sky_top_color = Color(0.38, 0.52, 0.72)
			_sky.sky_horizon_color = Color(0.70, 0.74, 0.76)
			_env.ambient_light_color = Color(0.56, 0.58, 0.60)
			_env.fog_light_color = Color(0.70, 0.72, 0.74)
			_sun.light_color = Color(1.0, 0.96, 0.88)
			_sun.light_energy = 1.05
			_aim_light(_sun, Vector3(-0.3, -0.85, 0.35))
		"afternoon":
			_sky.sky_top_color = Color(0.40, 0.52, 0.70)
			_sky.sky_horizon_color = Color(0.76, 0.74, 0.68)
			_env.ambient_light_color = Color(0.55, 0.54, 0.52)
			_env.fog_light_color = Color(0.74, 0.72, 0.66)
			_sun.light_color = Color(1.0, 0.92, 0.80)
			_sun.light_energy = 1.0
			_aim_light(_sun, Vector3(0.5, -0.65, 0.35))
		"golden":
			_sky.sky_top_color = Color(0.34, 0.40, 0.56)
			_sky.sky_horizon_color = Color(0.92, 0.66, 0.40)
			_env.ambient_light_color = Color(0.52, 0.44, 0.38)
			_env.fog_light_color = Color(0.85, 0.62, 0.42)
			_sun.light_color = Color(1.0, 0.72, 0.42)
			_sun.light_energy = 1.0
			_aim_light(_sun, Vector3(1.0, -0.3, 0.15))
	_sky.ground_horizon_color = Color(0.40, 0.38, 0.34)
	_sky.ground_bottom_color = Color(0.15, 0.14, 0.12)


func _update_ambience() -> void:
	if _amb_room == null:
		return
	var inside := phase in ["lobby", "grocery", "variety"]
	_fade_db(_amb_room, -16.0 if inside else -60.0)
	_fade_db(_amb_wind, -60.0 if inside else -16.0)
	_fade_db(_amb_motor, -14.0 if phase == "bus" else -60.0)


# ================================================================ cidade (grade de quadras)

func _is_open(p: Vector2) -> bool:
	for r: Rect2 in STREETS:
		if r.has_point(p):
			return true
	for c: Array in CIRCLES:
		if p.distance_to(c[0]) < float(c[1]):
			return true
	return false


func _in_custom(p: Vector2) -> bool:
	for r: Rect2 in CUSTOM:
		if r.has_point(p):
			return true
	return false


func _build_town() -> void:
	WorldKit.box(_world, Vector3(42, -0.1, 42), Vector3(244, 0.2, 124), M_COBBLE)
	WorldKit.box(_world, Vector3(42, -0.1, -98), Vector3(244, 0.2, 124), M_COBBLE)
	var solid: Array = []
	for j in GD:
		var row: Array = []
		for i in GW:
			var c := Vector2(GX0 + (i + 0.5) * CELL, GZ0 + (j + 0.5) * CELL)
			var gorge := c.y > GORGE_N and c.y < GORGE_S
			row.append(not gorge and not _is_open(c) and not _in_custom(c))
		solid.append(row)
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
			if center.x > 108.0 and center.y < -36.0:
				h = _rng.randf_range(4.0, 7.0)
			var mat: Material = M_CLAP if _rng.randf() < 0.6 else M_BRICK
			WorldKit.box(_world, Vector3(center.x, h * 0.5, center.y), Vector3(run * CELL, h, CELL), mat)
			# Telhados gambrel afundados e janelas vazias [C].
			if _rng.randf() < 0.5:
				var roof := WorldKit.box(_world, Vector3(center.x, h + 0.7, center.y), Vector3(run * CELL, 0.3, CELL * 0.8), M_SLATE, false)
				roof.rotation.x = 0.4 if _rng.randf() < 0.5 else -0.4
			for k in run:
				var cx := x0 + (k + 0.5) * CELL
				for dz: int in [-1, 1]:
					var jj := j + dz
					if jj < 0 or jj >= GD or solid[jj][i + k]:
						continue
					var fz := z0 - 0.03 if dz == -1 else z0 + CELL + 0.03
					var boarded := _rng.randf() < (0.55 if center.x > 100.0 else 0.25)
					WorldKit.box(_world, Vector3(cx, 1.5, fz), Vector3(1.0, 1.3, 0.04), M_WOOD if boarded else TexFactory.flat(Color(0.03, 0.03, 0.035)), false)
					if h > 5.5:
						WorldKit.box(_world, Vector3(cx, 4.2, fz), Vector3(1.0, 1.3, 0.04), M_WOOD if _rng.randf() < 0.4 else TexFactory.flat(Color(0.03, 0.03, 0.035)), false)
			i += run


func _build_gorge() -> void:
	## O desfiladeiro do Manuxet, as quedas e as pontes [C].
	var river := StandardMaterial3D.new()
	river.albedo_color = Color(0.10, 0.14, 0.16)
	river.roughness = 0.2
	WorldKit.box(_world, Vector3(42, -14, -28), Vector3(260, 0.2, 16), river)
	for wall_z: float in [GORGE_S, GORGE_N]:
		WorldKit.box(_world, Vector3(42, -7, wall_z), Vector3(260, 14, 0.4), TexFactory.flat(Color(0.22, 0.22, 0.2)), false)
	var foam := TexFactory.flat(Color(0.75, 0.80, 0.82), true)
	for fx: float in [-10.0, 10.0, 76.0]:
		WorldKit.box(_world, Vector3(fx, -7, -28), Vector3(5, 12, 0.6), foam, false)
		WorldKit.box(_world, Vector3(fx, -13.6, -27), Vector3(7, 0.6, 3), foam, false)
	# Barreiras nas bordas, com vãos nas pontes.
	for edge: float in [GORGE_S + 0.3, GORGE_N - 0.3]:
		var cuts: Array = []
		for b: Array in BRIDGES:
			cuts.append(Vector2(b[0], b[1]))
		cuts.sort_custom(func(a: Vector2, c: Vector2) -> bool: return a.x < c.x)
		var cursor := -80.0
		for cut: Vector2 in cuts:
			if cut.x > cursor:
				WorldKit.blocker(_world, Vector3((cursor + cut.x) * 0.5, 2, edge), Vector3(cut.x - cursor, 4, 0.4))
			cursor = cut.y
		WorldKit.blocker(_world, Vector3((cursor + 165.0) * 0.5, 2, edge), Vector3(165.0 - cursor, 4, 0.4))
	for b2: Array in BRIDGES:
		var x0: float = b2[0]
		var x1: float = b2[1]
		var mat: Material = TexFactory.flat(Color(0.14, 0.14, 0.15)) if b2[2] == "solid" else M_WOOD
		WorldKit.box(_world, Vector3((x0 + x1) * 0.5, -0.15, -28), Vector3(x1 - x0, 0.3, 16.4), mat)
		for rx: float in [x0 + 0.2, x1 - 0.2]:
			WorldKit.box(_world, Vector3(rx, 0.6, -28), Vector3(0.1, 1.0, 16), TexFactory.flat(Color(0.1, 0.1, 0.1)), false)
			WorldKit.blocker(_world, Vector3(rx, 1.5, -28), Vector3(0.3, 3, 16))
	# Ponte da Fish, em ruínas [C]: só os tocos.
	for stub: float in [-21.5, -34.5]:
		WorldKit.box(_world, Vector3(120, -0.4, stub), Vector3(8, 0.5, 3), M_WOOD, false)
	# Placa de advertência da ponte da Washington [C].
	var post := WorldKit.box(_world, Vector3(-39.2, 1.0, -17.5), Vector3(0.12, 2.0, 0.12), M_WOOD)
	WorldKit.box(post, Vector3(0, 0.7, 0), Vector3(0.9, 0.45, 0.05), TexFactory.flat(Color(0.75, 0.70, 0.55)), false)
	_inter("bridge_sign", Vector3(-39.2, 1.6, -17.5), Vector3(1.0, 0.8, 0.5),
		func() -> String: return "Ler a placa" if phase == "tour" else "",
		func(_i: Interactable) -> void:
			state.add_doc("doc_bridge_warning")
			_open_doc("doc_bridge_warning"))
	# Estação velha e a ponte coberta da ferrovia, subindo o desfiladeiro a oeste [C].
	WorldKit.box(_world, Vector3(-96, 3, -28), Vector3(6, 6, 18), TexFactory.flat(Color(0.25, 0.20, 0.15)), false)
	WorldKit.box(_world, Vector3(-92, 3, -12), Vector3(12, 6, 8), M_BRICK, false)


func _build_north_country() -> void:
	## Terra ao norte da cidade para a viagem de ônibus: costa, crista, fazendas abandonadas [C].
	WorldKit.box(_world, Vector3(40, -0.3, -330), Vector3(400, 0.2, 340), TexFactory.material("marsh", 3.0))
	WorldKit.box(_world, Vector3(30, -0.1, -330), Vector3(6, 0.1, 340), M_DIRT, false)
	# A crista: um morro largo atravessado pela estrada.
	for k in 6:
		var z := -340.0 + k * 16.0
		var h := 9.0 - absf(k - 2.5) * 3.0
		WorldKit.box(_world, Vector3(30, h * 0.5 - 0.5, z), Vector3(120, h, 16), TexFactory.material("marsh", 3.0), false)
	# Plum Island e o mar a leste [C].
	WorldKit.box(_world, Vector3(230, -0.6, -420), Vector3(30, 0.4, 200), TexFactory.flat(Color(0.62, 0.58, 0.46)), false)
	for k2 in 8:
		var fx := 30.0 + (14.0 if k2 % 2 == 0 else -14.0) + _rng.randf_range(-3, 3)
		var fz := -230.0 + k2 * 9.0
		WorldKit.box(_world, Vector3(fx, 2.5, fz), Vector3(6, 5, 7), M_CLAP, false)
	for k3 in 10:
		WorldKit.box(_world, Vector3(34.5, 3.0, -440 + k3 * 30), Vector3(0.15, 6, 0.15), M_WOOD, false)


func _build_harbor() -> void:
	## Porto assoreado, quebra-mar com base de farol, cais podres, Devil Reef [C].
	var water := StandardMaterial3D.new()
	water.albedo_color = Color(0.12, 0.20, 0.26)
	water.roughness = 0.25
	water.metallic_specular = 0.7
	WorldKit.box(_world, Vector3(450, -1.0, -100), Vector3(570, 0.1, 900), water, false)
	for k in 8:
		var wz := -130.0 + k * 22.0
		WorldKit.box(_world, Vector3(172, -0.4, wz), Vector3(16 - (k % 3) * 3, 0.4, 2.5), M_WOOD, false)
	WorldKit.box(_world, Vector3(240, -0.2, -40), Vector3(5, 1.6, 160), TexFactory.flat(Color(0.35, 0.34, 0.32)), false)
	WorldKit.box(_world, Vector3(240, 1.5, -120), Vector3(4, 3, 4), TexFactory.flat(Color(0.4, 0.38, 0.34)), false)
	var reef := StandardMaterial3D.new()
	reef.albedo_color = Color(0.03, 0.03, 0.03)
	reef.disable_fog = true
	WorldKit.box(_world, Vector3(620, -0.5, -40), Vector3(12, 1.4, 160), reef, false)
	# O cais de Zadok: abertura gramada entre muros, cais de terra e alvenaria [C].
	WorldKit.box(_world, Vector3(152, 3, 61), Vector3(16, 6, 10), M_BRICK)
	WorldKit.box(_world, Vector3(170, -0.1, 73), Vector3(14, 0.3, 7), M_DIRT)
	for st: Vector3 in [Vector3(154.5, 0.25, 72), Vector3(151.6, 0.25, 72), Vector3(158, 0.2, 75), Vector3(149, 0.2, 75)]:
		WorldKit.box(_world, st, Vector3(1.0, 0.5, 0.8), TexFactory.flat(Color(0.30, 0.36, 0.26)))
	WorldKit.blocker(_world, Vector3(177.5, 2, 73), Vector3(1, 4, 8))
	WorldKit.blocker(_world, Vector3(165, 2, 30), Vector3(1, 4, 60))
	WorldKit.blocker(_world, Vector3(165, 2, -100), Vector3(1, 4, 120))
	WorldKit.blocker(_world, Vector3(42, 2, 104), Vector3(260, 4, 1))
	WorldKit.blocker(_world, Vector3(-80, 2, 0), Vector3(1, 4, 340))


func _build_landmarks() -> void:
	## Prédios únicos [C]: Gilman, quartel, mercearia, loja da Eliot, Ordem de Dagon, igreja,
	## refinaria com campanário branco, igrejas georgianas, mansão Marsh.
	WorldKit.box(_world, Vector3(0.5, 6.5, -2), Vector3(11, 13, 24), M_CLAP)
	WorldKit.box(_world, Vector3(1.5, 14.2, -2), Vector3(3, 2.4, 3), TexFactory.flat(Color(0.55, 0.48, 0.25)))
	WorldKit.box(_world, Vector3(6.1, 3.4, -2), Vector3(0.06, 0.6, 4), TexFactory.flat(Color(0.45, 0.38, 0.18)), false)
	_door("gilman_door", Vector3(6.1, 1.2, -2), "Entrar no Gilman House", func() -> bool: return phase in ["square", "tour"], func() -> void: _to_interior("lobby"))
	WorldKit.box(_world, Vector3(-26, 3, -8), Vector3(10, 6, 8), M_BRICK)
	WorldKit.box(_world, Vector3(-26, 1.4, -12.05), Vector3(3, 2.8, 0.1), TexFactory.flat(Color(0.35, 0.08, 0.06)), false)
	WorldKit.box(_world, Vector3(-23, 0.3, -14.3), Vector3(2.2, 0.6, 0.6), M_WOOD)
	WorldKit.box(_world, Vector3(42, 3.5, 16), Vector3(12, 7, 8), M_BRICK)
	WorldKit.box(_world, Vector3(42, 4.6, 11.95), Vector3(8, 0.7, 0.05), TexFactory.flat(Color(0.75, 0.25, 0.2)), false)
	_door("grocery_door", Vector3(42, 1.2, 11.9), "Entrar na mercearia First National", func() -> bool: return phase in ["square", "tour", "zadok_seen", "lure"], func() -> void: _to_interior("grocery"))
	WorldKit.box(_world, Vector3(24, 3, 32), Vector3(8, 6, 8), M_CLAP)
	_door("variety_door", Vector3(19.9, 1.2, 32), "Entrar na loja de variedades", func() -> bool: return phase in ["tour", "zadok_seen"], func() -> void: _to_interior("variety"), true)
	# Ordem de Dagon: antiga Loja Maçônica, colunas, letreiro preto e dourado [C].
	WorldKit.box(_world, Vector3(13, 5, -116), Vector3(10, 10, 14), TexFactory.flat(Color(0.62, 0.62, 0.60)))
	for cz in 4:
		WorldKit.box(_world, Vector3(19, 3.5, -121 + cz * 3.3), Vector3(0.8, 7, 0.8), TexFactory.flat(Color(0.7, 0.7, 0.68)), false)
	WorldKit.box(_world, Vector3(18.6, 8.2, -116), Vector3(0.06, 1.2, 9), TexFactory.flat(Color(0.05, 0.05, 0.05)), false)
	WorldKit.box(_world, Vector3(18.5, 8.2, -116), Vector3(0.04, 0.5, 7), TexFactory.flat(Color(0.55, 0.45, 0.2), true), false)
	_inter("order_notice", Vector3(18.6, 1.5, -116), Vector3(0.5, 1.5, 1.5),
		func() -> String: return "Aviso desbotado na porta" if phase == "tour" else "",
		func(_i: Interactable) -> void:
			state.add_doc("doc_order_notice")
			_open_doc("doc_order_notice"))
	# Igreja gótica de pedra, tardia e desajeitada, porão alto com janelas fechadas [C].
	WorldKit.box(_world, Vector3(52, 6, -116), Vector3(14, 12, 14), TexFactory.flat(Color(0.42, 0.42, 0.40)))
	WorldKit.box(_world, Vector3(52, 15, -116), Vector3(5, 6, 5), TexFactory.flat(Color(0.42, 0.42, 0.40)))
	WorldKit.box(_world, Vector3(44.95, 1.3, -110), Vector3(0.1, 2.4, 2.0), TexFactory.flat(Color(0.0, 0.0, 0.0)), false)
	# Refinaria Marsh: velho moinho no barranco, campanário branco [C].
	WorldKit.box(_world, Vector3(92, 5, -52), Vector3(16, 10, 16), M_BRICK)
	WorldKit.box(_world, Vector3(92, 12.5, -52), Vector3(3, 5, 3), TexFactory.flat(Color(0.88, 0.88, 0.85)))
	# Duas igrejas georgianas arruinadas em Main e Church [C]; um campanário decapitado.
	for ix: float in [112.0, 123.0]:
		WorldKit.box(_world, Vector3(ix, 5, -98), Vector3(8, 10, 10), TexFactory.flat(Color(0.55, 0.53, 0.48)))
		WorldKit.box(_world, Vector3(ix, 12, -101), Vector3(3, 6 if ix > 120 else 10, 3), TexFactory.flat(Color(0.5, 0.48, 0.44)))
	_inter("tract", Vector3(104, 0.1, -80), Vector3(0.6, 0.2, 0.6),
		func() -> String: return "Um folheto no chão" if phase == "tour" else "",
		func(_i: Interactable) -> void:
			state.set_fact("tract_read")
			state.add_doc("doc_church_tract")
			_open_doc("doc_church_tract"))
	WorldKit.box(_world, Vector3(104, 0.02, -80), Vector3(0.25, 0.02, 0.35), TexFactory.flat(Color(0.8, 0.78, 0.68)), false)
	# Mansão Marsh com parterres em terraço até a Lafayette [C].
	WorldKit.box(_world, Vector3(-52, 6, -80), Vector3(8, 12, 18), TexFactory.flat(Color(0.70, 0.68, 0.62)))
	WorldKit.box(_world, Vector3(-52, 12.6, -80), Vector3(3, 1.6, 3), TexFactory.flat(Color(0.7, 0.68, 0.62)))
	for t in 3:
		WorldKit.box(_world, Vector3(-58 - t * 2.0, 0.3 + t * 0.2, -80), Vector3(2.0, 0.6 + t * 0.4, 20), TexFactory.flat(Color(0.25, 0.38, 0.22)))
	# Três campanários georgianos sem relógio, vistos da crista [C].
	for sp: Vector3 in [Vector3(116, 18, -10), Vector3(124, 16, -100), Vector3(60, 20, 40)]:
		WorldKit.box(_world, sp, Vector3(3, 12, 3), TexFactory.flat(Color(0.75, 0.74, 0.70)), false)


func _door(id: String, pos: Vector3, label: String, need: Callable, cb: Callable, along_z: bool = false) -> void:
	WorldKit.box(_world, pos, Vector3(0.08, 2.2, 1.1) if not along_z else Vector3(0.08, 2.2, 1.1), M_WOOD, false)
	_inter(id, pos, Vector3(0.5, 2.2, 1.2),
		func() -> String: return label if need.call() else "",
		func(_i: Interactable) -> void: cb.call())


# ================================================================ interiores

func _room(c: Vector3, size: Vector3, wall: Material) -> void:
	var hx := size.x * 0.5
	var hz := size.z * 0.5
	WorldKit.box(_world, c + Vector3(0, -0.1, 0), Vector3(size.x, 0.2, size.z), M_FLOOR)
	WorldKit.box(_world, c + Vector3(0, size.y + 0.1, 0), Vector3(size.x, 0.2, size.z), M_CEIL, false)
	WorldKit.wall_x(_world, c.z - hz, c.x - hx, c.x + hx, 0.0, size.y, wall)
	WorldKit.wall_x(_world, c.z + hz, c.x - hx, c.x + hx, 0.0, size.y, wall)
	WorldKit.wall_z(_world, c.x - hx, c.z - hz, c.z + hz, 0.0, size.y, wall)
	WorldKit.wall_z(_world, c.x + hx, c.z - hz, c.z + hz, 0.0, size.y, wall)
	var l := WorldKit.omni(_world, c + Vector3(0, size.y - 0.4, 0), Color(1.0, 0.84, 0.6), 1.0, 8.0)
	WorldKit.box(l, Vector3.ZERO, Vector3(0.18, 0.12, 0.18), TexFactory.flat(Color(1.0, 0.84, 0.6), true), false)


func _build_interiors() -> void:
	# Saguão do Gilman, de dia: o funcionário idoso, sem a "aparência" [C].
	_room(LOBBY, Vector3(7, 3.4, 6), M_WALL)
	WorldKit.box(_world, LOBBY + Vector3(0, 0.55, -1.8), Vector3(2.4, 1.1, 0.6), M_WOOD)
	var clerk := WorldKit.figure(_world, LOBBY + Vector3(0, 0, -2.4), 1.68, false, false, "clerk")
	clerk.rotation.y = PI
	_inter("day_clerk", LOBBY + Vector3(0, 1.2, -1.8), Vector3(2.4, 1.2, 0.8),
		func() -> String: return "Deixar a valise com o funcionário" if phase == "lobby" and not state.has_fact("valise_checked") else "",
		func(_i: Interactable) -> void:
			app.show_dialog("Funcionário", D.DAY_CLERK, ["Obrigado."], func(_j: int) -> void:
				state.set_fact("valise_checked")
				_think(D.THOUGHTS["lobby"], 4.0)))
	_inter("register_day", LOBBY + Vector3(0.8, 1.15, -1.8), Vector3(0.5, 0.2, 0.4),
		func() -> String: return "Ler o livro de registro" if phase == "lobby" else "",
		func(_i: Interactable) -> void:
			state.add_doc("doc_gilman_register")
			_open_doc("doc_gilman_register"))
	_inter("lobby_exit", LOBBY + Vector3(0, 1.1, 2.9), Vector3(1.2, 2.2, 0.3),
		func() -> String: return "Sair para a praça" if phase == "lobby" else "",
		func(_i: Interactable) -> void: _to_street(Vector3(8.5, 0.05, -2), PI / 2 + PI))
	# Mercearia First National: o rapaz de Arkham [C].
	_room(GROCERY, Vector3(8, 3.2, 6), M_PLASTER)
	for k in 3:
		WorldKit.box(_world, GROCERY + Vector3(-3.0 + k * 3.0, 1.1, -2.6), Vector3(2.4, 2.2, 0.5), M_WOOD)
	WorldKit.box(_world, GROCERY + Vector3(2.4, 0.5, 0.2), Vector3(0.6, 1.0, 2.4), M_WOOD)
	var boy := WorldKit.figure(_world, GROCERY + Vector3(3.1, 0, 0.2), 1.66, false, false, "grocer")
	boy.rotation.y = -PI / 2
	_inter("grocery_boy", GROCERY + Vector3(2.6, 1.2, 0.2), Vector3(0.8, 1.2, 2.4),
		func() -> String: return "Conversar com o rapaz" if phase == "grocery" else "",
		func(_i: Interactable) -> void: _grocery())
	_inter("grocery_exit", GROCERY + Vector3(0, 1.1, 2.9), Vector3(1.2, 2.2, 0.3),
		func() -> String: return "Sair" if phase == "grocery" and state.has_fact("map_received") else "",
		func(_i: Interactable) -> void:
			if not state.has_fact("tour_started"):
				state.set_fact("tour_started")
				app.save_checkpoint("cp03_grocery")
				app.ui.chapter_card(D.CARDS["secrets"], 3.5)
				_set_day("afternoon")
				_to_street(Vector3(42, 0.05, 9), 0.0, "tour")
			else:
				_to_street(Vector3(42, 0.05, 9), 0.0))
	# Fundos da loja de variedades na Eliot [C].
	_room(VARIETY, Vector3(5, 2.8, 4), M_CLAP)
	WorldKit.box(_world, VARIETY + Vector3(0, 0.5, -1.2), Vector3(2.0, 1.0, 0.5), M_WOOD)
	var seller := WorldKit.figure(_world, VARIETY + Vector3(0, 0, -1.7), 1.7, false, false, "clerk")
	seller.rotation.y = PI
	_add_eyes(seller, 1.7)
	_inter("seller", VARIETY + Vector3(0, 1.2, -1.2), Vector3(2.0, 1.2, 0.6),
		func() -> String:
			if phase != "variety":
				return ""
			return "Comprar uma garrafa de uísque" if state.has_fact("zadok_sighted") and not state.has_item("item_whiskey") else "Olhar as prateleiras",
		func(_i: Interactable) -> void:
			if not state.has_fact("zadok_sighted") or state.has_item("item_whiskey"):
				_think("Bugigangas, latas, linhas de pesca.", 3.0)
				return
			app.show_dialog("Vendedor", D.VARIETY, ["Pagar"], func(_j: int) -> void:
				state.give_item("item_whiskey")
				_think(D.THOUGHTS["whiskey"], 3.0)
				app.save_checkpoint("cp03_whiskey")
				_zadok.global_position = Vector3(8, 0, -14)
				FigureKit.set_seated(_zadok, false)
				_set_phase("lure")))
	_inter("variety_exit", VARIETY + Vector3(0, 1.1, 1.9), Vector3(1.2, 2.2, 0.3),
		func() -> String: return "Sair para a Eliot" if phase in ["variety", "lure"] else "",
		func(_i: Interactable) -> void: _to_street(Vector3(16, 0.05, 32), PI))


func _to_interior(which: String) -> void:
	var back := phase
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 0.4).finished
	if not is_inside_tree():
		return
	set_meta("back_phase", back)
	match which:
		"lobby":
			_spawn(LOBBY + Vector3(0, 0.05, 2.0), 0.0)
		"grocery":
			_spawn(GROCERY + Vector3(0, 0.05, 2.0), 0.0)
		"variety":
			_spawn(VARIETY + Vector3(0, 0.05, 1.2), 0.0)
	_set_phase(which)
	player.controls_enabled = true
	app.ui.fade_to(0.0, 0.5)


func _to_street(pos: Vector3, yaw: float, next: String = "") -> void:
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 0.4).finished
	if not is_inside_tree():
		return
	_spawn(pos, yaw)
	var back: String = get_meta("back_phase", "square")
	if next != "":
		back = next
	elif phase == "lure":
		back = "lure"
	_set_phase(back)
	player.controls_enabled = true
	app.ui.fade_to(0.0, 0.5)


func _grocery() -> void:
	if not state.has_fact("grocery_met"):
		state.set_fact("grocery_met")
		app.show_dialog("Rapaz da mercearia", D.GROCERY_INTRO, ["Prazer."], func(_j: int) -> void: _grocery())
		return
	var labels: Array = []
	var ids: Array = []
	for id: String in D.GROCERY_TOPICS.keys():
		labels.append(D.GROCERY_TOPICS[id][0])
		ids.append(id)
	if not state.has_fact("map_received"):
		labels.append("Pode me desenhar um mapa?")
	labels.append("Comprar bolachas de queijo e de gengibre" if not state.has_item("item_crackers") else "Obrigado, é só.")
	app.show_dialog("Rapaz da mercearia", "Mais alguma coisa?", labels, func(i: int) -> void:
		if i < ids.size():
			var id: String = ids[i]
			state.set_fact("grocery_" + id)
			app.show_dialog("Rapaz da mercearia", D.GROCERY_TOPICS[id][1], ["Continuar"], func(_j: int) -> void: _grocery())
			return
		var rest := labels[i] as String
		if rest.begins_with("Pode me"):
			app.show_dialog("Rapaz da mercearia", D.GROCERY_MAP, ["Muito obrigado!"], func(_j: int) -> void:
				state.set_fact("map_received")
				state.give_item("item_sketch_map")
				state.add_doc("doc_sketch_map")
				_note(D.NOTES["grocery"])
				_think(D.THOUGHTS["map"], 4.0)
				_grocery())
		elif rest.begins_with("Comprar"):
			state.give_item("item_crackers")
			_think("Bolachas para mais tarde.", 2.5)
		if state.has_fact("grocery_zadok"):
			_note(D.NOTES["zadok_info"]))


# ================================================================ pessoas

func _add_eyes(f: Node3D, _tall: float) -> void:
	## Olhos saltados que não piscam e pescoço vincado [C] — traço anfíbio, nunca étnico (D-013).
	FigureKit.add_staring_eyes(f)


func _build_people() -> void:
	var spots: Array = [
		Vector3(24, 0, 6), Vector3(46, 0, -4), Vector3(52, 0, 4), Vector3(14, 0, -10),
		Vector3(60, 0, 4), Vector3(104, 0, 20), Vector3(136, 0, -60), Vector3(120, 0, -84),
		Vector3(30, 0, -60), Vector3(-44, 0, -60), Vector3(-44, 0, 30), Vector3(150, 0, -100),
		Vector3(30, 0, -140), Vector3(66, 0, -48),
	]
	for k in spots.size():
		var f := WorldKit.figure(_world, spots[k], 1.6 + _rng.randf() * 0.3)
		if k % 2 == 0:
			_add_eyes(f, 1.7)
		_residents.append(f)
	# Pescadores no quebra-mar distante [C].
	for k2 in 3:
		WorldKit.figure(_world, Vector3(240, 0.6, -60 + k2 * 12), 1.6)
	# Três membros da Ordem à porta do salão [O].
	for k3 in 3:
		var m := WorldKit.figure(_world, Vector3(21.5, 0, -119 + k3 * 1.6), 1.7, true, false)
		_order_men.append(m)
	# Gesto humano ao norte do rio (docs/02 §6.3) [O].
	var mom := WorldKit.figure(_world, Vector3(130.5, 0, -64), 1.62, false, false, "woman")
	var kid := WorldKit.figure(_world, Vector3(130.0, 0, -65.5), 1.05)
	_woman = [mom, kid]
	# O padre da tiara, no porão da igreja (oculto até o ônibus passar) [C].
	_priest = WorldKit.figure(_world, Vector3(45.6, -0.6, -111.5), 1.8, true, true)
	_priest.visible = false
	_zadok = WorldKit.figure(_world, Vector3(-23, 0, -14.3), 1.82, false, false, "old")
	_zadok.visible = false


func _spawn_zadok_group() -> void:
	## Zadok Allen e dois bombeiros sem traços anormais, no banco do quartel [C].
	state.set_fact("zadok_present")
	_zadok.visible = true
	_zadok.global_position = Vector3(-23, 0, -14.3)
	FigureKit.set_seated(_zadok, true, 0.6)
	_zadok.rotation.y = 0.0
	if _firemen.is_empty():
		for k in 2:
			var f := WorldKit.figure(_world, Vector3(-25.5 + k * 1.2, 0, -14.6), 1.75)
			_firemen.append(f)
	_inter("zadok", Vector3(0, 0, 0), Vector3(0.8, 2.0, 0.8),
		func() -> String: return _zadok_prompt(),
		func(_i: Interactable) -> void: _zadok_use())
	(inter["zadok"] as Node3D).reparent(_zadok, false)
	(inter["zadok"] as Node3D).position = Vector3(0, 1.0, 0)


# ================================================================ ônibus (ch02)

func _build_bus() -> void:
	_bus = Node3D.new()
	_world.add_child(_bus)
	WorldKit.box(_bus, Vector3(0, 1.45, 0), Vector3(2.4, 2.3, 7.0), TexFactory.flat(Color(0.33, 0.33, 0.31)), false)
	# Molduras das janelas (de dentro, a carroceria some por face oculta e a paisagem aparece).
	var frame := TexFactory.flat(Color(0.12, 0.12, 0.12))
	for wx: float in [-1.18, 1.18]:
		for zz in 7:
			WorldKit.box(_bus, Vector3(wx, 1.9, -3.0 + zz * 0.9), Vector3(0.06, 0.9, 0.08), frame, false)
		WorldKit.box(_bus, Vector3(wx, 1.42, -0.3), Vector3(0.06, 0.06, 5.6), frame, false)
		WorldKit.box(_bus, Vector3(wx, 0.9, -0.3), Vector3(0.06, 1.0, 5.6), TexFactory.flat(Color(0.28, 0.28, 0.27)), false)
	for sz in 4:
		WorldKit.box(_bus, Vector3(-0.6, 0.8, -1.4 + sz * 1.2), Vector3(0.9, 0.7, 0.12), TexFactory.flat(Color(0.25, 0.18, 0.12)), false)
	var driver := WorldKit.figure(_bus, Vector3(-0.6, 0.4, -2.6), 1.85, false, false, "man")
	driver.rotation.y = 0.0
	_bus.visible = false


func _start_bus() -> void:
	_set_day("morning")
	_set_phase("bus")
	_bus.visible = true
	player.controls_enabled = false
	player.look_enabled = true
	player.set_physics_process(false)
	_bus_path = [
		[Vector3(30, 0, -470), 0.0], [Vector3(30, 9, -300), 45.0], [Vector3(30, 9, -296), 9.0],
		[Vector3(30, 0, -200), 22.0], [Vector3(30, 0, -136), 14.0], [Vector3(30, 0, -100), 16.0],
		[Vector3(30, 0, -40), 12.0], [Vector3(30, 0, -16), 7.0], [Vector3(18, 0, -4), 5.0],
	]
	_bus_t = 0.0
	if not capture_mode:
		app.ui.chapter_card(D.CARDS["bus"], 4.0)
		_after(6.0, func() -> void: _think(D.THOUGHTS["sargent"], 5.0))


func _bus_pos(t: float) -> Array:
	var acc := 0.0
	for k in range(1, _bus_path.size()):
		var seg: float = _bus_path[k][1]
		if t <= acc + seg:
			var a: Vector3 = _bus_path[k - 1][0]
			var b: Vector3 = _bus_path[k][0]
			var u := clampf((t - acc) / seg, 0.0, 1.0)
			return [a.lerp(b, u), (b - a).normalized() if (b - a).length() > 0.1 else Vector3.FORWARD, false]
		acc += seg
	var last: Vector3 = _bus_path[-1][0]
	return [last, Vector3(-1, 0, 0.4).normalized(), true]


func _update_bus(delta: float) -> void:
	_bus_t += delta
	var r := _bus_pos(_bus_t)
	var pos: Vector3 = r[0]
	var fwd: Vector3 = r[1]
	_bus.global_position = pos
	if Vector2(fwd.x, fwd.z).length() > 0.1:
		_bus.basis = Basis.looking_at(Vector3(fwd.x, 0, fwd.z), Vector3.UP)
	# Assento atrás do motorista, do mesmo lado, de frente para a costa [C].
	player.global_position = _bus.to_global(Vector3(-0.6, 0.35, 1.2))
	var z := pos.z
	if z > -300.0 and not _bus_events.has("crest"):
		_bus_events["crest"] = true
		state.set_fact("crest_seen")
		_think(D.THOUGHTS["crest"], 6.0)
		_after(4.0, func() -> void: _think(D.THOUGHTS["reef"], 6.0))
	if z > -130.0 and not _bus_events.has("green"):
		_bus_events["green"] = true
		_think(D.THOUGHTS["green"], 5.0)
	if z > -118.0 and not _bus_events.has("bell"):
		_bus_events["bell"] = true
		for k in 11:
			_after(k * 0.9, func() -> void: app.play_sound("sfx_bell", Vector3(52, 15, -116), -2.0, 1.15))
		_after(1.0, func() -> void: _think(D.THOUGHTS["bell"], 4.0))
		_after(3.2, func() -> void: _cross_priest())
	if z > -36.0 and not _bus_events.has("falls"):
		_bus_events["falls"] = true
		_think(D.THOUGHTS["falls"], 4.0)
	if bool(r[2]) and not _bus_events.has("stop"):
		_bus_events["stop"] = true
		_arrive_square()


func _cross_priest() -> void:
	## evt_basement_priest [C]: uma figura de manto e tiara cruza o retângulo negro em ~1,2 s.
	_priest.visible = true
	_priest.global_position = Vector3(45.4, -0.6, -111.6)
	var tw := create_tween()
	tw.tween_property(_priest, "global_position", Vector3(45.4, -0.6, -108.4), 1.2)
	tw.tween_callback(_priest.hide)
	app.play_sound("sfx_bell", Vector3.INF, -16.0, 0.5)
	state.set_fact("priest_seen")
	_note(D.NOTES["priest"])
	_after(2.5, func() -> void: _think(D.THOUGHTS["priest"], 6.0))


func _arrive_square() -> void:
	_bus_t = -1.0
	player.set_physics_process(true)
	_spawn(Vector3(18, 0.05, -2.5), PI / 2)
	player.controls_enabled = true
	app.save_checkpoint("cp02_square")
	_set_phase("square")
	app.ui.chapter_card(D.CARDS["square"], 3.0)
	var tw := create_tween()
	tw.tween_property(_bus, "global_position", Vector3(30, 0, -40), 6.0)
	tw.tween_callback(_bus.hide)


# ================================================================ passeio (ch03)

func _zone_visit() -> void:
	var p := player.global_position
	var zones: Dictionary = {
		"visit_refinery": [Rect2(60, -64, 44, 30), "refinery"],
		"visit_waterfront": [Rect2(112, -20, 52, 104), "waterfront"],
		"visit_north": [Rect2(100, -148, 64, 110), "north"],
		"visit_patrician": [Rect2(-72, -148, 32, 112), "patrician"],
	}
	for f: String in zones.keys():
		var z: Array = zones[f]
		if (z[0] as Rect2).has_point(Vector2(p.x, p.z)) and state.set_fact(f):
			_visits += 1
			_think(D.THOUGHTS[z[1]], 6.0)
			_note(D.NOTES[z[1]])
			if _visits == 2:
				_after(8.0, func() -> void:
					for k in 3:
						_after(k * 1.1, func() -> void: app.play_sound("sfx_bell", Vector3(52, 15, -116), -4.0, 1.15))
					_think(D.THOUGHTS["bell_three"], 4.0))
			if _visits >= 3 and not state.has_fact("zadok_present"):
				_spawn_zadok_group()


func _update_tour(delta: float) -> void:
	var p := player.global_position
	_zone_visit()
	# Sons mais fortes atrás das fachadas tapadas, ao norte do rio [C].
	if state.has_fact("visit_north") and Rect2(100, -148, 64, 110).has_point(Vector2(p.x, p.z)):
		_boarded_t -= delta
		if _boarded_t <= 0.0:
			_boarded_t = _rng.randf_range(5.0, 9.0)
			var s: String = ["sfx_creak", "sfx_croak_low", "sfx_patter"][_rng.randi() % 3]
			if s == "sfx_patter":
				s = "sfx_step_wood"
			app.play_sound(s, p + Vector3(_rng.randf_range(-6, 6), 1.2, _rng.randf_range(-6, 6)), -4.0, _rng.randf_range(0.8, 1.1))
			_caption("rangidos e ruídos roucos atrás de uma fachada tapada", 3.0)
	if _woman.size() == 2 and p.distance_to(_woman[0].global_position) < 12.0 and not state.has_fact("woman_seen"):
		state.set_fact("woman_seen")
		for w: Node3D in _woman:
			var tw := w.create_tween()
			tw.tween_property(w, "global_position", Vector3(132.8, 0, -64.5), 1.4)
			tw.tween_callback(w.hide)
		app.play_sound("sfx_creak", Vector3(133, 1.5, -64.5), 0.0, 1.3)
		_after(1.5, func() -> void: _think(D.THOUGHTS["woman"], 5.0))
	if Vector2(p.x, p.z).distance_to(Vector2(32, -112)) < 14.0 and state.set_fact("order_watched"):
		_think(D.THOUGHTS["order_watch"], 5.0)
	if p.x > -48.0 and p.x < -40.0 and p.z < -20.0 and p.z > -36.0 and state.set_fact("washington_bridge"):
		app.play_sound("sfx_creak_long", p + Vector3(0, -0.3, 0), 0.0, 0.7)
		_think(D.THOUGHTS["bridge"], 4.0)
	if state.has_fact("zadok_present") and not state.has_fact("zadok_sighted") and p.distance_to(_zadok.global_position) < 18.0:
		state.set_fact("zadok_sighted")
		_note(D.NOTES["zadok_seen"])
		_think(D.THOUGHTS["zadok"], 6.0)
		_set_phase("zadok_seen")


func _update_observers() -> void:
	## Moradores param e olham quando o jogador passa perto (estado `observing`, docs/11).
	var p := player.global_position
	for f: Node3D in _residents + _order_men + _firemen:
		if not f.visible:
			continue
		var to := p - f.global_position
		to.y = 0
		if to.length() < 10.0 and to.length() > 0.3:
			f.look_at(f.global_position + to, Vector3.UP)


func _zadok_prompt() -> String:
	match phase:
		"zadok_seen":
			return "Aproximar-se do velho"
		"lure":
			return "Mostrar a garrafa a Zadok" if not _follow else ""
		"wharf":
			if _doze_t > 0.0:
				return "Zadok cochila"
			if _stall:
				return "Falar com Zadok"
			if _speaking:
				return "Oferecer a garrafa (ele ainda fala)"
	return ""


func _zadok_use() -> void:
	match phase:
		"zadok_seen":
			_think(D.THOUGHTS["firemen"], 5.0)
		"lure":
			_follow = true
			_zadok.visible = true
			_think(D.THOUGHTS["follow"], 4.0)
			_set_phase("walk")
		"wharf":
			_wharf_use()


func _update_follow(delta: float) -> void:
	var p := player.global_position
	var to := p - _zadok.global_position
	to.y = 0
	var d := to.length()
	if d > 2.6:
		var step := minf(d - 2.4, 2.8 * delta)
		_zadok.global_position += to / d * step
		_zadok.look_at(_zadok.global_position + to, Vector3.UP)
	if p.x > 100.0 and state.set_fact("hey_mister"):
		_think(D.THOUGHTS["hey"], 3.0)
	if Vector2(p.x, p.z).distance_to(Vector2(WHARF_SEAT.x, WHARF_SEAT.z)) < 6.0:
		_follow = false
		_start_wharf()


# ================================================================ o testemunho (ch04)

func _start_wharf() -> void:
	_set_phase("wharf")
	_set_day("golden")
	app.save_checkpoint("cp04_wharf")
	app.ui.chapter_card(D.CARDS["zadok"], 4.0)
	_zadok.visible = true
	_zadok.global_position = Vector3(152.2, 0.15, 72)
	_zadok.rotation.y = -PI / 2
	FigureKit.set_seated(_zadok, true, 0.45)
	WorldKit.box(_world, Vector3(152.2, 0.375, 72), Vector3(0.55, 0.45, 0.55), M_WOOD, false)
	player.seated = true
	player.controls_enabled = true
	player.look_enabled = true
	player.velocity = Vector3.ZERO
	# De costas para o mar; Zadok de frente para ele [C].
	player.global_position = WHARF_SEAT + Vector3(-0.5, 0.0, 0)
	player.set_view(PI / 2, -0.05)
	player.set_eye_height(1.1)
	if state.has_item("item_crackers"):
		_after(6.0, func() -> void: _think("Como as bolachas, devagar. Meu almoço frugal.", 3.0))
	_move = 0
	_begin_movement()
	_fade_db(_amb_sea, -2.0, 4.0)


func _begin_movement() -> void:
	_line = 0
	_line_t = 0.0
	_speaking = true
	_stall = false
	_say_line()


func _say_line() -> void:
	var lines: Array = D.MOVEMENTS[_move]["lines"]
	var text: String = lines[_line]
	var dur := clampf(text.length() / 14.0, 4.5, 9.0)
	# Uma rubrica entre colchetes no começo da fala é gesto visível, não fala.
	if text.begins_with("["):
		var close := text.find("]")
		_see(text.substr(1, close - 1), dur)
		text = text.substr(close + 1).strip_edges()
	app.say("Zadok: " + text, dur, "speech")
	_line_t = dur + 0.6
	if _move == 1 and _line == lines.size() - 1:
		_note(D.NOTES["jrn_islands"])
	if _move == 6 and _line == 0:
		_note(D.NOTES["jrn_obed_eyes"])
	if _move == 6 and _line == 1:
		_note(D.NOTES["jrn_obed_daughter"])
	if _move == 4 and _line == 2:
		app.play_sound("amb_sea", Vector3(176, 0, 72), 2.0)
		_see("a maré virou e começa a subir", 4.0)
		_set_day("golden")
		_sun.light_energy = 0.85


func _update_wharf(delta: float) -> void:
	if _doze_t > 0.0:
		_doze_t -= delta
		if _doze_t <= 0.0:
			app.say("Zadok: Hein? Onde eu tava...", 3.0)
		return
	if _speaking:
		_line_t -= delta
		if _line_t <= 0.0:
			var lines: Array = D.MOVEMENTS[_move]["lines"]
			_line += 1
			if _line >= lines.size():
				_speaking = false
				if _move >= D.MOVEMENTS.size() - 1:
					_shriek()
					return
				_stall = true
				_stall_t = 0.0
				_see(str(D.STALL_LINES[_move % D.STALL_LINES.size()]), 4.0)
			else:
				_say_line()
	elif _stall:
		_stall_t += delta
		var next: Dictionary = D.MOVEMENTS[_move + 1]
		# Depois que a garrafa acaba (fim de M4), ele continua sozinho.
		if not bool(next["bottle"]) and _stall_t > 7.0:
			_move += 1
			_begin_movement()


func _wharf_use() -> void:
	if _doze_t > 0.0:
		return
	if _speaking:
		_early_offers += 1
		if _early_offers >= 3:
			_early_offers = 0
			_speaking = false
			_doze_t = 22.0
			_line = maxi(_line - 1, 0)
			_see(D.DOZE, 4.0)
			# Retoma do mesmo ponto depois do cochilo (falha suave, pz04).
			_after(22.5, func() -> void:
				_speaking = true
				_say_line())
		else:
			app.say("Zadok: " + D.TOO_SOON, 3.0)
		return
	if not _stall:
		return
	var next: Dictionary = D.MOVEMENTS[_move + 1]
	var labels: Array = []
	var actions: Array = []
	if bool(next["bottle"]):
		labels.append("Oferecer a garrafa")
		actions.append("bottle")
	for tid: String in _unlocked_topics():
		if not _heard_topics.has(tid):
			labels.append("Perguntar: " + str(D.TOPICS[tid][0]))
			actions.append(tid)
	labels.append("Esperar")
	actions.append("wait")
	app.show_dialog("Zadok Allen", "[O velho espera, olhando o recife.]", labels, func(i: int) -> void:
		var act: String = actions[i]
		if act == "bottle":
			app.play_sound("sfx_cloth", Vector3.INF, -8.0)
			_early_offers = 0
			_move += 1
			_begin_movement()
		elif act == "wait":
			if not bool(next["bottle"]):
				_stall_t = 7.0
		else:
			_heard_topics.append(act)
			var aside: String = D.TOPICS[act][1]
			app.say("Zadok: " + aside, clampf(aside.length() / 14.0, 4.5, 9.0))
			_note("Zadok, sobre %s: %s" % [str(D.TOPICS[act][0]).to_lower(), aside]))


func _unlocked_topics() -> Array[String]:
	var out: Array[String] = []
	var rules: Dictionary = {
		"topic_tiara": state.has_fact("tiara_seen") or state.has_fact("priest_seen"),
		"topic_reef": state.has_fact("crest_seen"),
		"topic_refinery_gold": state.has_fact("visit_refinery"),
		"topic_churches": state.has_fact("priest_seen") or state.has_fact("tract_read"),
		"topic_marsh_house": state.has_fact("visit_patrician"),
		"topic_1846": state.has_fact("essex_read"),
		"topic_look": state.has_fact("grocery_people"),
	}
	for k: String in rules.keys():
		if rules[k]:
			out.append(k)
	return out


func _shriek() -> void:
	## evt_zadok_shriek [C]: grito; só a maré e uma ondulação mais localizada; fuga de Zadok.
	_stall = false
	app.play_sound("sfx_croak", _zadok.global_position + Vector3(0, 1.2, 0), 8.0, 2.2)
	app.play_sound("sfx_creak", _zadok.global_position + Vector3(0, 1.2, 0), 6.0, 2.6)
	app.say("Zadok: " + D.SHRIEK_1, 3.0)
	player.add_shake(1.0)
	_ripple = MeshInstance3D.new()
	var tm := TorusMesh.new()
	tm.inner_radius = 1.4
	tm.outer_radius = 1.7
	_ripple.mesh = tm
	var rm := StandardMaterial3D.new()
	rm.albedo_color = Color(0.7, 0.75, 0.8, 0.6)
	rm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_ripple.material_override = rm
	_ripple.position = Vector3(182, -0.95, 71)
	_ripple.scale = Vector3(1, 0.05, 1)
	_world.add_child(_ripple)
	var tw := create_tween()
	tw.tween_property(_ripple, "scale", Vector3(3.5, 0.05, 3.5), 3.0)
	tw.parallel().tween_property(rm, "albedo_color:a", 0.0, 3.0)
	_after(3.0, func() -> void:
		app.say("Zadok: " + D.SHRIEK_2, 5.0)
		state.add_doc("doc_zadok_record")
		_note(D.NOTES["zadok_fled"]))
	_after(6.5, func() -> void:
		app.play_sound("amb_sea", Vector3(178, 0, 72), 4.0)
		app.say("Zadok: YHAAAAAA!", 2.5)
		FigureKit.set_seated(_zadok, false)
		var run := _zadok.create_tween()
		run.tween_property(_zadok, "global_position", Vector3(146, 0, 70), 1.2)
		run.tween_property(_zadok, "global_position", Vector3(140, 0, 52), 2.0)
		run.tween_callback(_zadok.hide)
		player.set_eye_height(Player.STAND_H)
		player.seated = false
		player.controls_enabled = true
		_set_phase("after")
		_after_t = 0.0
		state.set_fact("zadok_fled"))


func _update_after(delta: float) -> void:
	_after_t += delta
	var p := player.global_position
	if (p.x < 141.0 or _after_t > 25.0) and _after_t >= 0.0:
		_after_t = -1000.0
		_think(D.THOUGHTS["gone"], 4.0)
		_after(4.0, func() -> void:
			_think(D.THOUGHTS["after"], 4.0)
			_end_chapter())


func _end_chapter() -> void:
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 1.5).finished
	if not is_inside_tree():
		return
	app.ui.chapter_card(D.CARDS["sunset"], 2.5)
	await get_tree().create_timer(2.5, false).timeout
	app.save_checkpoint("cp05_return")
	finished.emit()


# ================================================================ laço

func _physics_process(delta: float) -> void:
	if player == null or capture_mode:
		return
	if _bus_t >= 0.0:
		_update_bus(delta)
		return
	match phase:
		"square", "tour", "zadok_seen", "lure":
			_update_tour(delta)
		"walk":
			_update_tour(delta)
			_update_follow(delta)
		"wharf":
			_update_wharf(delta)
		"after":
			_update_after(delta)
	if phase == "square" and state.has_fact("valise_checked") and player.global_position.distance_to(Vector3(42, 0, 9)) < 4.0 and not state.has_fact("grocery_hint"):
		state.set_fact("grocery_hint")
	_update_observers()
	if player.global_position.y < -6.0:
		_spawn(Vector3(20, 0.05, -2), PI / 2)
		_think("Por pouco. O desfiladeiro é fundo.", 3.0)


func debug_event(id: String) -> void:
	match id:
		"crest":
			_start_bus()
			_bus_t = 46.0
			_update_bus(0.016)
			_bus_t = -1.0
			player.set_view(PI - 0.35, -0.12)
		"green":
			_start_bus()
			_bus_t = 45.0 + 9.0 + 22.0 + 14.0 + 13.0
			_update_bus(0.016)
			_bus_t = -1.0
			_priest.visible = true
			_priest.global_position = Vector3(45.4, -0.6, -110.0)
			player.set_view(-1.4, 0.0)
		"wharf":
			player.set_view(PI / 2, -0.05)
		"sea":
			player.set_view(-PI / 2, -0.05)
