class_name NewburyportChapter
extends ChapterBase
## ch00_frame e ch01_journey (docs/04 §2–3): a escrivaninha em Toledo; Newburyport, a tiara e o
## embarque no ônibus de Joe Sargent. Sem perigo nem falha.

const D = preload("res://data/day_text.gd")

const FRAME := Vector3(0, 0, 0)
const STATION := Vector3(100, 0, 0)
const TOWN := Vector3(200, 0, 0)
const LIBRARY := Vector3(300, 0, 0)
const STREET := Vector3(400, 0, 0)
const SOCIETY := Vector3(500, 0, 0)
const MORNING := Vector3(600, 0, 0)

var _tiara: Node3D
var _inspect := false
var _loiterers: Array[Node3D] = []
var _bus: Node3D
var _passengers: Array[Node3D] = []
var _sargent: Node3D
var _bus_ready := false
var _amb_rain: AudioStreamPlayer
var _amb_room: AudioStreamPlayer
var _amb_wind: AudioStreamPlayer
var _amb_drone: AudioStreamPlayer


func _objectives() -> Dictionary:
	return D.OBJECTIVES


func _hints() -> Dictionary:
	return D.HINTS


func _docs() -> Dictionary:
	return D.DOCS


func begin(s: StoryState) -> void:
	state = s
	_init_world()
	_build_frame()
	_build_station()
	_build_town()
	_build_library()
	_build_street()
	_build_society()
	_build_morning()
	_amb_rain = _loop("amb_wind", -60.0)
	_amb_room = _loop("amb_room", -60.0)
	_amb_wind = _loop("amb_wind", -60.0)
	_amb_drone = _loop("amb_drone", -60.0)
	_make_player()
	match state.checkpoint:
		"cp00_frame":
			_enter("frame")
		"cp01_station":
			_enter("station")
		"cp01_library":
			state.set_fact("agent_bus")
			_note(D.NOTES["agent"])
			_enter("library")
		"cp01_society":
			for f: String in ["agent_bus", "essex_read", "jewellery_read", "intro_note"]:
				state.set_fact(f)
			_note(D.NOTES["agent"])
			_note(D.NOTES["library"])
			_enter("society")
		"cp01_bus_stop":
			for f2: String in ["agent_bus", "essex_read", "jewellery_read", "intro_note", "tiara_seen", "tilton_done", "ymca_done"]:
				state.set_fact(f2)
			for k: String in ["agent", "library", "tiara", "tilton"]:
				_note(D.NOTES[k])
			_enter("morning")


func _enter(p: String) -> void:
	_set_phase(p)
	match p:
		"frame":
			_env_lamp(Color(1.0, 0.8, 0.5))
			_spawn(FRAME + Vector3(-0.6, 0.05, 0.9), PI * 0.85)
			_card("frame")
			_after(3.0, func() -> void: _think(D.THOUGHTS["frame"], 4.0))
		"station":
			_env_dusk()
			_spawn(STATION + Vector3(0, 0.05, 2.2), 0.0)
			_card("station")
		"town_eve":
			_env_dusk()
			_spawn(TOWN + Vector3(0, 0.05, 6.0), 0.0)
		"library":
			_env_lamp(Color(1.0, 0.85, 0.6))
			_spawn(LIBRARY + Vector3(0, 0.05, 2.5), 0.0)
			_card("library")
		"street":
			_env_night()
			_spawn(STREET + Vector3(0, 0.05, 10.0), 0.0)
		"society":
			_env_lamp(Color(0.6, 0.6, 0.7))
			_spawn(SOCIETY + Vector3(0, 0.05, 3.0), 0.0)
			_card("society")
		"morning":
			_env_morning()
			_spawn(MORNING + Vector3(-2.0, 0.05, 2.5), PI / 2 + 0.3)
			_card("morning")
			if not capture_mode:
				_after(4.0, func() -> void: _bus_arrives())
	_update_ambience()


func _card(id: String) -> void:
	if not capture_mode:
		app.ui.chapter_card(D.CARDS[id], 3.5)


func _go(next: String, cp: String = "") -> void:
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 0.8).finished
	if not is_inside_tree():
		return
	if cp != "":
		app.save_checkpoint(cp)
	_enter(next)
	player.controls_enabled = true
	app.ui.fade_to(0.0, 1.0)


