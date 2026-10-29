class_name GilmanChapter
extends ChapterBase
## Fatia vertical: fim de ch05_trap e ch06_gilman_escape (docs/08).
## Constrói a geometria cinza e conduz a sequência canônica do capítulo IV do conto.
## Coordenadas: +x leste (praça), −x oeste (pátio), −z norte (Paine Street), y em metros.


const T = preload("res://data/gilman_text.gd")
const FLOOR4 := 9.0
const CEIL4 := 12.0

var director := SiegeDirector.new()

var doors: Dictionary = {}
var pushables: Dictionary = {}

var _bulb: OmniLight3D
var _corridor_light: OmniLight3D
var _amb_room: AudioStreamPlayer
var _amb_wind: AudioStreamPlayer
var _amb_drone: AudioStreamPlayer
var _amb_falls: AudioStreamPlayer
var _amb_sea: AudioStreamPlayer
var _loiterers: Array[Node3D] = []
var _crowd: Array[Dictionary] = []
var _crowd_active := false
var _crowd_t := 0.0
var _detect_t := 0.0
var _knock_mode := ""
var _knock_t := 0.0
var _lateral := false
var _lateral_t := 0.0
var _ram_hits := 0
var _ram_cool := 0.0
var _hold_acc := 0.0
var _jump_warned := false
var _slip_cool := 0.0
var _wedged_t := -1.0
var _street_t := -1.0
var _curtain: MeshInstance3D
var _drape_out: MeshInstance3D
var _shutter: MeshInstance3D
var _church_lights: Array[Node3D] = []


func _apply_chapter_settings(_v: Dictionary) -> void:
	if director.is_active():
		director.configure(assisted, app.fail_counts)


func _objectives() -> Dictionary:
	return T.OBJECTIVES


func _hints() -> Dictionary:
	return T.HINTS


func _docs() -> Dictionary:
	return T.DOCS


func _journal_key() -> String:
	return "bed" if phase == "listen" else phase


# ================================================================ início

func begin(s: StoryState) -> void:
	state = s
	_init_world()
	_build_square()
	_build_hotel_shell()
	_build_lobby()
	_build_floor4()
	_build_paine_block()
	_build_courtyard()
	_build_washington()
	_build_skyline()
	WorldKit.merge_static(_world)
	_build_audio()
	_make_player()
	director.configure(assisted, app.fail_counts)
	_restore(state.checkpoint)


func _restore(cp: String) -> void:
	player.has_flashlight = state.has_item("item_flashlight")
	match cp:
		"cp05_return":
			_set_time("dusk")
			_spawn(Vector3(12.5, 0.05, 6.5), PI / 2 + 0.35)
			phase = "square"
			if not capture_mode:
				app.ui.chapter_card(T.CHAPTER_CARD, 5.0)
				_after(2.5, func() -> void: _think(T.THOUGHTS["start"]))
		"cp05_room":
			_set_time("twilight")
			doors["hall_428"].set_state(Door.State.OPEN, false)
			_spawn(Vector3(-0.9, FLOOR4 + 0.05, 2.0), PI / 2)
			phase = "room"
			_note(T.NOTES["breakdown"])
			_note(T.NOTES["room"])
		"cp06_knock":
			_set_time("night")
			for f: String in ["missing_bolt_seen", "bolt_removed", "bolt_fitted", "hall_bolted", "north_bolted", "south_bolted", "lay_down", "key_in_lock_done", "connecting_tries_done", "power_cut_done", "bed_at_south", "bureau_at_hall", "south_hinge_read", "north_hinge_read"]:
				state.set_fact(f)
			_apply_room_night()
			pushables["bed_428"].snap_to_target()
			pushables["bureau_428"].snap_to_target()
			_spawn(Vector3(-1.0, FLOOR4 + 0.05, 0.8), PI)
			_restore_notes_night()
			phase = "ram"
			director.notify("prep_min")
			director.notify("bureau_hall")
			if not capture_mode:
				app.ui.chapter_card(T.ESCAPE_CARD, 3.5)
				_after(3.0, func() -> void: _on_director_events(director.start(SiegeDirector.Phase.S1_KNOCK)))
		"cp06_window":
			_set_time("night")
			_apply_room_night()
			pushables["bed_428"].snap_to_target()
			pushables["bureau_428"].snap_to_target()
			doors["c_428_n1"].set_state(Door.State.BROKEN, false)
			doors["c_n1_n2"].set_state(Door.State.CLOSED, false)
			doors["c_n1_n2"].bolted = true
			doors["c_n2_n3"].set_state(Door.State.CLOSED, false)
			doors["c_n2_n3"].bolted = true
			doors["hall_n1"].bolted = true
			doors["hall_n2"].bolted = true
			pushables["bed_n2"].snap_to_target()
			for f: String in ["north_forced", "n1_bolted", "n2_bolted", "n2_north_bolted", "n2_south_bolted", "n2_bed"]:
				state.set_fact(f)
			_spawn(Vector3(-2.5, FLOOR4 + 0.05, -5.6), PI / 2)
			_restore_notes_night()
			_note(T.NOTES["pursuers"])
			phase = "window"
			if not capture_mode:
				director.notify("barricade")
				_on_director_events(director.start(SiegeDirector.Phase.S7_RAM))
				_knock_mode = "abated"
				_lateral = true
		"cp06_roof":
			_set_time("night")
			_apply_room_night()
			_spawn(Vector3(-6.0, 7.2, -5.6), PI / 2)
			_restore_notes_night()
			_drape_out.visible = true
			for l in _church_lights:
				l.visible = true
			phase = "roof"
		"cp06_courtyard":
			_set_time("night")
			_apply_room_night()
			_drape_out.visible = true
			_spawn(Vector3(-9.1, 0.95, -5.2), PI)
			_restore_notes_night()
			_note(T.NOTES["lights"])
			phase = "attic"
		"cp07_washington":
			_set_time("night")
			_spawn(Vector3(-28.0, 0.05, -4.5), PI / 2)
			phase = "street"
	_update_ambience()


func _restore_notes_night() -> void:
	for k: String in ["breakdown", "room", "bolt", "tries", "power", "window", "hinges"]:
		_note(T.NOTES[k])


func _apply_room_night() -> void:
	doors["hall_428"].set_state(Door.State.CLOSED, false)
	doors["hall_428"].bolted = true
	doors["c_428_n1"].bolted = true
	doors["c_s1_428"].bolted = true
	inter["wardrobe"].get_node("bolt").visible = false
	_bulb.visible = false


# ================================================================ ambiente

func _set_time(tod: String) -> void:
	## Perfis provisórios: tod_dusk, tod_interior_lamp/twilight, tod_moon_night (docs/14).
	match tod:
		"dusk":
			_sky.sky_top_color = Color(0.20, 0.17, 0.28)
			_sky.sky_horizon_color = Color(0.78, 0.46, 0.26)
			_sky.ground_horizon_color = Color(0.25, 0.18, 0.14)
			_sky.ground_bottom_color = Color(0.05, 0.04, 0.04)
			_env.ambient_light_color = Color(0.46, 0.38, 0.36)
			_env.ambient_light_energy = 1.0
			_env.fog_light_color = Color(0.55, 0.40, 0.32)
			_env.fog_density = 0.012
			_sun.light_color = Color(1.0, 0.62, 0.36)
			_sun.light_energy = 0.75
			_aim_light(_sun, Vector3(1.0, -0.22, 0.45))
		"twilight":
			_sky.sky_top_color = Color(0.07, 0.07, 0.14)
			_sky.sky_horizon_color = Color(0.32, 0.22, 0.30)
			_sky.ground_horizon_color = Color(0.12, 0.10, 0.12)
			_sky.ground_bottom_color = Color(0.02, 0.02, 0.03)
			_env.ambient_light_color = Color(0.24, 0.22, 0.28)
			_env.ambient_light_energy = 0.9
			_env.fog_light_color = Color(0.18, 0.15, 0.20)
			_env.fog_density = 0.014
			_sun.light_color = Color(0.62, 0.50, 0.66)
			_sun.light_energy = 0.35
			_aim_light(_sun, Vector3(1.0, -0.35, -0.3))
		"night":
			_sky.sky_top_color = Color(0.015, 0.02, 0.04)
			_sky.sky_horizon_color = Color(0.07, 0.09, 0.14)
			_sky.ground_horizon_color = Color(0.04, 0.05, 0.07)
			_sky.ground_bottom_color = Color(0.01, 0.01, 0.02)
			_env.ambient_light_color = Color(0.17, 0.19, 0.27)
			_env.ambient_light_energy = 1.0
			_env.fog_light_color = Color(0.05, 0.06, 0.09)
			_env.fog_density = 0.016
			_sun.light_color = Color(0.62, 0.70, 0.95)
			_sun.light_energy = 0.75
			# Lua quase cheia a sudoeste: entra pelas janelas oeste e deixa o pátio na sombra.
			_aim_light(_sun, Vector3(1.0, -0.62, -0.9))


func _build_audio() -> void:
	_amb_room = _loop("amb_room", -14.0)
	_amb_wind = _loop("amb_wind", -60.0)
	_amb_drone = _loop("amb_drone", -60.0)
	_amb_falls = _loop("amb_falls", -60.0)
	_amb_sea = _loop("amb_sea", -60.0)


func _update_ambience() -> void:
	var outside := phase in ["square", "roof", "street"]
	var in_court := phase in ["courtyard", "hall"]
	_fade_db(_amb_room, -12.0 if not outside else -60.0)
	_fade_db(_amb_wind, -10.0 if outside else (-18.0 if in_court else -30.0))
	_fade_db(_amb_falls, -12.0 if phase == "square" else -40.0)
	_fade_db(_amb_sea, -26.0 if outside else -40.0)
	var danger := phase in ["ram", "n1", "n2", "barricade", "window"]
	_fade_db(_amb_drone, -14.0 if danger else (-24.0 if phase in ["prepare", "listen", "roof", "attic", "courtyard", "hall"] else -60.0))


# ================================================================ geometria: praça e hotel