func _update_ambience() -> void:
	if _amb_room == null:
		return
	_fade_db(_amb_rain, -16.0 if phase == "frame" else -60.0)
	_fade_db(_amb_room, -16.0 if phase in ["frame", "station", "library", "society"] else -60.0)
	_fade_db(_amb_wind, -14.0 if phase in ["town_eve", "street", "morning"] else -60.0)
	_fade_db(_amb_drone, -14.0 if _inspect else -60.0)


# ================================================================ ambientes

func _env_lamp(c: Color) -> void:
	_env.background_mode = Environment.BG_COLOR
	_env.background_color = Color(0.02, 0.02, 0.02)
	_env.ambient_light_color = c * 0.4
	_env.ambient_light_energy = 1.0
	_env.fog_density = 0.0
	_sun.light_energy = 0.0


func _env_dusk() -> void:
	_env.background_mode = Environment.BG_SKY
	_sky.sky_top_color = Color(0.24, 0.22, 0.34)
	_sky.sky_horizon_color = Color(0.85, 0.55, 0.35)
	_sky.ground_horizon_color = Color(0.3, 0.22, 0.18)
	_sky.ground_bottom_color = Color(0.05, 0.04, 0.04)
	_env.ambient_light_color = Color(0.48, 0.42, 0.40)
	_env.ambient_light_energy = 1.0
	_env.fog_light_color = Color(0.6, 0.45, 0.38)
	_env.fog_density = 0.01
	_sun.light_color = Color(1.0, 0.65, 0.4)
	_sun.light_energy = 0.8
	_aim_light(_sun, Vector3(1.0, -0.25, 0.4))


func _env_night() -> void:
	_set_night(0.02)


func _env_morning() -> void:
	_env.background_mode = Environment.BG_SKY
	_sky.sky_top_color = Color(0.35, 0.5, 0.75)
	_sky.sky_horizon_color = Color(0.72, 0.78, 0.82)
	_sky.ground_horizon_color = Color(0.45, 0.45, 0.42)
	_sky.ground_bottom_color = Color(0.2, 0.2, 0.18)
	_env.ambient_light_color = Color(0.6, 0.62, 0.65)
	_env.ambient_light_energy = 1.0
	_env.fog_light_color = Color(0.72, 0.76, 0.8)
	_env.fog_density = 0.006
	_sun.light_color = Color(1.0, 0.95, 0.85)
	_sun.light_energy = 1.0
	_aim_light(_sun, Vector3(-0.4, -0.7, -0.5))


# ================================================================ cenários

func _room(c: Vector3, size: Vector3, wall: Material, floor_mat: Material) -> void:
	var hx := size.x * 0.5
	var hz := size.z * 0.5
	WorldKit.box(_world, c + Vector3(0, -0.1, 0), Vector3(size.x, 0.2, size.z), floor_mat)
	WorldKit.box(_world, c + Vector3(0, size.y + 0.1, 0), Vector3(size.x, 0.2, size.z), M_CEIL, false)
	WorldKit.wall_x(_world, c.z - hz, c.x - hx, c.x + hx, 0.0, size.y, wall)
	WorldKit.wall_x(_world, c.z + hz, c.x - hx, c.x + hx, 0.0, size.y, wall)
	WorldKit.wall_z(_world, c.x - hx, c.z - hz, c.z + hz, 0.0, size.y, wall)
	WorldKit.wall_z(_world, c.x + hx, c.z - hz, c.z + hz, 0.0, size.y, wall)


func _lamp(pos: Vector3, color: Color, energy: float = 1.0, radius: float = 7.0) -> void:
	var l := WorldKit.omni(_world, pos, color, energy, radius, true)
	WorldKit.box(l, Vector3.ZERO, Vector3(0.18, 0.12, 0.18), TexFactory.flat(color, true), false)


func _exit(id: String, pos: Vector3, label: String, need: Callable, cb: Callable) -> void:
	WorldKit.box(_world, pos, Vector3(1.0, 2.2, 0.08), M_WOOD, false)
	_inter(id, pos, Vector3(1.0, 2.2, 0.4),
		func() -> String: return label if need.call() else "",
		func(_i: Interactable) -> void: cb.call())