func _build_square() -> void:
	WorldKit.box(_world, Vector3(28, -0.1, 0), Vector3(44, 0.2, 60), M_COBBLE)
	# Semicírculo de blocos de tijolo de ~1800 [C]; lojas com vitrines escuras.
	# Fachadas no arco sul/leste da praça, voltadas para o centro; o rio fecha o lado norte.
	var center := Vector3(26, 0, -6)
	var spots: Array[Vector3] = [Vector3(11, 0, 19), Vector3(18.5, 0, 22), Vector3(26.5, 0, 23), Vector3(34.5, 0, 21.5), Vector3(41, 0, 17), Vector3(45.5, 0, 10), Vector3(47.5, 0, 1.5), Vector3(47.5, 0, -8), Vector3(46.5, 0, -18)]
	for i in spots.size():
		var p := spots[i]
		var h := 7.5 + float(i % 3)
		var b := WorldKit.box(_world, Vector3(p.x, h * 0.5, p.z), Vector3(8, h, 7), M_BRICK)
		b.look_at(Vector3(center.x, h * 0.5, center.z), Vector3.UP)
		var shop := WorldKit.box(b, Vector3(0, -h * 0.5 + 1.2, -3.55), Vector3(5, 2.0, 0.1), TexFactory.flat(Color(0.04, 0.04, 0.05)), false)
		if i == 3:
			# Restaurante, iluminado [C].
			shop.material_override = TexFactory.flat(Color(0.5, 0.36, 0.18), true)
		if i == 8:
			# Escritório da Marsh Refining Company, na ponta leste junto ao rio [C].
			shop.material_override = TexFactory.flat(Color(0.12, 0.10, 0.07))
	WorldKit.box(_world, Vector3(4.0, 4.0, 17.5), Vector3(10, 8, 8), M_BRICK)
	WorldKit.blocker(_world, Vector3(7.0, 3.0, -21.0), Vector3(0.5, 6.0, 18.0))
	# Rio Manuxet: borda reta ao norte, com parapeito e o vazio do desfiladeiro [C].
	WorldKit.box(_world, Vector3(28, 0.5, -30.5), Vector3(44, 1.0, 0.3), M_BRICK)
	WorldKit.box(_world, Vector3(28, -8, -40), Vector3(60, 0.2, 18), TexFactory.flat(Color(0.03, 0.04, 0.05)), false)
	WorldKit.blocker(_world, Vector3(28, 2, -30.8), Vector3(44, 4, 0.5))
	# Ponte de ferro da Federal para o norte.
	WorldKit.box(_world, Vector3(30, 0.0, -40), Vector3(7, 0.4, 19), M_WOOD, false)
	for side: float in [-3.6, 3.6]:
		WorldKit.box(_world, Vector3(30 + side, 0.6, -40), Vector3(0.12, 1.0, 19), TexFactory.flat(Color(0.12, 0.12, 0.13)), false)
	WorldKit.blocker(_world, Vector3(30, 2, -31.2), Vector3(7, 4, 0.4))
	WorldKit.blocker(_world, Vector3(50, 3, 0), Vector3(0.5, 6, 60))
	WorldKit.blocker(_world, Vector3(28, 3, 25), Vector3(44, 6, 0.5))
	# Lâmpadas fracas e poucas [C].
	for lp: Vector3 in [Vector3(16, 4, -12), Vector3(34, 4, 8)]:
		WorldKit.box(_world, Vector3(lp.x, 2.0, lp.z), Vector3(0.12, 4.0, 0.12), TexFactory.flat(Color(0.08, 0.08, 0.08)), false)
		WorldKit.box(_world, lp + Vector3(0, 0.2, 0), Vector3(0.25, 0.25, 0.25), TexFactory.flat(Color(1, 0.8, 0.45), true), false)
		WorldKit.omni(_world, lp, Color(1.0, 0.72, 0.4), 0.9, 7.0)
	# Ônibus de Joe Sargent: "Arkham-Innsmouth-Newb'port" [C].
	var bus := Node3D.new()
	bus.set_meta("dynamic", true)
	bus.position = Vector3(15.0, 0, 10.0)
	_world.add_child(bus)
	WorldKit.box(bus, Vector3(0, 1.45, 0), Vector3(2.4, 2.3, 7.0), TexFactory.flat(Color(0.33, 0.33, 0.31)))
	WorldKit.box(bus, Vector3(-1.21, 1.9, -0.4), Vector3(0.02, 0.8, 5.6), TexFactory.flat(Color(0.05, 0.06, 0.07)), false)
	WorldKit.box(bus, Vector3(1.21, 1.9, -0.4), Vector3(0.02, 0.8, 5.6), TexFactory.flat(Color(0.05, 0.06, 0.07)), false)
	for wz: float in [-2.3, 2.3]:
		for wx: float in [-1.15, 1.15]:
			var w := WorldKit.box(bus, Vector3(wx, 0.42, wz), Vector3(0.3, 0.84, 0.84), TexFactory.flat(Color(0.05, 0.05, 0.05)), false)
			w.rotation.z = 0.0
	var sargent := WorldKit.figure(_world, Vector3(12.9, 0, 7.6), 1.85, false, false, "man")
	FigureKit.add_staring_eyes(sargent)
	sargent.rotation.y = -PI / 2
	_inter("sargent", Vector3(12.9, 0.9, 7.6), Vector3(0.8, 1.8, 0.8),
		func() -> String: return "Falar com Joe Sargent" if phase == "square" else "",
		func(_i: Interactable) -> void: _talk_sargent())
	# Ociosos junto à porta do Gilman: olham, sem perigo (evt_gilman_crowd).
	for i in 5:
		var f := WorldKit.figure(_world, Vector3(8.0 + (i % 2) * 0.9, 0, -3.2 + i * 1.4), 1.6 + 0.08 * (i % 3))
		_loiterers.append(f)
	_inter("gilman_door", Vector3(6.25, 1.3, 0), Vector3(0.4, 2.6, 1.6),
		func() -> String:
			if phase == "square":
				return "Entrar no Gilman House"
			return "",
		func(_i: Interactable) -> void: _enter_lobby())


func _build_hotel_shell() -> void:
	# Gilman House: x −5..6, z −12..12, cinco pavimentos com cúpula [C].
	var wins_w: Array = []
	for a: float in [-12.0, -8.0, -4.0, 0.0, 4.0, 8.0]:
		wins_w.append(Vector4(a + 0.45, a + 1.35, FLOOR4 + 0.9, FLOOR4 + 2.3))
		wins_w.append(Vector4(a + 2.65, a + 3.55, FLOOR4 + 0.9, FLOOR4 + 2.3))
	var rear := wins_w.duplicate()
	rear.append(Vector4(-0.6, 0.6, 0.0, 2.3))
	WorldKit.wall_z(_world, -5.0, -12.0, 12.0, 0.0, 13.0, M_CLAP, rear, 0.25)
	for w: Vector4 in wins_w:
		WorldKit.blocker(_world, Vector3(-5.0, (w.z + w.w) * 0.5, (w.x + w.y) * 0.5), Vector3(0.4, w.w - w.z, w.y - w.x))
	WorldKit.wall_z(_world, 6.0, -12.0, 12.0, 0.0, 13.0, M_CLAP, [Vector4(-0.8, 0.8, 0.0, 2.6)], 0.25)
	WorldKit.wall_x(_world, -12.0, -5.0, 6.0, 0.0, 13.0, M_CLAP, [], 0.25)
	WorldKit.wall_x(_world, 12.0, -5.0, 6.0, 0.0, 13.0, M_CLAP, [], 0.25)
	WorldKit.box(_world, Vector3(0.5, 13.1, 0), Vector3(11.4, 0.2, 24.4), M_SLATE)
	# Cúpula com restos de tinta amarela [C].
	WorldKit.box(_world, Vector3(1.5, 14.2, 0), Vector3(3, 2.2, 3), TexFactory.flat(Color(0.45, 0.40, 0.22)), false)
	WorldKit.box(_world, Vector3(1.5, 15.6, 0), Vector3(2.0, 0.6, 2.0), M_SLATE, false)
	# Janelas acesas fracamente nos andares inferiores (vistas do pátio e da praça).
	for fl: float in [3.8, 6.8]:
		for wz: float in [-9.0, -3.0, 2.5, 7.0]:
			WorldKit.box(_world, Vector3(-5.16, fl, wz), Vector3(0.04, 1.2, 0.8), TexFactory.flat(Color(0.32, 0.24, 0.10), true), false)
	for fl2: float in [1.6, 4.6]:
		for wz2: float in [-6.0, 5.0]:
			WorldKit.box(_world, Vector3(6.16, fl2, wz2), Vector3(0.04, 1.2, 0.8), TexFactory.flat(Color(0.30, 0.22, 0.10), true), false)
	# Letreiro meio apagado.
	WorldKit.box(_world, Vector3(6.2, 3.4, 0), Vector3(0.06, 0.6, 4.0), TexFactory.flat(Color(0.42, 0.36, 0.18)), false)
	# Porta dos fundos para o pátio (por onde sairá a multidão).
	var rd := Door.new().build("gilman_rear", 1.2, 2.3, false, -1.0, M_WOOD)
	rd.position = Vector3(-5.0, 0.0, -0.6)
	_world.add_child(rd)
	doors["gilman_rear"] = rd


func _build_lobby() -> void:
	WorldKit.box(_world, Vector3(0.5, -0.1, 0), Vector3(11, 0.2, 24), M_FLOOR)
	WorldKit.box(_world, Vector3(0.5, 3.6, 0), Vector3(11, 0.2, 24), M_CEIL, false)
	WorldKit.wall_z(_world, 2.0, -4.0, 4.0, 0.0, 3.6, M_WALL)
	WorldKit.wall_x(_world, -4.0, 2.0, 6.0, 0.0, 3.6, M_WALL)
	WorldKit.wall_x(_world, 4.0, 2.0, 6.0, 0.0, 3.6, M_WALL)
	WorldKit.box(_world, Vector3(3.3, 0.55, -2.3), Vector3(0.6, 1.1, 2.2), M_WOOD)
	var clerk := WorldKit.figure(_world, Vector3(2.6, 0, -2.3), 1.7, false, false, "clerk")
	FigureKit.add_staring_eyes(clerk)
	clerk.rotation.y = -PI / 2
	WorldKit.omni(_world, Vector3(4.0, 3.2, 0), Color(1.0, 0.75, 0.45), 0.8, 6.0)
	_inter("night_clerk", Vector3(3.3, 1.2, -2.3), Vector3(0.8, 1.4, 2.2),
		func() -> String: return "Falar com o funcionário" if phase == "lobby" else "",
		func(_i: Interactable) -> void: _talk_clerk())
	_inter("lobby_stairs", Vector3(2.6, 1.2, 3.3), Vector3(1.0, 2.4, 1.2),
		func() -> String:
			if phase == "upstairs":
				return "Subir os três lances até o andar do 428"
			if phase == "lobby":
				return "Escada (antes, pedir um quarto)"
			return "",
		func(_i: Interactable) -> void:
			if phase == "upstairs":
				_go_upstairs())


func _room_z(id: String) -> float:
	## Borda sul (z menor) de cada quarto no 4º andar.
	return {"n3": -12.0, "n2": -8.0, "n1": -4.0, "428": 0.0, "s1": 4.0, "s2": 8.0}[id]


func room_of(p: Vector3) -> String:
	if p.y < FLOOR4 - 0.5 or p.y > CEIL4:
		return ""
	if p.x > 0.0:
		return "corridor"
	for id: String in ["n3", "n2", "n1", "428", "s1", "s2"]:
		var a := _room_z(id)
		if p.z >= a and p.z < a + 4.0:
			return id
	return ""


func _build_floor4() -> void:
	WorldKit.box(_world, Vector3(0.5, FLOOR4 - 0.1, 0), Vector3(11, 0.2, 24), M_FLOOR)
	WorldKit.box(_world, Vector3(0.5, CEIL4 + 0.1, 0), Vector3(11, 0.2, 24), M_CEIL, false)
	# Parede quartos|corredor com portas do corredor.
	var hall_ops: Array = []
	for id: String in ["n3", "n2", "n1", "428", "s1", "s2"]:
		var a := _room_z(id)
		hall_ops.append(Vector4(a + 1.55, a + 2.45, FLOOR4, FLOOR4 + 2.05))
	WorldKit.wall_z(_world, 0.0, -12.0, 12.0, FLOOR4, CEIL4, M_WALL, hall_ops)
	WorldKit.wall_z(_world, 2.2, -12.0, 12.0, FLOOR4, CEIL4, M_WALL)
	# Face interna da parede oeste (papel de parede), com as janelas dos quartos.
	var wins: Array = []
	for a: float in [-12.0, -8.0, -4.0, 0.0, 4.0, 8.0]:
		wins.append(Vector4(a + 0.45, a + 1.35, FLOOR4 + 0.9, FLOOR4 + 2.3))
		wins.append(Vector4(a + 2.65, a + 3.55, FLOOR4 + 0.9, FLOOR4 + 2.3))
	WorldKit.wall_z(_world, -4.86, -12.0, 12.0, FLOOR4, CEIL4, M_WALL, wins, 0.02)
	# Portas dos quartos da frente (fechadas, decorativas).
	for fz: float in [-9.0, -5.0, -1.0, 3.0, 7.0]:
		WorldKit.box(_world, Vector3(2.12, FLOOR4 + 1.02, fz), Vector3(0.05, 2.05, 0.9), M_WOOD, false)
	# Divisórias entre quartos, com portas de ligação.
	for z: float in [-8.0, -4.0, 0.0, 4.0, 8.0]:
		WorldKit.wall_x(_world, z, -5.0, 0.0, FLOOR4, CEIL4, M_WALL, [Vector4(-1.25, -0.35, FLOOR4, FLOOR4 + 2.05)])
	# Escada no fim sul do corredor; banheiro no fim norte [C].
	WorldKit.box(_world, Vector3(1.1, FLOOR4 + 1.0, 11.6), Vector3(2.0, 2.0, 0.6), TexFactory.flat(Color(0.02, 0.02, 0.02)), false)
	WorldKit.blocker(_world, Vector3(1.1, FLOOR4 + 1.0, 11.2), Vector3(2.2, 2.0, 0.4))
	_inter("stairs4", Vector3(1.1, FLOOR4 + 1.0, 11.0), Vector3(2.0, 2.0, 0.4),
		func() -> String: return "Escada" if phase != "upstairs" else "",
		func(_i: Interactable) -> void:
			if state.has_fact("power_cut_done"):
				_think(T.THOUGHTS["stairs_no"])
			else:
				_think("Não há por que descer de novo esta noite."))
	WorldKit.box(_world, Vector3(1.1, FLOOR4 + 1.0, -11.9), Vector3(0.9, 2.0, 0.05), M_WOOD, false)
	_inter("bathroom", Vector3(1.1, FLOOR4 + 1.0, -11.6), Vector3(0.9, 2.0, 0.4),
		func() -> String: return "Banheiro" if phase in ["room", "bed"] else "",
		func(_i: Interactable) -> void: _think("Uma relíquia desanimadora: pia de mármore antigo, banheira de lata, luz fraca, lambris de madeira mofada."))
	_corridor_light = WorldKit.omni(_world, Vector3(1.1, FLOOR4 + 2.4, 2.0), Color(1.0, 0.65, 0.35), 0.0, 5.5)
	_build_doors4()
	_build_room_428()
	_build_rooms_north()


func _build_doors4() -> void:
	for id: String in ["n3", "n2", "n1", "428", "s1", "s2"]:
		var a := _room_z(id)
		var d := Door.new().build("hall_" + id, 0.9, 2.05, false, -1.0, M_WOOD)
		d.position = Vector3(0.0, FLOOR4, a + 1.55)
		d.ref_room = id
		_world.add_child(d)
		doors["hall_" + id] = d
		d.locked_other_side = id != "428"
	var links := {"c_n2_n3": -8.0, "c_n1_n2": -4.0, "c_428_n1": 0.0, "c_s1_428": 4.0, "c_s2_s1": 8.0}
	for id: String in links.keys():
		var d2 := Door.new().build(id, 0.9, 2.05, true, 1.0, M_WOOD)
		d2.position = Vector3(-1.25, FLOOR4, links[id])
		_world.add_child(d2)
		doors[id] = d2
	doors["c_n1_n2"].set_state(Door.State.AJAR, false)
	doors["c_n2_n3"].set_state(Door.State.OPEN, false)
	doors["hall_428"].set_state(Door.State.OPEN, false)
	for id3: String in doors.keys():
		var dd: Door = doors[id3]
		var cid: String = id3
		dd.prompt_provider = func() -> String: return _door_prompt(cid)
		dd.on_use = func(_i: Interactable) -> void: _door_use(cid)


func _build_room_428() -> void:
	var a := 0.0
	# Cama de ferro (empurrável contra a porta sul) e cômoda (contra a porta do corredor) [C].
	var bed := Pushable.new().build_box("bed_428", Vector3(1.0, 0.55, 2.0), M_WOOD)
	bed.transform = Transform3D(Basis(Vector3.UP, PI / 2), Vector3(-3.3, FLOOR4, a + 3.45))
	_world.add_child(bed)
	bed.set_target(Transform3D(Basis(Vector3.UP, PI / 2), Vector3(-0.8, FLOOR4, a + 3.45)))
	pushables["bed_428"] = bed
	bed.prompt_provider = func() -> String: return _bed428_prompt()
	bed.on_use = func(_i: Interactable) -> void: _bed428_use()
	var bureau := Pushable.new().build_box("bureau_428", Vector3(1.2, 1.0, 0.5), M_WOOD)
	bureau.transform = Transform3D(Basis(Vector3.UP, PI / 2), Vector3(-4.7, FLOOR4, a + 2.0))
	_world.add_child(bureau)
	bureau.set_target(Transform3D(Basis(Vector3.UP, PI / 2), Vector3(-0.32, FLOOR4, a + 2.0)))
	pushables["bureau_428"] = bureau
	bureau.prompt_provider = func() -> String:
		if bureau.at_target or not state.has_fact("power_cut_done") or state.has_fact("north_forced"):
			return ""
		return "Empurrar a cômoda contra a porta do corredor"
	bureau.on_use = func(_i: Interactable) -> void:
		_timed(2.4, "sfx_scrape", bureau.global_position, func() -> void:
			bureau.slide(0.1)
			state.set_fact("bureau_at_hall")
			director.notify("bureau_hall"))
	# Armário (clothes-press) com o ferrolho do mesmo tamanho [C].
	var ward := _inter("wardrobe", Vector3(-3.6, FLOOR4 + 1.0, a + 0.33), Vector3(1.1, 2.0, 0.55),
		func() -> String: return _wardrobe_prompt(),
		func(_i: Interactable) -> void: _wardrobe_use(), true)
	WorldKit.box(ward, Vector3.ZERO, Vector3(1.1, 2.0, 0.55), M_WOOD, false)
	var bolt := WorldKit.box(ward, Vector3(0.35, 0.0, 0.29), Vector3(0.14, 0.05, 0.03), TexFactory.flat(Color(0.5, 0.45, 0.3)), false)
	bolt.name = "bolt"
	# Cadeira com a valise.
	WorldKit.box(_world, Vector3(-2.0, FLOOR4 + 0.25, a + 0.6), Vector3(0.45, 0.5, 0.45), M_WOOD)
	var val := _inter("valise", Vector3(-2.0, FLOOR4 + 0.66, a + 0.6), Vector3(0.5, 0.32, 0.3),
		func() -> String: return "Tirar a lanterna da valise" if not state.has_item("item_flashlight") and phase != "square" else "",
		func(_i: Interactable) -> void:
			state.give_item("item_flashlight")
			player.has_flashlight = true
			app.play_sound("sfx_cloth")
			_think(T.THOUGHTS["flashlight"]))
	WorldKit.box(val, Vector3.ZERO, Vector3(0.5, 0.3, 0.28), TexFactory.flat(Color(0.25, 0.16, 0.09)), false)
	# Lâmpada única e interruptor [C].
	_bulb = WorldKit.omni(_world, Vector3(-2.5, CEIL4 - 0.5, a + 2.0), Color(1.0, 0.78, 0.5), 0.9, 7.0, true)
	# A malha é filha da luz: apagar a lâmpada apaga também o brilho.
	WorldKit.box(_bulb, Vector3(0, 0.1, 0), Vector3(0.12, 0.16, 0.12), TexFactory.flat(Color(1, 0.85, 0.6), true), false)
	WorldKit.box(_world, Vector3(-2.5, CEIL4 - 0.2, a + 2.0), Vector3(0.02, 0.4, 0.02), TexFactory.flat(Color(0.05, 0.05, 0.05)), false)
	_inter("switch", Vector3(-0.12, FLOOR4 + 1.35, a + 2.85), Vector3(0.12, 0.2, 0.2),
		func() -> String:
			if state.has_fact("power_cut_done"):
				return "Interruptor"
			if phase in ["room", "bed"]:
				return "Apagar a luz" if _bulb.visible else "Acender a luz"
			return "",
		func(_i: Interactable) -> void:
			app.play_sound("sfx_switch")
			if state.has_fact("power_cut_done"):
				_think("Nada. Sem energia.")
			else:
				_bulb.visible = not _bulb.visible)
	# Jornal sobre a cama (depois do jantar).
	_inter("paper", Vector3(-3.0, FLOOR4 + 0.62, a + 3.4), Vector3(0.4, 0.1, 0.3),
		func() -> String: return "Ler o jornal" if state.has_fact("paper_bought") and not pushables["bed_428"].at_target else "",
		func(_i: Interactable) -> void: _open_doc("doc_evening_paper"))
	# Janelas: vista oeste [C].
	for wz: float in [a + 0.9, a + 3.1]:
		_inter("window_428_%d" % int(wz), Vector3(-4.85, FLOOR4 + 1.6, wz), Vector3(0.2, 1.4, 0.9),
			func() -> String: return "Olhar pela janela",
			func(_i: Interactable) -> void: _window_428())