func _build_frame() -> void:
	## ch00: escrivaninha, chuva na vidraça, espelho coberto, gaveta fechada [O de C].
	var o := FRAME
	_room(o, Vector3(5, 2.8, 5), M_WALL, M_FLOOR)
	WorldKit.box(_world, o + Vector3(-1.6, 0.25, -0.6), Vector3(1.0, 0.5, 2.0), M_WOOD)
	WorldKit.box(_world, o + Vector3(-1.0, 0.38, 2.0), Vector3(1.2, 0.76, 0.6), M_WOOD)
	WorldKit.box(_world, o + Vector3(-1.0, 0.79, 2.0), Vector3(0.4, 0.02, 0.3), TexFactory.flat(Color(0.86, 0.84, 0.76)), false)
	_lamp(o + Vector3(-1.4, 1.0, 2.1), Color(1.0, 0.8, 0.5), 1.2, 6.0)
	WorldKit.box(_world, o + Vector3(1.4, 1.5, 2.45), Vector3(1.0, 1.2, 0.05), TexFactory.flat(Color(0.12, 0.14, 0.2)), false)
	WorldKit.box(_world, o + Vector3(0, 1.5, -2.42), Vector3(1.2, 1.6, 0.04), TexFactory.flat(Color(0.75, 0.72, 0.66)), false)
	_inter("mirror_cloth", o + Vector3(0, 1.5, -2.3), Vector3(1.2, 1.6, 0.3),
		func() -> String: return "Espelho coberto" if phase == "frame" else "",
		func(_i: Interactable) -> void: _think("Prefiro deixá-lo coberto.", 3.0))
	_inter("drawer_frame", o + Vector3(-1.0, 0.5, 2.3), Vector3(1.0, 0.3, 0.2),
		func() -> String: return "Gaveta" if phase == "frame" else "",
		func(_i: Interactable) -> void: _think("Fechada. Não agora.", 3.0))
	_inter("manuscript0", o + Vector3(-1.0, 0.9, 2.0), Vector3(0.5, 0.3, 0.4),
		func() -> String:
			if phase != "frame":
				return ""
			return "Começar a contar" if state.has_fact("frame_written") else "Escrever a primeira página",
		func(_i: Interactable) -> void:
			if not state.has_fact("frame_written"):
				state.set_fact("frame_written")
				_note(D.NOTES["frame"])
				_open_doc("doc_manuscript")
			else:
				_go("station", "cp01_station"))


func _build_station() -> void:
	var o := STATION
	_room(o, Vector3(7, 3.2, 6), M_PLASTER, M_FLOOR)
	WorldKit.box(_world, o + Vector3(0, 0.6, -1.6), Vector3(3.0, 1.2, 0.6), M_WOOD)
	WorldKit.box(_world, o + Vector3(0, 1.9, -1.9), Vector3(3.0, 1.4, 0.05), TexFactory.flat(Color(0.3, 0.32, 0.3)), false)
	var agent := WorldKit.figure(_world, o + Vector3(0, 0, -2.3), 1.72, false, false, "clerk")
	agent.rotation.y = PI
	WorldKit.box(_world, o + Vector3(-2.6, 0.25, 1.5), Vector3(0.5, 0.5, 2.4), M_WOOD)
	_lamp(o + Vector3(0, 2.8, 0), Color(1.0, 0.82, 0.55), 1.0)
	_inter("agent", o + Vector3(0, 1.3, -1.6), Vector3(3.0, 1.2, 0.8),
		func() -> String: return "Falar com o bilheteiro" if phase == "station" else "",
		func(_i: Interactable) -> void: _agent())
	_exit("station_door", o + Vector3(0, 1.1, 2.95), "Sair para a praça",
		func() -> bool: return phase == "station" and state.has_fact("agent_bus"),
		func() -> void: _go("town_eve"))


func _agent() -> void:
	var labels: Array = []
	var ids: Array = []
	for id: String in D.AGENT_TOPICS.keys():
		labels.append(D.AGENT_TOPICS[id][0])
		ids.append(id)
	labels.append("Isso é tudo, obrigado.")
	app.show_dialog("Bilheteiro", D.AGENT_INTRO, labels, func(i: int) -> void:
		if i >= ids.size():
			if not state.has_fact("agent_bus"):
				_think(D.THOUGHTS["cheaper"], 3.0)
			return
		var id: String = ids[i]
		app.show_dialog("Bilheteiro", D.AGENT_TOPICS[id][1], ["Continuar"], func(_j: int) -> void:
			if state.set_fact("agent_" + id) and id == "bus":
				state.add_doc("doc_bus_timetable")
				_note(D.NOTES["agent"])
			_agent()))


func _build_town() -> void:
	## Market Square ao entardecer [C]: ninguém quer falar de Innsmouth.
	var o := TOWN
	WorldKit.box(_world, o + Vector3(0, -0.1, 0), Vector3(40, 0.2, 40), M_COBBLE)
	var names := ["Hammond's Drug Store", "Ideal Lunch", "Garagem", "Quartel dos bombeiros", "Biblioteca Pública"]
	for k in 5:
		var x := -16.0 + k * 8.0
		WorldKit.box(_world, o + Vector3(x, 4, -10), Vector3(7.5, 8, 6), M_BRICK)
		WorldKit.box(_world, o + Vector3(x, 1.5, -6.95), Vector3(4, 2.4, 0.05), TexFactory.flat(Color(0.35, 0.28, 0.16), true), false)
	WorldKit.blocker(_world, o + Vector3(0, 2, 12), Vector3(40, 4, 1))
	WorldKit.blocker(_world, o + Vector3(-20, 2, 0), Vector3(1, 4, 40))
	WorldKit.blocker(_world, o + Vector3(20, 2, 0), Vector3(1, 4, 40))
	WorldKit.blocker(_world, o + Vector3(0, 2, -7.2), Vector3(40, 4, 0.4))
	var refusals := ["\"Innsmouth? Não sei de nada, não.\"", "\"Vá a Innsmouth se quiser. Eu não vou.\"", "\"Melhor perguntar a outro.\""]
	for k2 in 3:
		var f := WorldKit.figure(_world, o + Vector3(-8 + k2 * 7, 0, -4.5), 1.7)
		var line: String = refusals[k2]
		_inter("local_%d" % k2, o + Vector3(-8 + k2 * 7, 1.0, -4.5), Vector3(0.8, 2.0, 0.8),
			func() -> String: return "Perguntar sobre Innsmouth" if phase == "town_eve" else "",
			func(_i: Interactable) -> void:
				app.say(line, 3.5)
				if state.set_fact("no_talk"):
					_after(3.0, func() -> void: _think(D.THOUGHTS["no_talk"], 5.0)))
		f.rotation.y = PI
	_exit("library_door", o + Vector3(16, 1.1, -6.9), "Entrar na biblioteca",
		func() -> bool: return phase == "town_eve",
		func() -> void: _go("library", "cp01_library"))


func _build_library() -> void:
	var o := LIBRARY
	_room(o, Vector3(9, 3.6, 7), M_WALL, M_FLOOR)
	for k in 4:
		WorldKit.box(_world, o + Vector3(-3.4 + k * 2.3, 1.4, -3.1), Vector3(2.0, 2.8, 0.5), M_WOOD)
	WorldKit.box(_world, o + Vector3(0, 0.4, -0.4), Vector3(2.4, 0.8, 1.2), M_WOOD)
	WorldKit.box(_world, o + Vector3(-0.4, 0.84, -0.4), Vector3(0.4, 0.08, 0.3), TexFactory.flat(Color(0.35, 0.22, 0.15)), false)
	WorldKit.box(_world, o + Vector3(0.5, 0.82, -0.3), Vector3(0.3, 0.04, 0.22), TexFactory.flat(Color(0.5, 0.42, 0.3)), false)
	var lib := WorldKit.figure(_world, o + Vector3(3.0, 0, -1.0), 1.65, false, false, "woman")
	lib.rotation.y = PI * 0.8
	_lamp(o + Vector3(0, 3.1, 0), Color(1.0, 0.85, 0.6), 1.1, 9.0)
	_inter("essex_book", o + Vector3(-0.4, 0.95, -0.4), Vector3(0.5, 0.3, 0.4),
		func() -> String: return "Ler as histórias do condado de Essex" if phase == "library" else "",
		func(_i: Interactable) -> void:
			state.set_fact("essex_read")
			_open_doc("doc_essex_history"))
	_inter("jewellery_ref", o + Vector3(0.5, 0.95, -0.3), Vector3(0.4, 0.3, 0.4),
		func() -> String: return "Ler a nota sobre as joias" if phase == "library" and state.has_fact("essex_read") else "",
		func(_i: Interactable) -> void:
			state.set_fact("jewellery_read")
			_note(D.NOTES["library"])
			_open_doc("doc_jewellery_note"))
	_inter("librarian", o + Vector3(3.0, 1.0, -1.0), Vector3(1.0, 2.0, 1.0),
		func() -> String: return "Falar com a bibliotecária" if phase == "library" else "",
		func(_i: Interactable) -> void:
			if not state.has_fact("jewellery_read"):
				app.say("\"Fique à vontade. As histórias do condado estão sobre a mesa.\"", 4.0)
				return
			app.show_dialog("Bibliotecária", D.LIBRARIAN, ["Obrigado."], func(_j: int) -> void:
				state.set_fact("intro_note")
				state.add_doc("doc_intro_note")
				_go("street")))