func _build_rooms_north() -> void:
	var n1 := _room_z("n1")
	WorldKit.box(_world, Vector3(-3.3, FLOOR4 + 0.28, n1 + 0.6), Vector3(2.0, 0.55, 1.0), M_WOOD)
	_inter("window_n1", Vector3(-4.85, FLOOR4 + 1.6, n1 + 3.1), Vector3(0.2, 1.4, 0.9),
		func() -> String: return "Olhar pela janela",
		func(_i: Interactable) -> void: _think("Queda livre sobre o pátio. Nenhum telhado ao alcance desta janela."))
	_inter("dust_n1", Vector3(-1.0, FLOOR4 + 0.05, n1 + 3.2), Vector3(1.2, 0.1, 1.0),
		func() -> String: return "Pegadas na poeira" if state.has_fact("north_forced") and player.is_flashlight_on() else "",
		func(_i: Interactable) -> void: _think("Pegadas na poeira, de quem tentou minha porta deste lado. Há algo de terrivelmente singular nelas."), false)
	var n2 := _room_z("n2")
	var bed := Pushable.new().build_box("bed_n2", Vector3(1.0, 0.55, 2.0), M_WOOD)
	bed.transform = Transform3D(Basis(Vector3.UP, PI / 2), Vector3(-3.3, FLOOR4, n2 + 0.55))
	_world.add_child(bed)
	bed.set_target(Transform3D(Basis(Vector3.UP, PI / 2), Vector3(-0.8, FLOOR4, n2 + 0.55)))
	pushables["bed_n2"] = bed
	bed.prompt_provider = func() -> String:
		if bed.at_target or not state.has_fact("n2_bolted"):
			return ""
		if doors["c_n2_n3"].state != Door.State.CLOSED:
			return "Cama (primeiro, fechar a porta norte)"
		return "Empurrar a cama contra a porta norte"
	bed.on_use = func(_i: Interactable) -> void:
		if doors["c_n2_n3"].state != Door.State.CLOSED:
			return
		_timed(1.6, "sfx_scrape", bed.global_position, func() -> void:
			bed.slide(0.1)
			state.set_fact("n2_bed")
			_on_director_events(director.notify("barricade")))
	var bureau := Pushable.new().build_box("bureau_n2", Vector3(1.2, 1.0, 0.5), M_WOOD)
	bureau.transform = Transform3D(Basis.IDENTITY, Vector3(-2.6, FLOOR4, n2 + 3.7))
	_world.add_child(bureau)
	bureau.set_target(Transform3D(Basis.IDENTITY, Vector3(-0.8, FLOOR4, n2 + 3.68)))
	pushables["bureau_n2"] = bureau
	bureau.prompt_provider = func() -> String:
		if bureau.at_target or not state.has_fact("n2_bolted"):
			return ""
		if doors["c_n1_n2"].state != Door.State.CLOSED:
			return "Cômoda (primeiro, fechar a porta sul)"
		return "Empurrar a cômoda contra a porta sul"
	bureau.on_use = func(_i: Interactable) -> void:
		if doors["c_n1_n2"].state != Door.State.CLOSED:
			return
		_timed(1.4, "sfx_scrape", bureau.global_position, func() -> void:
			bureau.slide(0.1)
			state.set_fact("n2_bureau")
			_on_director_events(director.notify("barricade")))
	var wash := Pushable.new().build_box("washstand_n2", Vector3(0.6, 0.9, 0.5), M_WOOD)
	wash.transform = Transform3D(Basis.IDENTITY, Vector3(-4.6, FLOOR4, n2 + 2.0))
	_world.add_child(wash)
	wash.set_target(Transform3D(Basis(Vector3.UP, PI / 2), Vector3(-0.35, FLOOR4, n2 + 2.0)))
	pushables["washstand_n2"] = wash
	wash.prompt_provider = func() -> String:
		return "" if wash.at_target or not state.has_fact("n2_bolted") else "Empurrar o lavatório diante da porta do corredor"
	wash.on_use = func(_i: Interactable) -> void:
		_timed(1.2, "sfx_scrape", wash.global_position, func() -> void:
			wash.slide(0.1)
			state.set_fact("n2_washstand")
			_on_director_events(director.notify("barricade")))
	# Cortinas de veludo com varão e argolas de latão; gancho da veneziana lá fora [C].
	_curtain = WorldKit.box(_world, Vector3(-4.82, FLOOR4 + 1.55, n2 + 3.1), Vector3(0.05, 2.0, 1.4), TexFactory.material("velour", 1.0), false)
	_curtain.set_meta("dynamic", true)
	_drape_out = WorldKit.box(_world, Vector3(-5.25, FLOOR4 - 0.6, n2 + 3.1), Vector3(0.05, 3.2, 0.7), TexFactory.material("velour", 1.0), false)
	_drape_out.set_meta("dynamic", true)
	_drape_out.visible = false
	_inter("curtains", Vector3(-4.75, FLOOR4 + 1.55, n2 + 3.1), Vector3(0.2, 2.0, 1.4),
		func() -> String: return _window_n2s_prompt(),
		func(_i: Interactable) -> void: _window_n2s_use())
	_inter("window_n2_north", Vector3(-4.85, FLOOR4 + 1.6, n2 + 0.9), Vector3(0.2, 1.4, 0.9),
		func() -> String: return "Saltar para o telhado (arriscado)" if _jump_warned else "Olhar pela janela",
		func(_i: Interactable) -> void:
			if not _jump_warned:
				_jump_warned = true
				_think(T.THOUGHTS["jump_warning"])
			else:
				_fail("F5"))


# ================================================================ geometria: telhado, armazém, pátio, rua

func _build_paine_block() -> void:
	# Bloco comercial em ruína encostado ao norte do pátio: x −17..−5, z −14..−4 [C].
	var x0 := -17.0
	var x1 := -5.0
	WorldKit.wall_x(_world, -4.0, x0, x1, 0.0, 6.0, M_BRICK, [Vector4(-9.6, -8.6, 0.9, 3.0), Vector4(-14.0, -13.0, 3.6, 5.0), Vector4(-7.0, -6.2, 3.6, 5.0)], 0.3)
	WorldKit.wall_x(_world, -14.0, x0, x1, 0.0, 6.0, M_BRICK, [Vector4(-11.6, -10.4, 0.9, 3.0)], 0.3)
	WorldKit.wall_z(_world, x0, -14.0, -4.0, 0.0, 6.0, M_BRICK, [], 0.3)
	# A fachada da Paine brilha fraca ao fundo [C].
	WorldKit.box(_world, Vector3(-11.0, 1.95, -14.4), Vector3(1.2, 2.1, 0.05), TexFactory.flat(Color(0.25, 0.28, 0.34), true), false)
	WorldKit.box(_world, Vector3(-11.0, 0.45, -9.0), Vector3(12, 0.9, 10), M_DIRT)
	WorldKit.floor_with_holes(_world, x0, x1, -14.0, -4.0, 2.9, M_FLOOR, [Rect2(-11.6, -11.75, 5.2, 1.6)])
	WorldKit.floor_with_holes(_world, x0, x1, -14.0, -4.0, 4.9, M_FLOOR, [Rect2(-11.6, -13.4, 5.2, 1.65)])
	WorldKit.ramp(_world, Vector3(-6.4, 4.9, -12.6), Vector3(-11.4, 2.9, -12.6), 1.3, M_WOOD)
	WorldKit.ramp(_world, Vector3(-11.4, 2.9, -10.95), Vector3(-6.4, 0.9, -10.95), 1.3, M_WOOD)
	# Caixas e barris no sótão [C].
	for p: Vector3 in [Vector3(-13, 5.3, -6.0), Vector3(-14.5, 5.3, -8.5), Vector3(-7.5, 5.3, -8.0), Vector3(-15, 1.3, -6), Vector3(-6.5, 3.3, -6.5)]:
		WorldKit.box(_world, p, Vector3(0.8, 0.8, 0.8), M_WOOD)
	# Telhado de ardósia: água interna (sul) e externa (norte).
	var rise := 2.8
	var run := 5.0
	var ang := atan(rise / run)
	var length := sqrt(rise * rise + run * run)
	WorldKit.slope(_world, Vector3(-11.0, 6.0 + rise * 0.5, -4.0 - run * 0.5), Vector3(12.4, 0.2, length), ang, M_SLATE)
	WorldKit.slope(_world, Vector3(-11.0, 6.0 + rise * 0.5, -14.0 + run * 0.5), Vector3(12.4, 0.2, length), -ang, M_SLATE)
	WorldKit.blocker(_world, Vector3(-11.0, 10.0, -9.3), Vector3(12.4, 2.4, 0.3))
	WorldKit.blocker(_world, Vector3(-16.95, 8.5, -6.5), Vector3(0.3, 4.0, 5.0))
	# Claraboia escura, sem escada embaixo [C].
	var sky_z := -6.3
	var sky_y := 6.0 + (-4.0 - sky_z) / run * rise
	var sl := WorldKit.box(_world, Vector3(-9.5, sky_y + 0.12, sky_z), Vector3(1.0, 0.05, 1.0), TexFactory.flat(Color(0.0, 0.0, 0.0)), false)
	sl.rotation.x = ang
	_inter("skylight", Vector3(-9.5, sky_y + 0.3, sky_z), Vector3(1.2, 0.5, 1.2),
		func() -> String: return "Descer pela claraboia" if phase == "roof" else "",
		func(_i: Interactable) -> void: _skylight(), false)
	_inter("paine_door", Vector3(-11.0, 1.95, -13.8), Vector3(1.2, 2.1, 0.3),
		func() -> String: return "Porta da Paine Street" if phase == "attic" else "",
		func(_i: Interactable) -> void: _think(T.THOUGHTS["paine_door"]))
	var back := Door.new().build("warehouse_back", 1.0, 2.1, true, -1.0, M_WOOD)
	back.position = Vector3(-9.6, 0.9, -4.0)
	_world.add_child(back)
	doors["warehouse_back"] = back
	back.prompt_provider = func() -> String: return "Sair pelos fundos, para o pátio" if phase == "attic" and back.state == Door.State.CLOSED else ""
	back.on_use = func(_i: Interactable) -> void: _back_door()
	WorldKit.ramp(_world, Vector3(-9.1, 0.9, -4.15), Vector3(-9.1, 0.0, -2.7), 1.0, M_PLASTER)


func _build_courtyard() -> void:
	WorldKit.box(_world, Vector3(-11.0, -0.1, 0.0), Vector3(12.2, 0.2, 8.2), M_COBBLE)
	# Bloco sul, igualmente deserto.
	WorldKit.box(_world, Vector3(-11.0, 3.0, 8.0), Vector3(12.0, 6.0, 8.0), M_BRICK)
	WorldKit.slope(_world, Vector3(-11.0, 7.0, 5.5), Vector3(12.4, 0.2, 5.4), 0.5, M_SLATE)
	# Prédio do lado da Washington: x −25..−17 [C], portas abertas para o pátio.
	var bx0 := -25.0
	var bx1 := -17.0
	WorldKit.box(_world, Vector3(-21.0, -0.1, 0.0), Vector3(8.2, 0.2, 14.0), M_FLOOR)
	WorldKit.box(_world, Vector3(-21.0, 3.2, 0.0), Vector3(8.2, 0.2, 14.0), M_CEIL, false)
	WorldKit.box(_world, Vector3(-21.0, 6.6, 0.0), Vector3(8.4, 0.3, 14.2), M_SLATE)
	WorldKit.wall_z(_world, bx1, -7.0, 7.0, 0.0, 6.5, M_BRICK, [Vector4(-2.5, -1.5, 0.0, 2.2), Vector4(2.0, 3.0, 0.0, 2.2)], 0.3)
	WorldKit.wall_z(_world, bx0, -7.0, 7.0, 0.0, 6.5, M_CLAP, [Vector4(-2.5, -1.5, 0.0, 2.2), Vector4(-5.0, -4.0, 0.7, 2.1)], 0.3)
	WorldKit.wall_x(_world, -7.0, bx0, bx1, 0.0, 6.5, M_BRICK, [], 0.3)
	WorldKit.wall_x(_world, 7.0, bx0, bx1, 0.0, 6.5, M_BRICK, [], 0.3)
	# Corredor A: da porta do pátio até a porta da rua emperrada.
	WorldKit.wall_x(_world, -2.9, bx0, bx1, 0.0, 3.2, M_PLASTER, [Vector4(-21.5, -20.6, 0.0, 2.05)])
	WorldKit.wall_x(_world, -1.1, bx0, bx1, 0.0, 3.2, M_PLASTER)
	var street_door := Door.new().build("wedged_door", 1.0, 2.2, false, 1.0, M_WOOD)
	street_door.position = Vector3(bx0 + 0.05, 0.0, -2.5)
	_world.add_child(street_door)
	doors["wedged_door"] = street_door
	street_door.prompt_provider = func() -> String: return "Forçar a porta da rua" if phase in ["courtyard", "hall"] else ""
	street_door.on_use = func(_i: Interactable) -> void:
		street_door.shake(2.0)
		app.play_sound("sfx_thud", street_door.global_position)
		_think(T.THOUGHTS["wedged"])
		if state.set_fact("wedged_door_seen"):
			_set_phase("hall")
			_wedged_t = 0.0
	# Porta lateral do corredor para a sala vazia.
	var side := Door.new().build("side_door", 0.9, 2.05, true, 1.0, M_WOOD)
	side.position = Vector3(-21.5, 0.0, -2.9)
	_world.add_child(side)
	doors["side_door"] = side
	side.prompt_provider = func() -> String: return "Abrir a porta lateral" if side.state == Door.State.CLOSED and phase in ["courtyard", "hall"] else ""
	side.on_use = func(_i: Interactable) -> void:
		side.set_state(Door.State.OPEN)
		app.play_sound("sfx_creak", side.global_position)
	# Sala vazia: paredes e venezianas sem caixilhos [C].
	WorldKit.wall_z(_world, -19.0, -7.0, -2.9, 0.0, 3.2, M_PLASTER)
	_shutter = WorldKit.box(_world, Vector3(bx0 - 0.02, 1.4, -4.5), Vector3(0.06, 1.4, 1.0), M_WOOD, false)
	_shutter.set_meta("dynamic", true)
	WorldKit.blocker(_world, Vector3(bx0, 1.4, -4.5), Vector3(0.3, 1.4, 1.0))
	_inter("shutters", Vector3(bx0 + 0.2, 1.4, -4.5), Vector3(0.3, 1.4, 1.0),
		func() -> String:
			if phase in ["courtyard", "hall"]:
				return "Abrir as venezianas e sair para a Washington Street"
			if phase == "street" and not state.has_fact("shutter_closed") and player.global_position.x < bx0:
				return "Fechar a veneziana como estava"
			return "",
		func(_i: Interactable) -> void: _shutter_use())
	_inter("boarded", Vector3(bx1 + 0.2, 1.1, 2.5), Vector3(0.3, 2.2, 1.0),
		func() -> String: return "Porta" if phase in ["courtyard", "hall"] else "",
		func(_i: Interactable) -> void: _think("Tábuas pregadas por dentro."))
	WorldKit.wall_x(_world, 2.0, bx0, bx1, 0.0, 3.2, M_PLASTER)
	WorldKit.wall_x(_world, 3.0, bx0, bx1, 0.0, 3.2, M_PLASTER)


func _build_washington() -> void:
	# Washington Street ao luar; luzes públicas apagadas [C].
	WorldKit.box(_world, Vector3(-35.0, -0.1, 0.0), Vector3(20.0, 0.2, 90.0), M_COBBLE)
	for i in 8:
		var z := -36.0 + i * 10.0
		var h := 6.0 + float(i % 3) * 1.5
		WorldKit.box(_world, Vector3(-48.5, h * 0.5, z), Vector3(7.0, h, 8.6), M_CLAP if i % 2 == 0 else M_BRICK)
		WorldKit.box(_world, Vector3(-44.95, 1.4, z + 1.0), Vector3(0.05, 1.3, 0.8), TexFactory.flat(Color(0.02, 0.02, 0.03)), false)
	for j in 4:
		var z2 := -30.0 + j * 18.0
		if absf(z2 + 0.0) < 9.0:
			continue
		WorldKit.box(_world, Vector3(-21.0, 3.2, z2), Vector3(8.0, 6.4, 9.0), M_CLAP)
	WorldKit.blocker(_world, Vector3(-35.0, 3, -45.0), Vector3(20, 6, 0.5))
	WorldKit.blocker(_world, Vector3(-35.0, 3, 45.0), Vector3(20, 6, 0.5))
	WorldKit.blocker(_world, Vector3(-44.8, 3, 0.0), Vector3(0.5, 6, 90))


func _build_skyline() -> void:
	# Ao norte, além do rio: telhados e as três luzes de culto vistas do telhado (evt_church_lights) [C].
	for i in 12:
		var x := -40.0 + i * 7.5
		WorldKit.box(_world, Vector3(x, 4.0 + float(i % 4) * 1.6, -62.0 - float(i % 3) * 6.0), Vector3(6.0, 8.0 + float(i % 4) * 3.2, 5.0), TexFactory.flat(Color(0.04, 0.045, 0.05)), false)
	for p: Vector3 in [Vector3(-18, 9, -78), Vector3(4, 12, -84), Vector3(24, 8, -74)]:
		var l := WorldKit.box(_world, p, Vector3(2.0, 1.6, 0.3), TexFactory.flat(Color(1.0, 0.68, 0.32), true), false)
		l.visible = false
		l.set_meta("dynamic", true)
		_church_lights.append(l)
	# Campanários decapitados [C].
	for q: Vector3 in [Vector3(-6, 13, -70), Vector3(14, 15, -76)]:
		WorldKit.box(_world, q, Vector3(2.0, 12.0, 2.0), TexFactory.flat(Color(0.05, 0.05, 0.06)), false)


# ================================================================ helpers de interação

func _on_footstep(_surface: String, loud: float) -> void:
	var y := player.global_position.y
	var id := "sfx_step_wood"
	if (y < 0.5 and player.global_position.x < -5.0) or phase == "street":
		id = "sfx_step_stone"
	elif phase == "roof":
		id = "sfx_slate"
	app.play_sound(id, Vector3.INF, linear_to_db(0.12 + loud * 0.3), randf_range(0.9, 1.1))


# ================================================================ ch05: praça, saguão, quarto

func _talk_sargent() -> void:
	app.show_dialog("Joe Sargent", T.SARGENT_LINE, ["Não há mesmo outro jeito de sair?", "…Está bem. Vou ao hotel."], func(i: int) -> void:
		if i == 0:
			app.show_dialog("Joe Sargent", "Nenhum. Nem para Arkham, nem para lugar nenhum. Até amanhã.", ["Ir ao hotel"], func(_j: int) -> void: _after_sargent())
		else:
			_after_sargent())


func _after_sargent() -> void:
	if state.set_fact("breakdown_heard"):
		_note(T.NOTES["breakdown"])
	_think(T.THOUGHTS["crowd_door"])


func _enter_lobby() -> void:
	if not state.has_fact("breakdown_heard"):
		_think("Primeiro, o ônibus. Está quase na hora.")
		return
	await app.ui.fade_to(1.0, 0.5).finished
	_spawn(Vector3(5.2, 0.05, 0.0), PI / 2)
	_set_phase("lobby")
	_set_time("twilight")
	app.ui.fade_to(0.0, 0.6)