func _build_street() -> void:
	## Caminhada curta, de noite, até a casa da Srta. Tilton [C].
	var o := STREET
	WorldKit.box(_world, o + Vector3(0, -0.1, 0), Vector3(10, 0.2, 30), M_COBBLE)
	for side: float in [-6.0, 6.0]:
		for k in 4:
			WorldKit.box(_world, o + Vector3(side, 3.5, -10 + k * 7), Vector3(3, 7, 6.5), M_CLAP if k % 2 == 0 else M_BRICK)
	WorldKit.omni(_world, o + Vector3(2.5, 3.5, 2), Color(1.0, 0.75, 0.45), 1.0, 9.0)
	WorldKit.blocker(_world, o + Vector3(0, 2, 15), Vector3(10, 4, 1))
	_exit("society_door", o + Vector3(0, 1.1, -12.9), "Entrar na Sociedade Histórica com a Srta. Tilton",
		func() -> bool: return phase == "street",
		func() -> void: _go("society", "cp01_society"))
	WorldKit.box(_world, o + Vector3(0, 3, -13.5), Vector3(10, 6, 1), M_BRICK)


func _build_society() -> void:
	## A sala escura e a vitrine iluminada por luz elétrica [C].
	var o := SOCIETY
	_room(o, Vector3(10, 3.4, 8), M_WALL, M_FLOOR)
	for k in 3:
		WorldKit.box(_world, o + Vector3(-3.5 + k * 3.5, 1.0, -3.6), Vector3(2.4, 2.0, 0.6), M_WOOD)
	WorldKit.box(_world, o + Vector3(0, 0.5, -1.0), Vector3(1.2, 1.0, 0.8), M_WOOD)
	WorldKit.box(_world, o + Vector3(0, 1.02, -1.0), Vector3(0.9, 0.04, 0.6), TexFactory.flat(Color(0.16, 0.06, 0.07)), false)
	var glass := StandardMaterial3D.new()
	glass.albedo_color = Color(0.7, 0.75, 0.8, 0.15)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	WorldKit.box(_world, o + Vector3(0, 1.35, -1.0), Vector3(1.0, 0.6, 0.7), glass, false)
	_tiara = WorldKit.tiara(_world, o + Vector3(0, 1.05, -1.0), 1.6)
	var spot := SpotLight3D.new()
	spot.position = o + Vector3(0, 2.6, -0.6)
	spot.rotation.x = -1.35
	spot.light_color = Color(1.0, 0.95, 0.85)
	spot.light_energy = 3.0
	spot.spot_range = 4.0
	spot.spot_angle = 22.0
	_world.add_child(spot)
	var tilton := WorldKit.figure(_world, o + Vector3(2.0, 0, 0.5), 1.62, false, false, "woman")
	tilton.rotation.y = PI * 0.7
	_inter("tiara_case", o + Vector3(0, 1.3, -0.6), Vector3(1.2, 0.8, 0.4),
		func() -> String: return "Examinar a tiara" if phase == "society" and not _inspect else "",
		func(_i: Interactable) -> void: _inspect_tiara())
	_inter("tiara_label", o + Vector3(0.65, 1.0, -0.55), Vector3(0.3, 0.2, 0.2),
		func() -> String: return "Ler a etiqueta" if phase == "society" else "",
		func(_i: Interactable) -> void: _open_doc("doc_tiara_label"))
	WorldKit.box(_world, o + Vector3(0.65, 1.02, -0.58), Vector3(0.2, 0.01, 0.1), TexFactory.flat(Color(0.85, 0.82, 0.7)), false)
	_inter("tilton", o + Vector3(2.0, 1.0, 0.5), Vector3(1.0, 2.0, 1.0),
		func() -> String: return "Falar com a Srta. Tilton" if phase == "society" and state.has_fact("tiara_seen") else "",
		func(_i: Interactable) -> void: _tilton(0))
	_inter("archive", o + Vector3(-3.5, 1.0, -3.2), Vector3(2.4, 2.0, 0.4),
		func() -> String: return "Arquivo da Sociedade: cartas" if phase == "society" and state.has_fact("tilton_done") else "",
		func(_i: Interactable) -> void:
			state.set_fact("offers_read")
			_open_doc("doc_marsh_offers"))
	_exit("society_exit", o + Vector3(0, 1.1, 3.95), "Ir para a Y.M.C.A.",
		func() -> bool: return phase == "society" and state.has_fact("tilton_done"),
		func() -> void: _ymca())