func _talk_clerk() -> void:
	app.show_dialog("Funcionário da noite", T.CLERK_LINE, ["Assinar o registro e pagar um dólar"], func(_i: int) -> void:
		state.set_fact("room_given")
		_note(T.NOTES["room"])
		app.show_dialog("", T.DINNER_LINE, ["Subir ao quarto"], func(_j: int) -> void:
			state.set_fact("dinner_done")
			state.set_fact("paper_bought")
			state.add_doc("doc_evening_paper")
			_set_phase("upstairs")))


func _go_upstairs() -> void:
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 0.6).finished
	app.play_sound("sfx_creak_long")
	app.say("Três lances de escada rangente, por corredores empoeirados e sem vida.", 3.5, "thought")
	await get_tree().create_timer(2.0, false).timeout
	_spawn(Vector3(1.1, FLOOR4 + 0.05, 2.0), PI / 2)
	_set_phase("room")
	player.controls_enabled = true
	app.save_checkpoint("cp05_room")
	app.ui.fade_to(0.0, 0.8)


func _wardrobe_prompt() -> String:
	if state.has_fact("bolt_removed"):
		return ""
	if phase != "room":
		return ""
	if state.has_fact("missing_bolt_seen"):
		return "Desaparafusar o ferrolho do armário (ferramenta do chaveiro)"
	return "Examinar o armário"


func _wardrobe_use() -> void:
	if not state.has_fact("missing_bolt_seen"):
		_think("Um armário de roupas barato. Tem um ferrolho pequeno na porta.")
		return
	_timed(2.6, "sfx_key", inter["wardrobe"].global_position, func() -> void:
		state.set_fact("bolt_removed")
		inter["wardrobe"].get_node("bolt").visible = false
		_think(T.THOUGHTS["bolt_removed"]))


func _window_428() -> void:
	if state.has_fact("power_cut_done"):
		if state.set_fact("window_examined"):
			_note(T.NOTES["window"])
			director.notify("prep_min")
		_think(T.THOUGHTS["window_night"], 7.0)
		_after(3.5, func() -> void: _think("À direita, o talho negro do desfiladeiro, a estação abandonada, os trilhos para Rowley. À esquerda, a estrada de Ipswich, branca ao luar.", 7.0))
	else:
		_think(T.THOUGHTS["window_dusk"], 6.0)


func _bed428_prompt() -> String:
	var bed: Pushable = pushables["bed_428"]
	if phase in ["room", "bed"]:
		return "Deitar-se vestido"
	if state.has_fact("power_cut_done") and not bed.at_target and not state.has_fact("north_forced"):
		return "Empurrar a cama contra a porta sul"
	return ""


func _bed428_use() -> void:
	if phase in ["room", "bed"]:
		var missing: Array[String] = []
		if not state.has_fact("hall_bolted"):
			missing.append("a porta do corredor")
		if not state.has_fact("north_bolted"):
			missing.append("a porta de ligação norte")
		if not state.has_fact("south_bolted"):
			missing.append("a porta de ligação sul")
		if missing.size() > 0:
			_think(T.THOUGHTS["need_bolts"] + " Falta trancar: " + ", ".join(missing) + ".")
			return
		_lie_down()
		return
	var bed: Pushable = pushables["bed_428"]
	_timed(2.4, "sfx_scrape", bed.global_position, func() -> void:
		bed.slide(0.1)
		state.set_fact("bed_at_south")
		director.notify("prep_min"))


func _lie_down() -> void:
	## G1: deitar, escutar. Nada pode dar errado aqui (docs/08 §4.2).
	state.set_fact("lay_down")
	_set_phase("listen")
	player.controls_enabled = false
	player.look_enabled = true
	await app.ui.fade_to(1.0, 0.8).finished
	_bulb.visible = false
	_set_time("night")
	_spawn(Vector3(-3.0, FLOOR4 + 0.05, 3.45), PI / 2 + 0.3)
	player.set_physics_process(false)
	player.global_position = Vector3(-3.0, FLOOR4 + 0.1, 3.45)
	player.set_eye_height(0.62)
	app.ui.fade_to(0.0, 1.5)
	var hall := doors["hall_428"] as Door
	var seq: Array = [
		[2.5, func() -> void: _think(T.THOUGHTS["cant_sleep"], 6.0)],
		[5.0, func() -> void:
			app.play_sound("sfx_creak", Vector3(1.0, FLOOR4 + 0.5, 9.0), -6.0)
			_caption("rangidos na escada e no corredor, como de passos — sem vozes")],
		[4.0, func() -> void: app.play_sound("sfx_creak", Vector3(1.0, FLOOR4 + 0.5, 4.0), -4.0, 0.9)],
		[5.0, func() -> void:
			app.play_sound("sfx_key", hall.global_position + Vector3(0.3, 1.0, 0.45))
			hall.shake(0.6)
			_caption("uma chave tenta a fechadura — com cautela, furtivamente", 5.0)
			state.set_fact("key_in_lock_done")],
		[2.0, func() -> void:
			app.play_sound("sfx_key", hall.global_position + Vector3(0.3, 1.0, 0.45))
			hall.shake(0.8)],
		[4.5, func() -> void:
			app.play_sound("sfx_key", Vector3(0.3, FLOOR4 + 1.0, -2.0))
			app.play_sound("sfx_creak", Vector3(-2.0, FLOOR4 + 0.3, -2.0))
			_caption("o quarto ao norte é aberto com uma chave-mestra")],
		[3.0, func() -> void:
			doors["c_428_n1"].shake(1.0)
			app.play_sound("sfx_key", Vector3(-0.8, FLOOR4 + 1.0, -0.1))
			_caption("a porta de ligação norte é testada; o ferrolho segura")],
		[4.0, func() -> void:
			app.play_sound("sfx_key", Vector3(0.3, FLOOR4 + 1.0, 6.0))
			_caption("agora, o quarto ao sul")],
		[3.0, func() -> void:
			doors["c_s1_428"].shake(1.0)
			app.play_sound("sfx_key", Vector3(-0.8, FLOOR4 + 1.0, 4.1))
			_caption("a porta de ligação sul é testada")],
		[4.0, func() -> void:
			app.play_sound("sfx_creak_long", Vector3(1.0, FLOOR4 + 0.3, 9.5), -4.0)
			_caption("passos se afastam pelo corredor e descem a escada", 5.0)
			state.set_fact("connecting_tries_done")
			_note(T.NOTES["tries"])],
	]
	for step: Array in seq:
		await get_tree().create_timer(float(step[0]), false).timeout
		if not is_inside_tree():
			return
		(step[1] as Callable).call()
	await get_tree().create_timer(3.0, false).timeout
	_get_up()


func _get_up() -> void:
	player.set_physics_process(true)
	player.set_eye_height(Player.STAND_H)
	_spawn(Vector3(-2.2, FLOOR4 + 0.05, 2.6), PI)
	player.controls_enabled = true
	_set_phase("prepare")
	_think(T.THOUGHTS["got_up"], 5.0)
	_after(2.0, func() -> void:
		app.play_sound("sfx_switch")
		if player.has_flashlight:
			if not player.is_flashlight_on():
				player.toggle_flashlight()
			_think(T.THOUGHTS["power_cut"])
		else:
			_think(T.THOUGHTS["power_cut_no_light"])
		state.set_fact("power_cut_done")
		_note(T.NOTES["power"])
		_on_director_events(director.start(SiegeDirector.Phase.S0_SILENCE))
		_after(3.0, func() -> void:
			app.play_sound("sfx_croak_low", Vector3(-2.0, FLOOR4 - 1.5, 2.0), -2.0)
			_after(1.2, func() -> void: app.play_sound("sfx_croak", Vector3(0.5, FLOOR4 - 1.5, 0.0), -4.0))
			_think(T.THOUGHTS["croaks"], 6.0)))


# ================================================================ portas

func _door_prompt(id: String) -> String:
	var d: Door = doors[id]
	var room := room_of(player.global_position)
	match id:
		"hall_428":
			if d.state != Door.State.CLOSED:
				return "Fechar a porta" if phase in ["room", "bed"] else ""
			if room != "428":
				return ""
			if phase == "room" or phase == "bed":
				if not state.has_fact("missing_bolt_seen"):
					return "Examinar a porta"
				if not state.has_fact("bolt_fitted"):
					return "Instalar o ferrolho (ferramenta do chaveiro)" if state.has_fact("bolt_removed") else "Abrir a porta"
				return "Abrir o ferrolho" if d.bolted else "Correr o ferrolho"
			return ""
		"c_428_n1":
			if d.state == Door.State.BROKEN or room != "428":
				return ""
			if phase in ["room", "bed"]:
				return "" if d.bolted else "Correr o ferrolho da porta de ligação"
			if phase == "prepare" and not state.has_fact("north_hinge_read"):
				return "Examinar a porta de ligação norte"
			if phase in ["prepare", "ram"]:
				return "Arrombar com o ombro" + (" (segure)" if hold_mode else " (pressione repetidamente)")
			return ""
		"c_s1_428":
			if room != "428":
				return ""
			if phase in ["room", "bed"]:
				return "" if d.bolted else "Correr o ferrolho da porta de ligação"
			if phase in ["prepare", "ram"]:
				return "Examinar a porta de ligação sul" if not state.has_fact("south_hinge_read") else "Forçar a porta sul"
			return ""
		"hall_n1":
			if room == "n1" and not d.bolted and state.has_fact("north_forced"):
				return "Correr o ferrolho da porta do corredor"
			return ""
		"c_n1_n2":
			if d.state == Door.State.AJAR and room in ["n1", "n2"]:
				return "Empurrar a porta entreaberta"
			if d.state == Door.State.OPEN and room == "n2" and state.has_fact("n2_bolted"):
				return "Fechar e trancar a porta de ligação sul"
			return ""
		"c_n2_n3":
			if d.state == Door.State.OPEN and room == "n2" and state.has_fact("n2_bolted"):
				return "Fechar e trancar a porta de ligação norte"
			return ""
		"hall_n2":
			if room == "n2" and not d.bolted and state.has_fact("n1_bolted"):
				return "Empurrar a porta e correr o ferrolho" if d.state != Door.State.CLOSED else "Correr o ferrolho da porta do corredor"
			return ""
	return ""


func _door_use(id: String) -> void:
	var d: Door = doors[id]
	match id:
		"hall_428":
			if d.state != Door.State.CLOSED:
				d.set_state(Door.State.CLOSED)
				app.play_sound("sfx_creak", d.global_position, -6.0, 1.3)
				if state.set_fact("missing_bolt_seen"):
					_after(0.6, func() -> void:
						_think(T.THOUGHTS["missing_bolt"])
						_note(T.NOTES["bolt"]))
				return
			if not state.has_fact("missing_bolt_seen"):
				state.set_fact("missing_bolt_seen")
				_think(T.THOUGHTS["missing_bolt"])
				_note(T.NOTES["bolt"])
				_after(2.5, func() -> void: _think(T.THOUGHTS["wardrobe"]))
			elif not state.has_fact("bolt_fitted"):
				if state.has_fact("bolt_removed"):
					_timed(3.0, "sfx_key", d.global_position, func() -> void:
						state.set_fact("bolt_fitted")
						_set_phase("bed")
						_think(T.THOUGHTS["bolt_fitted"]))
				else:
					d.set_state(Door.State.OPEN)
					app.play_sound("sfx_creak", d.global_position, -6.0, 1.3)
			else:
				d.bolted = not d.bolted
				app.play_sound("sfx_bolt", d.global_position)
				if d.bolted:
					state.set_fact("hall_bolted")
		"c_428_n1":
			if phase in ["room", "bed"]:
				d.bolted = true
				state.set_fact("north_bolted")
				app.play_sound("sfx_bolt", d.global_position)
			elif not state.has_fact("north_hinge_read"):
				state.set_fact("north_hinge_read")
				director.notify("prep_min")
				_think(T.THOUGHTS["north_door"], 6.0)
				_note(T.NOTES["hinges"])
			elif director.phase == SiegeDirector.Phase.S0_SILENCE or director.phase == SiegeDirector.Phase.IDLE:
				_think(T.THOUGHTS["ram_early"])
			elif not hold_mode:
				_ram_hit()
		"c_s1_428":
			if phase in ["room", "bed"]:
				d.bolted = true
				state.set_fact("south_bolted")
				app.play_sound("sfx_bolt", d.global_position)
			elif not state.has_fact("south_hinge_read"):
				state.set_fact("south_hinge_read")
				director.notify("prep_min")
				_think(T.THOUGHTS["south_door"], 6.0)
				_note(T.NOTES["hinges"])
			else:
				d.shake(1.5)
				app.play_sound("sfx_thud", d.global_position, -4.0)
				_think("Bate contra o batente. Abre na minha direção — não adianta.")
		"hall_n1":
			d.bolted = true
			app.play_sound("sfx_bolt", d.global_position)
			state.set_fact("n1_bolted")
			_on_director_events(director.notify("n1_bolted"))
			_set_phase("n2")
			if state.has_fact("n2_bolted"):
				_on_director_events(director.notify("n2_bolted"))
		"c_n1_n2":
			if d.state == Door.State.AJAR:
				d.set_state(Door.State.OPEN)
				app.play_sound("sfx_creak", d.global_position, -2.0, 1.2)
			else:
				d.set_state(Door.State.CLOSED)
				d.bolted = true
				app.play_sound("sfx_bolt", d.global_position)
				state.set_fact("n2_south_bolted")
		"c_n2_n3":
			d.set_state(Door.State.CLOSED)
			d.bolted = true
			app.play_sound("sfx_bolt", d.global_position)
			state.set_fact("n2_north_bolted")
			_on_director_events(director.notify("n2_north_bolted"))
		"hall_n2":
			d.set_state(Door.State.CLOSED)
			d.bolted = true
			app.play_sound("sfx_thud", d.global_position, -2.0)
			app.play_sound("sfx_bolt", d.global_position)
			state.set_fact("n2_bolted")
			if director.phase == SiegeDirector.Phase.S5_N2:
				_on_director_events(director.notify("n2_bolted"))
				_set_phase("barricade")


func _ram_hit() -> void:
	if _ram_cool > 0.0 or state.has_fact("north_forced"):
		return
	_ram_cool = 0.32
	var d: Door = doors["c_428_n1"]
	if _ram_hits == 0:
		d.bolted = false
		app.play_sound("sfx_bolt", d.global_position, -6.0)
	_ram_hits += 1
	d.shake(3.0)
	player.add_shake(0.8)
	app.play_sound("sfx_blow", d.global_position, 0.0, randf_range(0.95, 1.1))
	_on_director_events(director.notify("north_hit"))
	if _ram_hits >= 5:
		state.set_fact("north_forced")
		d.set_state(Door.State.BROKEN)
		app.play_sound("sfx_crash", d.global_position, 2.0)
		_caption("a porta cede com um estrondo — certamente ouviram", 4.0)
		_set_phase("n1")
		_on_director_events(director.notify("north_forced"))


# ================================================================ diretor do cerco

func _on_director_events(evs: Array[String]) -> void:
	for ev: String in evs:
		match ev:
			"knock_first":
				_set_phase("ram")
				app.save_checkpoint("cp06_knock")
				app.play_sound("sfx_creak_long", Vector3(1.0, FLOOR4 + 0.2, 6.0), 0.0, 0.8)
				_corridor_light.light_energy = 0.7
				_caption("a escada range sob um peso maior; uma luz trêmula pela bandeira da porta", 5.0)
				_after(2.0, func() -> void:
					for k in 3:
						_after(k * 0.45, func() -> void: app.play_sound("sfx_knock", doors["hall_428"].global_position + Vector3(0.2, 1.2, 0.45)))
					doors["hall_428"].shake(1.0)
					_caption("uma batida firme à porta", 4.0))
				_knock_mode = "single"
			"knock_continuous":
				_knock_mode = "continuous"
				_caption("as batidas se repetem — contínuas, cada vez mais insistentes", 4.0)
			"hall_blows":
				_knock_mode = "blows"
				_caption("golpes violentos contra a porta do corredor", 4.0)
			"hall_door_splinter":
				doors["hall_428"].splinter(1)
				_caption("a madeira da porta do corredor começa a ceder", 4.0)
			"battering":
				_knock_mode = "battering"
			"passkeys_neighbors":
				app.play_sound("sfx_key", Vector3(0.3, FLOOR4 + 1.0, -2.0), 2.0)
				app.play_sound("sfx_key", Vector3(0.3, FLOOR4 + 1.0, 6.0), 0.0)
				_caption("chaves nas portas dos quartos vizinhos!", 4.0)
			"passkey_n2":
				var d: Door = doors["hall_n2"]
				app.play_sound("sfx_key", d.global_position + Vector3(0.3, 1.0, 0.45), 2.0)
				if not d.bolted:
					d.push_partly(22.0)
					d.state = Door.State.AJAR
				_caption("uma chave-mestra na porta do terceiro quarto — a porta começa a abrir", 4.0)
				_think(T.THOUGHTS["despair"], 3.0)
			"battering_abates":
				_knock_mode = "abated"
				_caption("os golpes cedem — estrondo confuso contra a porta protegida pela cama", 4.0)
				_think(T.THOUGHTS["no_voices"], 5.0)
				_note(T.NOTES["pursuers"])
			"lateral_attack":
				_lateral = true
			"passkey_n3":
				app.play_sound("sfx_key", Vector3(0.3, FLOOR4 + 1.0, -10.0), 2.0)
				_after(0.6, func() -> void:
					for k in 6:
						_after(k * 0.18, func() -> void: app.play_sound("sfx_step_wood", Vector3(1.0, FLOOR4 + 0.2, -6.0 - k), 2.0)))
				_caption("uma chave na porta seguinte ao norte — e uma correria pelo corredor", 4.0)
			"scurry_north":
				app.play_sound("sfx_breath", Vector3(-2.0, FLOOR4 + 1.2, -10.0), 0.0)
				app.play_sound("sfx_croak", Vector3(-2.0, FLOOR4 + 1.2, -10.5), -2.0)
			"ram_start":
				_set_phase("window")
				app.save_checkpoint("cp06_window")
				_caption("algo pesado — um aríete — contra a porta de ligação norte!", 4.0)
			"ram_hit":
				var r: Door = doors["c_n2_n3"]
				r.shake(4.0)
				app.play_sound("sfx_blow", r.global_position + Vector3(0.45, 1.0, -0.2), 3.0, 0.85)
				if room_of(player.global_position) == "n2":
					player.add_shake(0.35)
			"panel_crack_1":
				doors["c_n2_n3"].splinter(1)
				_caption("o painel fraco começa a rachar", 3.0)
			"panel_crack_2":
				doors["c_n2_n3"].splinter(2)
				_caption("o painel estala — não vai aguentar muito", 3.0)
			_:
				if ev.begins_with("fail:"):
					_fail(ev.substr(5))


func _fail(code: String) -> void:
	if _failed:
		return
	_failed = true
	player.controls_enabled = false
	app.play_sound("sfx_crash", player.global_position + Vector3(0.5, 1.0, 0.5), 4.0)
	app.play_sound("sfx_croak_low", player.global_position + Vector3(1.0, 1.4, 0.0), 4.0)
	_corridor_light.light_energy = 2.5
	var lan := WorldKit.omni(_world, player.global_position + Vector3(0.8, 1.6, 0.8), Color(1.0, 0.6, 0.3), 3.0, 6.0)
	lan.visible = true
	failed.emit(T.FAIL.get(code, "Eles o alcançaram."))


# ================================================================ ch06: janela, telhado, pátio

func _window_n2s_prompt() -> String:
	if room_of(player.global_position) != "n2":
		return ""
	if not state.has_fact("drapery_down"):
		if state.has_fact("n2_bolted"):
			return "Arrancar as cortinas, com varão e tudo"
		return "Olhar pela janela"
	return "Prender as argolas no gancho da veneziana e descer"


func _window_n2s_use() -> void:
	if not state.has_fact("drapery_down"):
		if not state.has_fact("n2_bolted"):
			_think("O telhado inclinado do bloco da Paine Street, logo abaixo. Cortinas pesadas de veludo, com argolas de latão.")
			return
		_timed(1.0, "sfx_cloth", _curtain.global_position, func() -> void:
			state.set_fact("drapery_down")
			_curtain.position.y = FLOOR4 + 0.25
			_curtain.scale = Vector3(1, 0.25, 1)
			_think("As dobras pesadas devem alcançar o telhado. As argolas e o gancho hão de aguentar."))
		return
	_descend()