func _inspect_tiara() -> void:
	## evt_tiara_reveal [REV]: inspeção de perto; a peça gira; pseudo-memória [PSI].
	_inspect = true
	player.controls_enabled = false
	_update_ambience()
	var cam_target := SOCIETY + Vector3(0, 1.45, -0.25)
	player.set_physics_process(false)
	var tw := create_tween()
	tw.tween_property(player, "global_position", cam_target - Vector3(0, Player.STAND_H, 0), 0.8)
	await tw.finished
	player.set_view(0.0, -0.45)
	var spin := create_tween()
	spin.tween_property(_tiara, "rotation:y", TAU, 9.0)
	_think(D.THOUGHTS["tiara_look"], 5.0)
	await get_tree().create_timer(4.5, false).timeout
	app.play_sound("sfx_bell", Vector3.INF, -10.0, 0.5)
	_think(D.THOUGHTS["tiara_creatures"], 5.0)
	await get_tree().create_timer(5.0, false).timeout
	if not is_inside_tree():
		return
	state.set_fact("tiara_seen")
	_note(D.NOTES["tiara"])
	_inspect = false
	_update_ambience()
	player.set_physics_process(true)
	_spawn(SOCIETY + Vector3(0.8, 0.05, 0.6), 0.0)
	player.controls_enabled = true


func _tilton(step: int) -> void:
	if step >= D.TILTON.size():
		state.set_fact("tilton_done")
		_note(D.NOTES["tilton"])
		return
	var line: Array = D.TILTON[step]
	app.show_dialog(line[0], line[1], line[2], func(_j: int) -> void: _tilton(step + 1))


func _ymca() -> void:
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 0.8).finished
	if not is_inside_tree():
		return
	app.say(D.YMCA, 5.0)
	_think(D.THOUGHTS["ymca"], 6.0)
	state.set_fact("ymca_done")
	await get_tree().create_timer(6.0, false).timeout
	app.save_checkpoint("cp01_bus_stop")
	_enter("morning")
	player.controls_enabled = true
	app.ui.fade_to(0.0, 1.0)


func _build_morning() -> void:
	## Diante da Hammond's, 10h [C]: os ociosos se afastam; o ônibus cinzento; Sargent.
	var o := MORNING
	WorldKit.box(_world, o + Vector3(0, -0.1, 0), Vector3(60, 0.2, 40), M_COBBLE)
	var fronts := [["Hammond's Drug Store", -6.0], ["Ideal Lunch", 14.0], ["", 4.0], ["", -16.0]]
	for fr: Array in fronts:
		var x: float = fr[1]
		WorldKit.box(_world, o + Vector3(x, 4.5, -9), Vector3(9, 9, 6), M_BRICK)
		WorldKit.box(_world, o + Vector3(x, 1.4, -5.95), Vector3(5, 2.2, 0.05), TexFactory.flat(Color(0.08, 0.08, 0.08)), false)
	WorldKit.blocker(_world, o + Vector3(0, 2, 10), Vector3(60, 4, 1))
	WorldKit.blocker(_world, o + Vector3(-12, 2, 0), Vector3(1, 4, 40))
	WorldKit.blocker(_world, o + Vector3(24, 2, 0), Vector3(1, 4, 40))
	for k in 5:
		var f := WorldKit.figure(_world, o + Vector3(-9 + k * 1.4, 0, -3.5 + (k % 2) * 0.8), 1.65 + 0.05 * (k % 3))
		_loiterers.append(f)
	_bus = Node3D.new()
	_bus.position = o + Vector3(40, 0, 1.5)
	_world.add_child(_bus)
	WorldKit.box(_bus, Vector3(0, 1.45, 0), Vector3(7.0, 2.3, 2.4), TexFactory.flat(Color(0.33, 0.33, 0.31)))
	WorldKit.box(_bus, Vector3(-3.51, 1.9, 0), Vector3(0.04, 0.6, 2.0), TexFactory.flat(Color(0.05, 0.06, 0.07)), false)
	WorldKit.box(_bus, Vector3(-3.52, 2.4, 0), Vector3(0.02, 0.25, 1.6), TexFactory.flat(Color(0.8, 0.78, 0.7)), false)
	_inter("bus_door", o + Vector3(-1.8, 1.2, 1.5), Vector3(1.2, 2.4, 2.6),
		func() -> String: return "Embarcar (dizer \"Innsmouth\" e entregar um dólar)" if phase == "morning" and _bus_ready else "",
		func(_i: Interactable) -> void: _board())