func _descend() -> void:
	state.set_fact("rope_ready")
	_on_director_events(director.notify("descent_started"))
	busy = true
	player.controls_enabled = false
	player.set_physics_process(false)
	_curtain.visible = false
	_drape_out.visible = true
	app.play_sound("sfx_cloth")
	var tw := create_tween()
	tw.tween_property(player, "global_position", Vector3(-4.6, FLOOR4 + 0.6, -4.9), 0.7)
	tw.tween_property(player, "global_position", Vector3(-5.6, 7.6, -4.95), 1.6)
	tw.tween_property(player, "global_position", Vector3(-6.0, 7.2, -5.6), 0.8)
	await tw.finished
	if not is_inside_tree():
		return
	player.set_physics_process(true)
	player.controls_enabled = true
	busy = false
	_knock_mode = ""
	_lateral = false
	_set_phase("roof")
	app.save_checkpoint("cp06_roof")
	for l in _church_lights:
		l.visible = true
	state.set_fact("roof_reached")
	if state.set_fact("church_lights_seen"):
		_note(T.NOTES["lights"])
	_think(T.THOUGHTS["roof"], 7.0)


func _skylight() -> void:
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 0.35).finished
	_spawn(Vector3(-9.5, 4.95, -6.3), PI / 2)
	app.play_sound("sfx_thud", Vector3.INF, 0.0)
	player.add_shake(1.2)
	_set_phase("attic")
	state.set_fact("attic_reached")
	player.controls_enabled = true
	app.ui.fade_to(0.0, 0.4)
	_think(T.THOUGHTS["attic"], 6.0)


func _back_door() -> void:
	var d: Door = doors["warehouse_back"]
	app.save_checkpoint("cp06_courtyard")
	d.set_state(Door.State.OPEN)
	app.play_sound("sfx_creak", d.global_position)
	_set_phase("courtyard")
	state.set_fact("courtyard_reached")
	_after(2.5, func() -> void: _think(T.THOUGHTS["courtyard"], 6.0))


func _start_crowd() -> void:
	if _crowd_active:
		return
	_crowd_active = true
	state.set_fact("crowd_seen")
	_note(T.NOTES["crowd"])
	doors["gilman_rear"].set_state(Door.State.OPEN)
	app.play_sound("sfx_creak", Vector3(-5.2, 1.0, 0.0), 4.0)
	_see("uma multidão sai do Gilman, com lanternas", 3.0)
	_caption("gritos roucos que não são inglês", 5.0)
	_think(T.THOUGHTS["crowd"], 6.0)
	var rng := RandomNumberGenerator.new()
	rng.seed = 46
	for i in 10:
		var robed := i == 3
		var f := WorldKit.figure(_world, Vector3(-5.4, 0, 0.0), 1.55 + rng.randf() * 0.35, robed, robed)
		var light: OmniLight3D = null
		if i % 3 == 0:
			light = WorldKit.omni(f, Vector3(0.3, 1.1, -0.2), Color(1.0, 0.62, 0.3), 1.4, 6.0)
			WorldKit.box(f, Vector3(0.3, 1.0, -0.2), Vector3(0.14, 0.2, 0.14), TexFactory.flat(Color(1, 0.7, 0.3), true), false)
		var goal := Vector3(rng.randf_range(-15.5, -6.5), 0, rng.randf_range(-3.2, 3.2))
		_crowd.append({"node": f, "goal": goal, "delay": i * 0.45, "light": light, "phase": rng.randf() * TAU, "hop": robed})


func _update_crowd(delta: float) -> void:
	_crowd_t += delta
	for c: Dictionary in _crowd:
		var n: Node3D = c["node"]
		if _crowd_t < float(c["delay"]):
			continue
		var goal: Vector3 = c["goal"]
		var to := goal - n.position
		to.y = 0
		var spd := 1.4 if not c["hop"] else 1.0
		if to.length() > 0.2:
			n.position += to.normalized() * minf(spd * delta, to.length())
			n.look_at(n.global_position + Vector3(to.x, 0, to.z), Vector3.UP)
		else:
			c["goal"] = Vector3(randf_range(-15.5, -6.5), 0, randf_range(-3.2, 3.2))
		c["phase"] = float(c["phase"]) + delta * (9.0 if c["hop"] else 5.0)
		# Andar arrastado ou quase saltitante [C].
		n.position.y = absf(sin(float(c["phase"]))) * (0.22 if c["hop"] else 0.05)
		if c["light"]:
			(c["light"] as OmniLight3D).light_energy = 1.2 + 0.3 * sin(_crowd_t * 13.0 + float(c["phase"]))
	if int(_crowd_t * 10.0) % 37 == 0:
		app.play_sound("sfx_croak" if randf() < 0.6 else "sfx_croak_low", Vector3(randf_range(-14, -7), 1.4, randf_range(-3, 3)), -2.0, randf_range(0.85, 1.15))


func _shutter_use() -> void:
	if phase in ["courtyard", "hall"]:
		player.controls_enabled = false
		app.play_sound("sfx_creak", _shutter.global_position, 0.0, 1.4)
		_think(T.THOUGHTS["shutters"], 3.0)
		await app.ui.fade_to(1.0, 0.5).finished
		_shutter.rotation.y = 1.2
		_spawn(Vector3(-26.0, 0.05, -4.5), PI / 2)
		_set_phase("street")
		state.set_fact("washington_reached")
		player.controls_enabled = true
		app.ui.fade_to(0.0, 0.6)
		_street_t = 0.0
		_think(T.THOUGHTS["outside"], 7.0)
		_after(2.0, func() -> void:
			for k in 5:
				_after(k * 0.3, func() -> void: app.play_sound("sfx_step_stone", Vector3(-35.0, 0.2, 30.0), -4.0)))
	elif phase == "street":
		_shutter.rotation.y = 0.0
		app.play_sound("sfx_creak", _shutter.global_position, -4.0, 1.4)
		state.set_fact("shutter_closed")
		_think(T.THOUGHTS["closed_shutter"], 3.0)


# ================================================================ laço principal

func _physics_process(delta: float) -> void:
	if player == null or _failed:
		return
	if capture_mode:
		return
	_ram_cool = maxf(0.0, _ram_cool - delta)
	_slip_cool = maxf(0.0, _slip_cool - delta)
	if director.is_active():
		_on_director_events(director.advance(delta))
	_update_knocks(delta)
	_update_hold_ram(delta)
	_update_loiterers()
	_update_phase_triggers(delta)
	if _crowd_active:
		_update_crowd(delta)
		_update_detection(delta)


func _update_knocks(delta: float) -> void:
	_knock_t -= delta
	var at: Vector3 = doors["hall_428"].global_position + Vector3(0.25, 1.1, 0.45)
	if _knock_t <= 0.0:
		match _knock_mode:
			"continuous":
				_knock_t = 0.65
				app.play_sound("sfx_knock", at, 2.0, randf_range(0.95, 1.05))
				doors["hall_428"].shake(0.8)
			"blows":
				_knock_t = 1.05
				app.play_sound("sfx_blow", at, 3.0, randf_range(0.9, 1.0))
				doors["hall_428"].shake(2.0)
				if randf() < 0.3:
					app.play_sound("sfx_breath", at + Vector3(0.6, 0, 0), -4.0)
			"battering":
				_knock_t = 0.6
				app.play_sound("sfx_blow", at, 4.0, randf_range(0.85, 1.0))
				doors["hall_428"].shake(2.5)
				if randf() < 0.25:
					app.play_sound("sfx_croak", at + Vector3(0.8, 0, 0), -2.0)
			"abated":
				_knock_t = 2.6
				app.play_sound("sfx_blow", at, -2.0, 0.9)
			_:
				_knock_t = 0.5
	if _lateral:
		_lateral_t -= delta
		if _lateral_t <= 0.0:
			_lateral_t = 1.5
			var s: Door = doors["c_s1_428"]
			app.play_sound("sfx_blow", s.global_position + Vector3(0.45, 1.0, 0.2), 0.0, 1.1)
			s.shake(1.5)


func _update_hold_ram(delta: float) -> void:
	if not hold_mode or phase not in ["prepare", "ram"]:
		_hold_acc = 0.0
		return
	if not state.has_fact("north_hinge_read") or director.phase == SiegeDirector.Phase.S0_SILENCE:
		return
	if player.focused == doors["c_428_n1"] and Input.is_action_pressed("interact"):
		_hold_acc += delta
		if _hold_acc >= 0.5:
			_hold_acc = 0.0
			_ram_hit()
	else:
		_hold_acc = 0.0


func _update_loiterers() -> void:
	if phase != "square":
		return
	for f in _loiterers:
		var to := player.global_position - f.global_position
		to.y = 0
		if to.length() > 0.5:
			f.look_at(f.global_position + to, Vector3.UP)


func _update_phase_triggers(delta: float) -> void:
	var p := player.global_position
	match phase:
		"roof":
			if p.y < 4.2:
				_fail("FALL")
			elif player.running and _slip_cool <= 0.0:
				_slip_cool = 4.0
				player.add_shake(1.5)
				player.velocity *= 0.2
				app.play_sound("sfx_slate", Vector3.INF, 2.0)
				_think(T.THOUGHTS["slip"], 3.0)
		"hall":
			if _wedged_t >= 0.0:
				_wedged_t += delta
				if not _crowd_active and (p.x > -21.0 or _wedged_t > 4.0):
					_start_crowd()
		"street":
			if _street_t >= 0.0:
				_street_t += delta
				var far := p.distance_to(Vector3(-25.0, 0.0, -4.5)) > 7.0
				if (far or (state.has_fact("shutter_closed") and _street_t > 4.0)) and _street_t > 2.0:
					_street_t = -1.0
					_finish()
	if phase in ["room", "bed"] and room_of(p) == "corridor" and doors["hall_428"].state == Door.State.CLOSED and state.has_fact("bolt_fitted"):
		pass


func _update_detection(delta: float) -> void:
	var p := player.global_position
	var in_court := p.x > -16.9 and p.x < -5.2 and p.z > -3.9 and p.z < 3.9 and p.y < 1.5
	var lit_door := player.is_flashlight_on() and p.x > -19.5 and p.x < -16.8 and p.z > -2.9 and p.z < -1.1
	if in_court or lit_door:
		_detect_t += delta
		if _detect_t > (0.6 if in_court else 1.2):
			_fail("F6")
	else:
		_detect_t = maxf(0.0, _detect_t - delta)


func _finish() -> void:
	app.save_checkpoint("cp07_washington")
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 2.0).finished
	finished.emit()