func _bus_arrives() -> void:
	if state.set_fact("avoidance_seen"):
		_think(D.THOUGHTS["avoid"], 5.0)
	for k in _loiterers.size():
		var f: Node3D = _loiterers[k]
		var tw := f.create_tween()
		tw.tween_interval(k * 0.5)
		tw.tween_property(f, "position", MORNING + Vector3(14 + k * 0.8, 0, -4.5), 6.0)
		tw.tween_callback(f.hide)
	await get_tree().create_timer(3.0, false).timeout
	if not is_inside_tree():
		return
	var arrive := create_tween()
	arrive.tween_property(_bus, "position", MORNING + Vector3(0.5, 0, 1.5), 4.0).set_ease(Tween.EASE_OUT)
	app.play_sound("sfx_creak_long", MORNING + Vector3(4, 1, 1.5), 0.0, 0.6)
	await arrive.finished
	_see("um ônibus cinzento e decrépito: \"Arkham-Innsmouth-Newb'port\"", 4.0)
	for k2 in 3:
		var p := WorldKit.figure(_world, MORNING + Vector3(-1.5, 0, 3.2), 1.7)
		_passengers.append(p)
		var tw2 := p.create_tween()
		tw2.tween_interval(k2 * 0.9)
		tw2.tween_property(p, "position", MORNING + Vector3(-11, 0, 6 + k2), 7.0)
		tw2.tween_callback(p.hide)
	_sargent = WorldKit.figure(_world, MORNING + Vector3(-2.2, 0, 2.8), 1.85, false, false, "man")
	FigureKit.add_staring_eyes(_sargent)
	var tw3 := _sargent.create_tween()
	tw3.tween_property(_sargent, "position", MORNING + Vector3(-6, 0, -5.5), 3.0)
	tw3.tween_interval(3.0)
	tw3.tween_property(_sargent, "position", MORNING + Vector3(-2.2, 0, 1.5), 3.0)
	await tw3.finished
	if not is_inside_tree():
		return
	_bus_ready = true
	_think(D.THOUGHTS["sargent"], 5.0)


func _board() -> void:
	app.show_dialog("", D.SARGENT_FARE, ["Sentar atrás dele, do mesmo lado, do lado da costa."], func(_j: int) -> void:
		state.set_fact("sargent_paid")
		_note(D.NOTES["sargent"])
		player.controls_enabled = false
		await app.ui.fade_to(1.0, 1.2).finished
		app.save_checkpoint("cp02_bus_ride")
		finished.emit())


func _physics_process(_delta: float) -> void:
	if phase == "morning" and _sargent and _bus_ready and is_instance_valid(_sargent):
		var to := player.global_position - _sargent.global_position
		to.y = 0
		if to.length() > 0.5:
			_sargent.look_at(_sargent.global_position + to, Vector3.UP)


func debug_event(id: String) -> void:
	match id:
		"tiara":
			_spawn(SOCIETY + Vector3(0, 0.05, 0.05), 0.0)
			player.set_view(0.0, -0.5)
		"bus":
			_bus.position = MORNING + Vector3(0.5, 0, 1.5)
