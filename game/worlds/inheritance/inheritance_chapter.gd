class_name InheritanceChapter
extends ChapterBase
## ch08_inheritance (docs/04 §10): do despertar na chuva à cena final simbólica [O].
## Sem perigo nem falha. Cada subcena é um cenário pequeno, ligado por fade e cartela.

const X = preload("res://data/inheritance_text.gd")
const G = preload("res://data/gilman_text.gd")

const RAIN := Vector3(0, 0, 0)
const OFFICE := Vector3(500, 0, 0)
const SOCIETY := Vector3(520, 0, 0)
const OBERLIN := Vector3(540, 0, 0)
const STUDY := Vector3(560, 0, 0)
const VAULT := Vector3(590, 0, 0)
const ROOM := Vector3(620, 0, 0)
const DREAM := Vector3(0, 0, 1000)
const PALACE := Vector3(200, 0, 1000)
const SEA := Vector3(0, 0, 2000)

var _rain: CPUParticles3D
var _amb_rain: AudioStreamPlayer
var _amb_room: AudioStreamPlayer
var _amb_sea: AudioStreamPlayer
var _amb_drone: AudioStreamPlayer
var _lamp_lights: Array[OmniLight3D] = []
var _photos: Dictionary = {}
var _photo_looks: Dictionary = {}
var _chart: ChartPanel
var _solved: Dictionary = {}
var _jewels: Array[Node3D] = []
var _night := 0
var _dream_t := -1.0
var _dream_goal := Vector3.ZERO
var _dream_figs: Array[Node3D] = []
var _hands: Node3D
var _mirror_cloth: MeshInstance3D
var _reflection: Node3D
var _fish: Array[Dictionary] = []
var _shoggoth: Node3D
var _swim_t := -1.0
var _reef_z := 0.0
var _descent := false


func _objectives() -> Dictionary:
	return X.OBJECTIVES


func _hints() -> Dictionary:
	return X.HINTS


func _docs() -> Dictionary:
	var d: Dictionary = G.DOCS.duplicate()
	d.merge(X.DOCS)
	return d


func _journal_key() -> String:
	return "dream" if phase.begins_with("dream") else phase


# ================================================================ início

func begin(s: StoryState) -> void:
	state = s
	state.add_doc("doc_zadok_record")
	_init_world()
	_build_rain()
	_build_office()
	_build_society()
	_build_oberlin()
	_build_study()
	_build_vault()
	_build_room()
	_build_dream()
	_build_palace()
	_build_sea()
	_amb_rain = _loop("amb_wind", -60.0)
	_amb_room = _loop("amb_room", -60.0)
	_amb_sea = _loop("amb_sea", -60.0)
	_amb_drone = _loop("amb_drone", -60.0)
	_make_player()
	player.has_flashlight = false
	_restore(state.checkpoint)


func _restore(cp: String) -> void:
	var order := ["cp08_rain", "cp08_arkham", "cp08_cleveland", "cp08_vault", "cp08_dreams", "cp08_final"]
	var stage := order.find(cp)
	if stage >= 1:
		state.set_fact("no_prints_seen")
		_note(X.NOTES["no_prints"])
	if stage >= 2:
		for f: String in ["testimony_done", "peabody_met", "marsh_eyes_heard", "clippings_read"]:
			state.set_fact(f)
		state.give_item("item_peabody_notes")
		state.add_doc("doc_peabody_notes")
		state.add_doc("doc_raid_clippings")
		for k: String in ["testimony", "peabody", "eyes", "raids"]:
			_note(X.NOTES[k])
	if stage >= 3:
		state.set_fact("chart_complete")
		_note(X.NOTES["chart"])
	if stage >= 4:
		state.set_fact("tiara_fainted")
		_note(X.NOTES["vault"])
	if stage >= 5:
		for f2: String in ["dream1_done", "dream2_done", "dream3_done", "mirror_seen"]:
			state.set_fact(f2)
		_note(X.NOTES["dreams"])
		_note(X.NOTES["mirror"])
	match cp:
		"cp08_rain":
			_enter("rain")
		"cp08_arkham":
			_enter("interview")
		"cp08_cleveland":
			_enter("cleveland")
		"cp08_vault":
			_enter("vault")
		"cp08_dreams":
			_enter("night")
		"cp08_final":
			_enter("final")


func _enter(p: String) -> void:
	## Posiciona o jogador e o ambiente de cada subcena.
	_set_phase(p)
	match p:
		"rain":
			_env_rain()
			_spawn(RAIN + Vector3(0, 0.05, 6), 0.0)
			if not capture_mode:
				app.ui.chapter_card(X.CARDS["rain"], 5.0)
				_after(3.0, func() -> void: _think(X.THOUGHTS["rain"], 5.0))
				_after(8.0, func() -> void: _think(X.THOUGHTS["watch"], 4.0))
		"interview":
			_env_interior(Color(0.55, 0.52, 0.45))
			_spawn(OFFICE + Vector3(0, 0.05, 1.8), 0.0)
			_card("arkham")
		"society":
			_env_interior(Color(0.55, 0.50, 0.42))
			_spawn(SOCIETY + Vector3(0, 0.05, 2.2), 0.0)
			_card("society")
		"oberlin":
			_env_interior(Color(0.40, 0.42, 0.48))
			_spawn(OBERLIN + Vector3(0, 0.05, 1.2), 0.0)
			_card("oberlin")
		"cleveland":
			_env_interior(Color(0.58, 0.52, 0.42))
			_spawn(STUDY + Vector3(0, 0.05, 2.0), 0.0)
			_card("cleveland")
		"vault":
			_env_interior(Color(0.42, 0.42, 0.40))
			_spawn(VAULT + Vector3(0, 0.05, 1.4), 0.0)
			_card("vault")
		"night":
			_env_night_room()
			_spawn(ROOM + Vector3(0, 0.05, 2.5), 0.0)
		"final":
			_env_night_room()
			_mirror_cloth.visible = false
			_reflection.visible = true
			_spawn(ROOM + Vector3(1.0, 0.05, 1.5), PI)
			_card("final")
	_update_ambience()


func _card(id: String) -> void:
	if not capture_mode:
		app.ui.chapter_card(X.CARDS[id], 3.5)


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
	if _amb_rain == null:
		return
	_fade_db(_amb_rain, -14.0 if phase == "rain" else -60.0)
	_fade_db(_amb_room, -16.0 if phase in ["interview", "society", "oberlin", "cleveland", "vault", "night", "mirror", "final"] else -60.0)
	_fade_db(_amb_sea, -10.0 if phase in ["swim", "descent"] or phase.begins_with("dream") else -60.0)
	_fade_db(_amb_drone, -18.0 if phase.begins_with("dream") or phase in ["mirror", "descent"] else -60.0)


# ================================================================ ambientes

func _env_rain() -> void:
	## tod_rain_day: chuva leve, céu cinzento, luz difusa [C].
	_env.background_mode = Environment.BG_SKY
	_sky.sky_top_color = Color(0.36, 0.38, 0.40)
	_sky.sky_horizon_color = Color(0.52, 0.53, 0.52)
	_sky.ground_horizon_color = Color(0.35, 0.36, 0.33)
	_sky.ground_bottom_color = Color(0.2, 0.2, 0.18)
	_env.ambient_light_color = Color(0.55, 0.56, 0.55)
	_env.ambient_light_energy = 1.0
	_env.fog_light_color = Color(0.52, 0.53, 0.52)
	_env.fog_density = 0.02
	_sun.light_color = Color(0.85, 0.86, 0.88)
	_sun.light_energy = 0.35
	_aim_light(_sun, Vector3(0.3, -1.0, 0.2))
	_rain.emitting = true


func _env_interior(lamp: Color) -> void:
	_rain.emitting = false
	_env.background_mode = Environment.BG_COLOR
	_env.background_color = Color(0.02, 0.02, 0.02)
	_env.ambient_light_color = lamp * 0.45
	_env.ambient_light_energy = 1.0
	_env.fog_density = 0.0
	_sun.light_energy = 0.0


func _env_night_room() -> void:
	_rain.emitting = false
	_env.background_mode = Environment.BG_COLOR
	_env.background_color = Color(0.0, 0.0, 0.01)
	_env.ambient_light_color = Color(0.14, 0.14, 0.18)
	_env.ambient_light_energy = 1.0
	_env.fog_density = 0.0
	_sun.light_energy = 0.0


func _env_underwater(tint: Color, density: float) -> void:
	_rain.emitting = false
	_env.background_mode = Environment.BG_COLOR
	_env.background_color = tint * 0.6
	_env.ambient_light_color = tint
	_env.ambient_light_energy = 1.2
	_env.fog_light_color = tint
	_env.fog_density = density
	_sun.light_color = Color(0.5, 0.8, 0.8)
	_sun.light_energy = 0.4
	_aim_light(_sun, Vector3(0.1, -1.0, 0.1))


func _env_sea_night() -> void:
	_set_night(0.006)
	player.camera.far = 1200.0
	_sky.sky_top_color = Color(0.03, 0.04, 0.07)
	_env.background_mode = Environment.BG_SKY
	_sky.sky_horizon_color = Color(0.12, 0.13, 0.16)


# ================================================================ geometria das subcenas

func _room(c: Vector3, size: Vector3, wall: Material, floor_mat: Material, openings_north: Array = []) -> void:
	var hx := size.x * 0.5
	var hz := size.z * 0.5
	WorldKit.box(_world, c + Vector3(0, -0.1, 0), Vector3(size.x, 0.2, size.z), floor_mat)
	WorldKit.box(_world, c + Vector3(0, size.y + 0.1, 0), Vector3(size.x, 0.2, size.z), M_CEIL, false)
	WorldKit.wall_x(_world, c.z - hz, c.x - hx, c.x + hx, 0.0, size.y, wall, openings_north)
	WorldKit.wall_x(_world, c.z + hz, c.x - hx, c.x + hx, 0.0, size.y, wall)
	WorldKit.wall_z(_world, c.x - hx, c.z - hz, c.z + hz, 0.0, size.y, wall)
	WorldKit.wall_z(_world, c.x + hx, c.z - hz, c.z + hz, 0.0, size.y, wall)


func _lamp(pos: Vector3, color: Color, energy: float = 1.0, radius: float = 7.0) -> void:
	var l := WorldKit.omni(_world, pos, color, energy, radius, true)
	WorldKit.box(l, Vector3.ZERO, Vector3(0.18, 0.12, 0.18), TexFactory.flat(color, true), false)
	_lamp_lights.append(l)


func _build_rain() -> void:
	var o := RAIN
	WorldKit.box(_world, o + Vector3(0, -0.3, -10), Vector3(200, 0.2, 200), TexFactory.material("marsh", 3.0))
	WorldKit.box(_world, o + Vector3(0, -0.05, 0), Vector3(3.0, 0.1, 60), TexFactory.material("ballast", 2.0), false)
	for sx: float in [-6.0, 6.0]:
		WorldKit.box(_world, o + Vector3(sx, 1.2, 12), Vector3(6, 2.6, 20), M_DIRT)
	# Estrada de Rowley: lama fresca sem pegadas [C].
	WorldKit.box(_world, o + Vector3(0, -0.12, -14), Vector3(120, 0.1, 7), TexFactory.flat(Color(0.22, 0.18, 0.13)), false)
	_inter("mud", o + Vector3(0, 0.3, -12), Vector3(5, 0.6, 2.5),
		func() -> String: return "Examinar a lama da estrada" if phase == "rain" and not state.has_fact("no_prints_seen") else "",
		func(_i: Interactable) -> void:
			state.set_fact("no_prints_seen")
			_note(X.NOTES["no_prints"])
			_think(X.THOUGHTS["no_prints"], 5.0)
			_after(5.0, func() -> void: _think(X.THOUGHTS["town"], 5.0)))
	var post := WorldKit.box(_world, o + Vector3(-6, 1.0, -17.5), Vector3(0.15, 2.0, 0.15), M_WOOD)
	WorldKit.box(post, Vector3(0.5, 0.8, 0), Vector3(1.2, 0.35, 0.06), TexFactory.flat(Color(0.55, 0.5, 0.4)), false)
	_inter("rowley_sign", o + Vector3(-6, 1.2, -17.5), Vector3(1.6, 2.2, 0.8),
		func() -> String: return "Placa: ROWLEY →" if phase == "rain" else "",
		func(_i: Interactable) -> void:
			if not state.has_fact("no_prints_seen"):
				_think("Antes, a lama da estrada me chama a atenção.", 3.0)
				return
			_think(X.THOUGHTS["rowley"], 5.0)
			_go("interview", "cp08_arkham"))
	# Innsmouth cinzenta a sudeste [C].
	for k in 10:
		WorldKit.box(_world, o + Vector3(60 + k * 9, 4 + (k % 3) * 2, 70 + (k % 4) * 6), Vector3(7, 8 + (k % 3) * 4, 6), TexFactory.flat(Color(0.30, 0.31, 0.32)), false)
	WorldKit.box(_world, o + Vector3(95, 12, 78), Vector3(2.5, 24, 2.5), TexFactory.flat(Color(0.30, 0.31, 0.32)), false)
	WorldKit.blocker(_world, o + Vector3(0, 2, 24), Vector3(30, 4, 1))
	WorldKit.blocker(_world, o + Vector3(-12, 2, 0), Vector3(1, 4, 60))
	WorldKit.blocker(_world, o + Vector3(12, 2, 0), Vector3(1, 4, 60))
	WorldKit.blocker(_world, o + Vector3(0, 2, -21), Vector3(30, 4, 1))
	# Chuva leve (partículas de CPU: suportadas no Compatibility).
	_rain = CPUParticles3D.new()
	_rain.amount = 600
	_rain.lifetime = 1.2
	_rain.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	_rain.emission_box_extents = Vector3(12, 0.5, 12)
	_rain.direction = Vector3(0.1, -1, 0)
	_rain.spread = 3.0
	_rain.initial_velocity_min = 9.0
	_rain.initial_velocity_max = 11.0
	_rain.gravity = Vector3(0, -2, 0)
	var drop := BoxMesh.new()
	drop.size = Vector3(0.015, 0.35, 0.015)
	_rain.mesh = drop
	var dm := StandardMaterial3D.new()
	dm.albedo_color = Color(0.75, 0.78, 0.82, 0.55)
	dm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_rain.material_override = dm
	_rain.position = Vector3(0, 8, 0)
	_rain.emitting = false
	add_child(_rain)


func _build_office() -> void:
	var o := OFFICE
	_room(o, Vector3(6, 3, 5), M_PLASTER, M_FLOOR)
	WorldKit.box(_world, o + Vector3(0, 0.4, -0.8), Vector3(2.0, 0.8, 1.0), M_WOOD)
	var f := WorldKit.figure(_world, o + Vector3(0, 0, -1.7), 1.78)
	f.rotation.y = PI
	_lamp(o + Vector3(0, 2.6, 0), Color(1.0, 0.85, 0.6), 1.1)
	_inter("officer", o + Vector3(0, 1.0, -1.4), Vector3(2.0, 2.0, 1.4),
		func() -> String: return "Falar com o funcionário do governo" if phase == "interview" else "",
		func(_i: Interactable) -> void: _interview())


func _build_society() -> void:
	var o := SOCIETY
	_room(o, Vector3(8, 3.4, 6), M_WALL, M_FLOOR)
	for k in 4:
		WorldKit.box(_world, o + Vector3(-3.2 + k * 2.1, 1.3, -2.6), Vector3(1.8, 2.6, 0.5), M_WOOD)
	var f := WorldKit.figure(_world, o + Vector3(1.0, 0, -1.4), 1.7, false, false, "old")
	f.rotation.y = PI
	_lamp(o + Vector3(0, 3.0, 0), Color(1.0, 0.82, 0.55), 1.0, 8.0)
	_inter("peabody", o + Vector3(1.0, 1.0, -1.4), Vector3(1.0, 2.0, 1.0),
		func() -> String: return "Falar com E. Lapham Peabody" if phase == "society" and not state.has_fact("peabody_met") else "",
		func(_i: Interactable) -> void: _peabody(0))
	_inter("museum_plaque", o + Vector3(-3.8, 1.5, 1.5), Vector3(0.3, 0.8, 1.0),
		func() -> String: return "Placa: Museu da Universidade Miskatonic" if phase == "society" else "",
		func(_i: Interactable) -> void:
			state.set_fact("museum_skipped")
			_think(X.THOUGHTS["museum"], 4.0))
	WorldKit.box(_world, o + Vector3(-3.95, 1.5, 1.5), Vector3(0.05, 0.6, 0.8), TexFactory.flat(Color(0.5, 0.42, 0.25)), false)
	WorldKit.box(_world, o + Vector3(0, 1.1, 2.95), Vector3(1.0, 2.2, 0.08), M_WOOD, false)
	_inter("society_door", o + Vector3(0, 1.1, 2.8), Vector3(1.0, 2.2, 0.3),
		func() -> String: return "Sair" if phase == "society" and state.has_fact("peabody_met") else "",
		func(_i: Interactable) -> void: _go("oberlin"))


func _build_oberlin() -> void:
	var o := OBERLIN
	_room(o, Vector3(4, 2.8, 4), M_WALL, M_FLOOR)
	WorldKit.box(_world, o + Vector3(0, 0.38, -1.4), Vector3(1.4, 0.76, 0.7), M_WOOD)
	WorldKit.box(_world, o + Vector3(-1.3, 0.25, 0.8), Vector3(0.9, 0.5, 1.9), M_WOOD)
	_lamp(o + Vector3(0.4, 1.1, -1.5), Color(1.0, 0.82, 0.55), 0.9, 5.0)
	_inter("clippings", o + Vector3(-0.3, 0.85, -1.4), Vector3(0.6, 0.2, 0.5),
		func() -> String: return "Ler os recortes de fevereiro" if phase == "oberlin" else "",
		func(_i: Interactable) -> void:
			var first := state.set_fact("clippings_read")
			_open_doc("doc_raid_clippings")
			if first:
				_note(X.NOTES["raids"])
				_after(1.0, func() -> void:
					app.play_sound("sfx_knock", OBERLIN + Vector3(0, 1.2, 2.0))
					_think(X.THOUGHTS["knock"], 5.0)
					_after(5.5, func() -> void: _go("cleveland", "cp08_cleveland"))))
	_inter("federal_letter", o + Vector3(0.35, 0.85, -1.4), Vector3(0.4, 0.2, 0.4),
		func() -> String: return "Ler a carta oficial" if phase == "oberlin" else "",
		func(_i: Interactable) -> void:
			state.set_fact("letter_read")
			_open_doc("doc_federal_letter"))


func _build_study() -> void:
	var o := STUDY
	_room(o, Vector3(7, 3.2, 6), M_WALL, M_FLOOR)
	WorldKit.box(_world, o + Vector3(0, 0.4, -0.6), Vector3(2.4, 0.8, 1.2), M_WOOD)
	_lamp(o + Vector3(0, 2.8, 0), Color(1.0, 0.84, 0.58), 1.1, 8.0)
	var walter := WorldKit.figure(_world, o + Vector3(2.4, 0, -1.4), 1.76, false, false, "man")
	walter.rotation.y = PI * 0.8
	var gf := WorldKit.figure(_world, o + Vector3(-2.6, 0, 1.6), 1.62, false, false, "old")
	gf.rotation.y = -PI * 0.3
	_inter("walter", o + Vector3(2.4, 1.0, -1.4), Vector3(1.0, 2.0, 1.0),
		func() -> String:
			if phase != "cleveland":
				return ""
			return "Falar com o tio Walter" if not state.has_fact("chart_complete") else "Ver a caixa do banco",
		func(_i: Interactable) -> void:
			if state.has_fact("chart_complete"):
				app.show_dialog("Tio Walter", X.WALTER_CHART_DONE, ["Quero ver."], func(_j: int) -> void: _go("vault", "cp08_vault"))
			else:
				app.show_dialog("Tio Walter", X.WALTER_FILES, ["Obrigado."], func(_j: int) -> void: pass))
	_inter("grandfather", o + Vector3(-2.6, 1.0, 1.6), Vector3(1.0, 2.0, 1.0),
		func() -> String: return "Falar com o avô" if phase == "cleveland" else "",
		func(_i: Interactable) -> void: app.show_dialog("Avô Williamson", "Os papéis dos Williamson estão todos aqui. Os dos Orne… peça ao Walter. Nunca gostei de mexer neles.", ["Obrigado, vovô."], func(_j: int) -> void: pass))
	var items := {
		"photo_eliza": [Vector3(-0.8, 0.82, -0.6), "doc_photo_eliza", "Examinar a fotografia da avó Eliza"],
		"photo_douglas": [Vector3(-0.3, 0.82, -0.6), "doc_photo_douglas", "Examinar a fotografia do tio Douglas"],
		"letters": [Vector3(0.4, 0.82, -0.5), "doc_orne_letters", "Ler as cartas e recortes dos Orne"],
		"miniature": [Vector3(0.9, 0.82, -0.7), "doc_miniature", "Examinar a miniatura"],
	}
	for id: String in items.keys():
		var it: Array = items[id]
		var pos: Vector3 = o + (it[0] as Vector3)
		var mesh := WorldKit.box(_world, pos, Vector3(0.22, 0.03, 0.28), TexFactory.flat(Color(0.75, 0.72, 0.62)), false)
		if id.begins_with("photo"):
			_photos[id] = mesh
		var doc: String = it[1]
		var label: String = it[2]
		var pid := id
		_inter(id, pos + Vector3(0, 0.1, 0), Vector3(0.4, 0.3, 0.4),
			func() -> String: return label if phase == "cleveland" else "",
			func(_i: Interactable) -> void: _study_item(pid, doc))
	WorldKit.box(_world, o + Vector3(0, 1.6, -2.95), Vector3(2.6, 1.6, 0.06), TexFactory.flat(Color(0.42, 0.34, 0.22)), false)
	_inter("chart", o + Vector3(0, 1.6, -2.8), Vector3(2.6, 1.6, 0.3),
		func() -> String: return "Montar o quadro da família" if phase == "cleveland" else "",
		func(_i: Interactable) -> void: _open_chart())


func _build_vault() -> void:
	var o := VAULT
	_room(o, Vector3(5, 2.8, 4), TexFactory.flat(Color(0.30, 0.31, 0.30)), TexFactory.flat(Color(0.22, 0.22, 0.21)))
	for k in 12:
		WorldKit.box(_world, o + Vector3(-2.3 + (k % 6) * 0.9, 0.9 + floorf(k / 6.0) * 0.8, -1.85), Vector3(0.8, 0.7, 0.2), TexFactory.flat(Color(0.45, 0.43, 0.38)), false)
	WorldKit.box(_world, o + Vector3(0, 0.45, -0.4), Vector3(1.6, 0.9, 0.9), M_WOOD)
	WorldKit.box(_world, o + Vector3(0, 0.98, -0.4), Vector3(0.7, 0.16, 0.45), TexFactory.flat(Color(0.18, 0.12, 0.08)), false)
	_lamp(o + Vector3(0, 2.4, 0), Color(0.95, 0.92, 0.8), 1.0, 6.0)
	var walter := WorldKit.figure(_world, o + Vector3(0.9, 0, -1.2), 1.76, false, false, "man")
	walter.rotation.y = PI * 0.85
	_inter("vault_walter", o + Vector3(0.9, 1.0, -1.2), Vector3(1.0, 2.0, 1.0),
		func() -> String: return "Pedir ao tio Walter que abra a caixa" if phase == "vault" and not state.has_fact("tiara_fainted") else "",
		func(_i: Interactable) -> void: _vault_line(0))
	_inter("governess_note", o + Vector3(-0.6, 0.95, -0.2), Vector3(0.3, 0.2, 0.3),
		func() -> String: return "Ler a nota guardada com as joias" if phase == "vault" else "",
		func(_i: Interactable) -> void:
			state.set_fact("governess_read")
			_open_doc("doc_governess_note"))
	WorldKit.box(_world, o + Vector3(-0.6, 0.91, -0.2), Vector3(0.2, 0.01, 0.26), TexFactory.flat(Color(0.8, 0.76, 0.6)), false)
	var gold := StandardMaterial3D.new()
	# Ouro esbranquiçado de liga desconhecida [C]: brilho de metal, sem estourar o branco.
	gold.albedo_color = Color(0.80, 0.76, 0.58)
	gold.metallic = 0.7
	gold.roughness = 0.3
	gold.emission_enabled = true
	gold.emission = Color(0.80, 0.76, 0.58)
	gold.emission_energy_multiplier = 0.25
	for k2 in 2:
		var arm := MeshInstance3D.new()
		var tm := TorusMesh.new()
		tm.inner_radius = 0.06
		tm.outer_radius = 0.09
		arm.mesh = tm
		arm.material_override = gold
		arm.position = o + Vector3(-0.55 + k2 * 0.22, 0.92, -0.02)
		arm.rotation.x = PI / 2
		arm.visible = false
		_world.add_child(arm)
		_jewels.append(arm)
	var pect := WorldKit.box(_world, o + Vector3(0.42, 0.91, -0.02), Vector3(0.3, 0.02, 0.22), gold, false)
	pect.visible = false
	_jewels.append(pect)
	# Tiara: alta na frente, de periferia elíptica e irregular [C, cap. I].
	var tiara := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.radial_segments = 8
	cyl.rings = 1
	cyl.top_radius = 0.08
	cyl.bottom_radius = 0.11
	cyl.height = 0.18
	tiara.mesh = cyl
	tiara.material_override = gold
	tiara.scale = Vector3(1.0, 1.0, 1.45)
	tiara.position = o + Vector3(0.0, 1.15, -0.4)
	tiara.visible = false
	_world.add_child(tiara)
	_jewels.append(tiara)


func _build_room() -> void:
	## Quarto em Toledo [I local; O layout]: cama, escrivaninha com o manuscrito, gaveta, espelho.
	var o := ROOM
	_room(o, Vector3(5, 2.8, 5), M_WALL, M_FLOOR, [Vector4(o.x - 0.45, o.x + 0.45, 0.9, 2.2)])
	WorldKit.box(_world, o + Vector3(-1.6, 0.25, 0.6), Vector3(1.0, 0.5, 2.0), M_WOOD)
	WorldKit.box(_world, o + Vector3(1.6, 0.38, 1.5), Vector3(1.2, 0.76, 0.6), M_WOOD)
	WorldKit.box(_world, o + Vector3(1.6, 0.8, 1.5), Vector3(0.4, 0.02, 0.3), TexFactory.flat(Color(0.86, 0.84, 0.76)), false)
	_lamp(o + Vector3(1.9, 1.0, 1.4), Color(1.0, 0.8, 0.5), 1.3, 7.0)
	# Espelho: moldura, vidro escuro e o pano que o cobre.
	# Moldura em quatro réguas: a abertura do espelho fica livre para o reflexo.
	for fy: float in [0.87, 2.23]:
		WorldKit.box(_world, o + Vector3(0, fy, -2.47), Vector3(1.1, 0.08, 0.06), M_WOOD, false)
	for fx: float in [-0.49, 0.49]:
		WorldKit.box(_world, o + Vector3(fx, 1.55, -2.47), Vector3(0.08, 1.44, 0.06), M_WOOD, false)
	var glass := StandardMaterial3D.new()
	glass.albedo_color = Color(0.25, 0.28, 0.30, 0.22)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass.metallic_specular = 1.0
	glass.roughness = 0.05
	WorldKit.box(_world, o + Vector3(0, 1.55, -2.5), Vector3(0.9, 1.3, 0.02), glass, false)
	_mirror_cloth = WorldKit.box(_world, o + Vector3(0, 1.5, -2.42), Vector3(1.2, 1.6, 0.04), TexFactory.flat(Color(0.75, 0.72, 0.66)), false)
	# Espaço escuro e oco atrás do espelho, onde o reflexo é encenado.
	var void_mat := TexFactory.flat(Color(0.03, 0.03, 0.035))
	WorldKit.box(_world, o + Vector3(0, 1.4, -5.8), Vector3(3.0, 2.8, 0.1), void_mat, false)
	WorldKit.box(_world, o + Vector3(-1.5, 1.4, -4.15), Vector3(0.1, 2.8, 3.3), void_mat, false)
	WorldKit.box(_world, o + Vector3(1.5, 1.4, -4.15), Vector3(0.1, 2.8, 3.3), void_mat, false)
	WorldKit.box(_world, o + Vector3(0, -0.05, -4.15), Vector3(3.0, 0.1, 3.3), void_mat, false)
	WorldKit.box(_world, o + Vector3(0, 2.85, -4.15), Vector3(3.0, 0.1, 3.3), void_mat, false)
	WorldKit.omni(_world, o + Vector3(1.0, 1.4, -2.9), Color(1.0, 0.8, 0.5), 1.6, 4.0)
	WorldKit.blocker(_world, o + Vector3(0, 1.4, -2.6), Vector3(1.2, 2.8, 0.3))
	# Reflexo [C "the Innsmouth look"]: olhos que não piscam, vincos no pescoço (D-013).
	_reflection = WorldKit.figure(_world, o + Vector3(0, 0, -4.0), 1.75, false, false, "man")
	FigureKit.add_staring_eyes(_reflection)
	_reflection.visible = false
	_inter("bed_toledo", o + Vector3(-1.6, 0.6, 0.6), Vector3(1.0, 0.6, 2.0),
		func() -> String: return "Deitar-se" if phase == "night" else "",
		func(_i: Interactable) -> void: _sleep())
	_inter("drawer", o + Vector3(1.6, 0.55, 1.2), Vector3(1.0, 0.3, 0.2),
		func() -> String: return "Abrir a gaveta" if phase in ["mirror", "final"] else "",
		func(_i: Interactable) -> void:
			state.set_fact("drawer_seen")
			_think(X.THOUGHTS["drawer"], 5.0))
	_inter("manuscript", o + Vector3(1.6, 0.9, 1.5), Vector3(0.5, 0.3, 0.4),
		func() -> String:
			if phase != "final":
				return ""
			return "Assinar" if state.has_fact("plan_written") else "Escrever as últimas páginas",
		func(_i: Interactable) -> void: _write_final())


func _build_dream() -> void:
	## lvl_dream_sea [C como sonho]: pórticos titânicos submersos, muralhas ciclópicas, peixes.
	var o := DREAM
	WorldKit.box(_world, o + Vector3(0, -0.1, -40), Vector3(80, 0.2, 120), TexFactory.flat(Color(0.30, 0.34, 0.28)))
	var stone := TexFactory.flat(Color(0.22, 0.30, 0.28))
	for k in 8:
		var z := -k * 12.0
		for sx: float in [-9.0, 9.0]:
			WorldKit.box(_world, o + Vector3(sx, 9, z), Vector3(3.5, 18, 3.5), stone)
		WorldKit.box(_world, o + Vector3(0, 18.5, z), Vector3(22, 2.5, 3.5), stone, false)
	for k2 in 6:
		WorldKit.box(_world, o + Vector3(-24 + (k2 % 2) * 48, 7, -10 - k2 * 15), Vector3(4, 14, 14), stone)
	for k3 in 40:
		var f := WorldKit.box(_world, o + Vector3(randf_range(-15, 15), randf_range(1, 12), randf_range(-90, 5)), Vector3(0.5, 0.25, 0.12), TexFactory.flat(Color(0.5, 0.55, 0.4)), false)
		_fish.append({"node": f, "speed": randf_range(0.6, 1.6), "phase": randf() * TAU})
	var temple := WorldKit.box(_world, o + Vector3(0, 6, -92), Vector3(16, 12, 6), stone)
	WorldKit.box(temple, Vector3(0, -2, 3.05), Vector3(4, 7, 0.1), TexFactory.flat(Color(0.35, 0.65, 0.55), true), false)
	WorldKit.blocker(_world, o + Vector3(-14, 4, -40), Vector3(1, 8, 120))
	WorldKit.blocker(_world, o + Vector3(14, 4, -40), Vector3(1, 8, 120))
	WorldKit.blocker(_world, o + Vector3(0, 4, 8), Vector3(30, 8, 1))


func _build_palace() -> void:
	## Palácio fosforescente de muitos terraços, jardins de corais leprosos [C como sonho].
	var o := PALACE
	WorldKit.box(_world, o + Vector3(0, -0.1, -20), Vector3(60, 0.2, 60), TexFactory.flat(Color(0.18, 0.24, 0.24)))
	var phos := TexFactory.flat(Color(0.25, 0.55, 0.50), true)
	var dim := TexFactory.flat(Color(0.12, 0.20, 0.22))
	for t in 5:
		WorldKit.box(_world, o + Vector3(0, 1 + t * 3.0, -26 - t * 4.0), Vector3(30 - t * 4.0, 2.0, 6), dim)
		WorldKit.box(_world, o + Vector3(0, 2.05 + t * 3.0, -23.2 - t * 4.0), Vector3(30 - t * 4.0, 0.1, 0.3), phos, false)
	for k in 26:
		var c := WorldKit.box(_world, o + Vector3(randf_range(-14, 14), 0.8, randf_range(-18, 2)), Vector3(0.3, randf_range(0.8, 2.6), 0.3), TexFactory.flat(Color(0.65, 0.58, 0.48)), false)
		c.rotation = Vector3(randf_range(-0.3, 0.3), randf() * TAU, randf_range(-0.3, 0.3))
	var gm := WorldKit.deep_one(_world, o + Vector3(0, 0, -12), "robed", 77)
	gm.rotation.y = 0.0
	WorldKit.omni(_world, o + Vector3(0, 3, -10), Color(0.4, 0.8, 0.7), 1.4, 12.0)
	_inter("grandmother", o + Vector3(0, 1.2, -12), Vector3(1.4, 2.4, 1.4),
		func() -> String: return "Aproximar-se" if phase == "dream3" else "",
		func(_i: Interactable) -> void: _grandmother(0))
	# Pth'thya-l'yi ao fundo, sem rosto pleno [C como sonho; O representação].
	var big := WorldKit.deep_one(_world, o + Vector3(6, 6, -40), "robed", 99)
	big.scale = Vector3(4.5, 4.5, 4.5)
	# O shoggoth: massa escura que surge no fim do sonho [C como sonho].
	_shoggoth = Node3D.new()
	_shoggoth.position = o + Vector3(-20, 2, -30)
	_world.add_child(_shoggoth)
	for k2 in 18:
		var b := MeshInstance3D.new()
		var sm := SphereMesh.new()
		sm.radial_segments = 8
		sm.rings = 4
		sm.radius = randf_range(1.0, 2.4)
		sm.height = sm.radius * 2.0
		b.mesh = sm
		b.material_override = TexFactory.flat(Color(0.02, 0.03, 0.025))
		b.position = Vector3(randf_range(-3, 3), randf_range(-1, 3), randf_range(-3, 3))
		_shoggoth.add_child(b)
	for k3 in 30:
		var e := MeshInstance3D.new()
		var es := SphereMesh.new()
		es.radial_segments = 8
		es.rings = 4
		es.radius = 0.12
		es.height = 0.24
		e.mesh = es
		e.material_override = TexFactory.flat(Color(0.75, 0.9, 0.6), true)
		e.position = Vector3(randf_range(-3, 3), randf_range(-1, 4), randf_range(-3.5, 3.5))
		_shoggoth.add_child(e)
	_shoggoth.visible = false
	WorldKit.blocker(_world, o + Vector3(0, 4, 8), Vector3(40, 8, 1))
	WorldKit.blocker(_world, o + Vector3(-16, 4, -10), Vector3(1, 8, 40))
	WorldKit.blocker(_world, o + Vector3(16, 4, -10), Vector3(1, 8, 40))
	WorldKit.blocker(_world, o + Vector3(0, 4, -22), Vector3(40, 8, 1))


func _build_sea() -> void:
	## Cena final simbólica [O]: Devil Reef ao luar, o abismo, as colunas de Y'ha-nthlei.
	var o := SEA
	var water := StandardMaterial3D.new()
	water.albedo_color = Color(0.03, 0.05, 0.08)
	water.roughness = 0.2
	water.metallic_specular = 0.8
	WorldKit.box(_world, o + Vector3(0, 0, -200), Vector3(800, 0.1, 800), water, false)
	_reef_z = o.z - 90.0
	# Caminho de luar até o recife [O, recurso de leitura]: o recife negro se recorta contra ele.
	var glint := StandardMaterial3D.new()
	glint.albedo_color = Color(0.10, 0.11, 0.14)
	glint.disable_fog = true
	glint.emission_enabled = true
	glint.emission = Color(0.30, 0.32, 0.38)
	glint.emission_energy_multiplier = 0.6
	var rng := RandomNumberGenerator.new()
	rng.seed = 1931
	for k in 220:
		var dz := rng.randf_range(6.0, 420.0)
		var spread := 1.5 + dz * 0.035
		WorldKit.box(_world, o + Vector3(rng.randf_range(-spread, spread) - dz * 0.12, 0.06, -dz), Vector3(rng.randf_range(0.6, 2.2), 0.02, rng.randf_range(0.2, 0.5)), glint, false)
	var reef_mat := StandardMaterial3D.new()
	reef_mat.albedo_color = Color.BLACK
	reef_mat.disable_fog = true
	WorldKit.box(_world, o + Vector3(0, 0.8, -90), Vector3(60, 2.0, 8), reef_mat, false)
	var moon := MeshInstance3D.new()
	var ms := SphereMesh.new()
	ms.radial_segments = 8
	ms.rings = 4
	ms.radius = 18.0
	ms.height = 36.0
	moon.mesh = ms
	moon.material_override = TexFactory.flat(Color(0.95, 0.9, 0.7), true)
	moon.position = o + Vector3(-150, 160, -500)
	_world.add_child(moon)
	var col := TexFactory.flat(Color(0.30, 0.55, 0.50), true)
	for k in 30:
		var px := (k % 6 - 2.5) * 14.0
		var pz := -90.0 - floorf(k / 6.0) * 16.0
		WorldKit.box(_world, o + Vector3(px, -110, pz), Vector3(3.0, 40.0, 3.0), col, false)


# ================================================================ subcenas: fluxo

func _interview() -> void:
	var remaining: Array = []
	for id: String in X.INTERVIEW_TOPICS.keys():
		if not state.has_fact(id):
			remaining.append(id)
	if remaining.is_empty():
		app.show_dialog("Funcionário do governo", X.INTERVIEW_END, ["Entendido."], func(_j: int) -> void:
			if state.set_fact("testimony_done"):
				_note(X.NOTES["testimony"])
			_go("society"))
		return
	var labels: Array = []
	for id2: String in remaining:
		labels.append(X.INTERVIEW_TOPICS[id2][0])
	var intro := X.INTERVIEW_INTRO if remaining.size() == 4 else "Continue."
	app.show_dialog("Funcionário do governo", intro, labels, func(i: int) -> void:
		var chosen: String = remaining[i]
		state.set_fact(chosen)
		_think(X.INTERVIEW_TOPICS[chosen][1], 5.0)
		_after(0.2, func() -> void: _interview()))


func _peabody(step: int) -> void:
	if step >= X.PEABODY.size():
		state.set_fact("peabody_met")
		state.set_fact("marsh_eyes_heard")
		state.give_item("item_peabody_notes")
		state.add_doc("doc_peabody_notes")
		_note(X.NOTES["peabody"])
		_note(X.NOTES["eyes"])
		_think("Não me agradou saber que o nome Marsh estava na minha árvore. Copiei tudo mesmo assim.", 5.0)
		return
	var line: Array = X.PEABODY[step]
	app.show_dialog(line[0], line[1], line[2], func(_j: int) -> void: _peabody(step + 1))


func _study_item(id: String, doc: String) -> void:
	var looks := int(_photo_looks.get(id, 0)) + 1
	_photo_looks[id] = looks
	_open_doc(doc)
	match id:
		"photo_eliza":
			state.set_fact("photos_eliza")
		"photo_douglas":
			state.set_fact("photos_douglas")
		"letters":
			state.set_fact("letters_read")
		"miniature":
			state.set_fact("miniature_seen")
	if id.begins_with("photo") and looks >= 2:
		# evt_photo_shift [C]: o rosto passa a sugerir algo — troca sutil, sem animação.
		var m: MeshInstance3D = _photos[id]
		m.material_override = TexFactory.flat(Color(0.62, 0.68, 0.62))
		if state.set_fact("photo_shift_seen"):
			_note(X.NOTES["photos"])
		_after(0.5, func() -> void: _think(X.THOUGHTS["photo_again"], 6.0))


func _available_cards() -> Array[String]:
	var out: Array[String] = []
	for cid: String in X.CHART_CARDS.keys():
		var src: String = X.CHART_CARDS[cid][1]
		if state.docs.has(src):
			out.append(cid)
	return out


func _open_chart() -> void:
	app._open_modal()
	_chart = ChartPanel.new()
	app.ui.add_child(_chart)
	_chart.build(X.CHART_SLOTS, X.CHART_CARDS, _available_cards(), _solved, app.ui.text_size)
	_chart.placed.connect(_on_chart_placed)
	_chart.closed.connect(_close_chart)
	var missing := _available_cards().size() < 6
	_chart.say("Faltam fichas: leia o que está sobre a mesa." if missing else "Escolha uma ficha para cada posição.")


func _close_chart() -> void:
	if _chart:
		_chart.queue_free()
		_chart = null
	app._resume()
	if state.has_fact("chart_complete"):
		_think(X.THOUGHTS["refuse"], 5.0)
		_after(5.0, func() -> void:
			app.show_dialog("Tio Walter", X.WALTER_CHART_DONE, ["Quero ver."], func(_j: int) -> void: _go("vault", "cp08_vault")))


func _on_chart_placed(slot_id: String, card_id: String, _c: bool) -> void:
	var expected := ""
	for s: Array in X.CHART_SLOTS:
		if s[0] == slot_id:
			expected = s[2]
	if card_id == expected:
		_solved[slot_id] = card_id
		_chart.confirm(slot_id)
		if slot_id == "slot_question":
			state.set_fact("chart_question")
			_note(X.NOTES["question"])
			_chart.say("Seria Obed Marsh meu tataravô? Isto não é um fato — é uma pergunta.")
		else:
			_chart.say("Encaixa.")
	else:
		_chart.reject(slot_id)
		_chart.say("Não se encaixa: isso não diz respeito a esta pessoa.")
	var done := true
	for s2: Array in X.CHART_SLOTS:
		if s2[0] != "slot_question" and not _solved.has(s2[0]):
			done = false
	if done and state.set_fact("chart_complete"):
		_note(X.NOTES["chart"])
		_chart.say("O quadro está completo. Ainda resta uma posição sem nome — se eu ousar.")


func _vault_line(step: int) -> void:
	if step == 1:
		_jewels[0].visible = true
		_jewels[1].visible = true
		_jewels[2].visible = true
	if step >= X.VAULT_LINES.size():
		_tiara()
		return
	var line: Array = X.VAULT_LINES[step]
	app.show_dialog(line[0], line[1], line[2], func(_j: int) -> void: _vault_line(step + 1))


func _tiara() -> void:
	## evt_vault_tiara [C]: desmaio silencioso — o som simplesmente cessa.
	_jewels[3].visible = true
	player.controls_enabled = false
	player.set_view(0.0, -0.55)
	await get_tree().create_timer(1.6, false).timeout
	AudioServer.set_bus_mute(0, true)
	await app.ui.fade_to(1.0, 2.5).finished
	state.set_fact("tiara_fainted")
	_note(X.NOTES["vault"])
	await get_tree().create_timer(1.5, false).timeout
	AudioServer.set_bus_mute(0, false)
	if not is_inside_tree():
		return
	app.ui.chapter_card(X.CARDS["years"], 4.5)
	await get_tree().create_timer(4.5, false).timeout
	app.save_checkpoint("cp08_dreams")
	_enter("night")
	app.ui.chapter_card(X.CARDS["dreams"], 3.5)
	player.controls_enabled = true
	app.ui.fade_to(0.0, 1.5)


func _sleep() -> void:
	_night += 1
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 1.0).finished
	match _night:
		1:
			_enter_dream(1)
		2:
			_enter_dream(2)
		_:
			_enter_palace()
	player.controls_enabled = true
	app.ui.fade_to(0.0, 1.5)


func _enter_dream(n: int) -> void:
	_set_phase("dream%d" % n)
	_env_underwater(Color(0.10, 0.30, 0.30), 0.035)
	_spawn(DREAM + Vector3(0, 0.05, 2), 0.0)
	_dream_t = 0.0
	_dream_goal = DREAM + Vector3(0, 0, -86 if n == 2 else -45)
	if n == 2:
		for k in 6:
			var d := WorldKit.deep_one(_world, DREAM + Vector3(-4 + (k % 3) * 4, 0, -6 - floorf(k / 3.0) * 5), "tiara" if k == 1 else "plain", 300 + k)
			d.rotation.y = 0.0
			_dream_figs.append(d)
		_hands = Node3D.new()
		player.camera.add_child(_hands)
		for sx: float in [-0.32, 0.32]:
			var h := WorldKit.box(_hands, Vector3(sx, -0.34, -0.55), Vector3(0.14, 0.04, 0.2), TexFactory.flat(Color(0.32, 0.42, 0.36)), false)
			h.rotation.x = -0.4
			WorldKit.box(h, Vector3(0, 0, -0.12), Vector3(0.18, 0.01, 0.1), TexFactory.flat(Color(0.25, 0.38, 0.32)), false)
		_after(4.0, func() -> void: _think(X.THOUGHTS["hands_dream"], 5.0))
	_update_ambience()


func _wake(n: int) -> void:
	_dream_t = -1.0
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 1.2).finished
	if not is_inside_tree():
		return
	for d in _dream_figs:
		d.queue_free()
	_dream_figs.clear()
	if _hands:
		_hands.queue_free()
		_hands = null
	state.set_fact("dream%d_done" % n)
	_enter("night")
	_spawn(ROOM + Vector3(-1.0, 0.05, 0.6), PI / 2)
	player.controls_enabled = true
	app.ui.fade_to(0.0, 1.0)
	match n:
		1:
			_think(X.THOUGHTS["wake1"], 5.0)
			_note(X.NOTES["dreams"])
		2:
			_think(X.THOUGHTS["wake2"], 4.0)
			state.add_doc("doc_dream_notes")
			var dad := WorldKit.figure(_world, ROOM + Vector3(0, 0, 2.3), 1.78, false, false, "man")
			dad.rotation.y = PI
			app.play_sound("sfx_creak", ROOM + Vector3(0, 1.0, 2.4))
			_after(1.0, func() -> void: _think(X.THOUGHTS["father"], 5.0))
			_after(6.0, func() -> void: dad.queue_free())


func _enter_palace() -> void:
	_set_phase("dream3")
	_env_underwater(Color(0.08, 0.26, 0.26), 0.02)
	_spawn(PALACE + Vector3(0, 0.05, 4), 0.0)
	_update_ambience()


func _grandmother(step: int) -> void:
	if step >= X.DREAM_GRANDMOTHER.size():
		_shoggoth_wake()
		return
	var line: Array = X.DREAM_GRANDMOTHER[step]
	app.show_dialog(line[0], line[1], line[2], func(_j: int) -> void: _grandmother(step + 1))


func _shoggoth_wake() -> void:
	## Primeiro shoggoth: o susto que acorda o narrador gritando [C].
	_shoggoth.visible = true
	player.controls_enabled = false
	var tw := create_tween()
	tw.tween_property(_shoggoth, "position", player.global_position + Vector3(-2, 1, -4), 2.2)
	app.play_sound("sfx_croak_low", player.global_position + Vector3(-3, 1, -5), 4.0, 0.5)
	for k in 4:
		_after(k * 0.4, func() -> void: app.play_sound("sfx_croak", player.global_position + Vector3(-3, 1, -5), 2.0, 0.6))
	await tw.finished
	if not is_inside_tree():
		return
	app.ui.fade_to(1.0, 0.15)
	_caption("um grito — o seu", 3.0)
	await get_tree().create_timer(1.5, false).timeout
	_shoggoth.visible = false
	state.set_fact("dream3_done")
	_enter("night")
	_set_phase("mirror")
	_mirror_cloth.visible = false
	_reflection.visible = true
	_spawn(ROOM + Vector3(-1.0, 0.05, 0.6), PI / 2)
	player.controls_enabled = true
	_think(X.THOUGHTS["wake3"], 4.0)
	app.ui.fade_to(0.0, 1.0)


func _write_final() -> void:
	if not state.has_fact("plan_written"):
		state.set_fact("plan_written")
		_open_doc("doc_canton_plan")
		return
	_think(X.THOUGHTS["sign"], 2.0)
	_final_descent()


func _final_descent() -> void:
	## evt_final_descent [O simbólico]: a tinta escorre como água; nada até o recife; a descida.
	player.controls_enabled = false
	await app.ui.fade_to(1.0, 2.0).finished
	if not is_inside_tree():
		return
	state.set_fact("final_seen")
	_set_phase("swim")
	_env_sea_night()
	player.set_physics_process(false)
	player.global_position = SEA + Vector3(0, 0.25, 0)
	player.set_view(0.0, 0.0)
	_swim_t = 0.0
	player.look_enabled = true
	app.ui.set_status("Segure [%s] para nadar" % InputSetup.key_name(app._key_for("move_forward")))
	app.ui.fade_to(0.0, 2.0)
	_update_ambience()


func _start_descent() -> void:
	_descent = true
	_set_phase("descent")
	app.ui.set_status("")
	_env_underwater(Color(0.02, 0.06, 0.07), 0.02)
	var tw := create_tween()
	tw.tween_property(player, "global_position", Vector3(player.global_position.x, -70.0, _reef_z - 30.0), 16.0).set_trans(Tween.TRANS_SINE)
	for k in X.DESCENT_LINES.size():
		var line: String = X.DESCENT_LINES[k]
		_after(1.0 + k * 5.0, func() -> void: app.ui.chapter_card(line, 4.8))
	await tw.finished
	if not is_inside_tree():
		return
	# Antes do contato, a imagem se dissolve no papel (docs/04 §10).
	var white := ColorRect.new()
	white.color = Color(0.92, 0.89, 0.80, 0.0)
	white.set_anchors_preset(Control.PRESET_FULL_RECT)
	white.mouse_filter = Control.MOUSE_FILTER_IGNORE
	app.ui.add_child(white)
	var t2 := create_tween()
	t2.tween_property(white, "color:a", 1.0, 3.0)
	await t2.finished
	state.set_fact("ch08_done")
	_note("Fim do manuscrito.")
	await get_tree().create_timer(1.5, false).timeout
	white.queue_free()
	player.set_physics_process(true)
	app.save_checkpoint("cp08_final")
	finished.emit()


# ================================================================ laço

func _physics_process(delta: float) -> void:
	if player == null or capture_mode:
		return
	if phase == "rain":
		_rain.global_position = player.global_position + Vector3(0, 8, 0)
	if _dream_t >= 0.0:
		_dream_t += delta
		for d in _dream_figs:
			d.position.z -= delta * 1.2
			d.position.y = absf(sin(_dream_t * 3.0 + d.position.x)) * 0.2
		var reached := Vector2(player.global_position.x - _dream_goal.x, player.global_position.z - _dream_goal.z).length() < 4.0
		var n := 1 if phase == "dream1" else 2
		if reached or _dream_t > (50.0 if n == 1 else 70.0):
			_wake(n)
	for f in _fish:
		var node: MeshInstance3D = f["node"]
		f["phase"] = float(f["phase"]) + delta
		node.position.x += sin(float(f["phase"])) * delta * float(f["speed"])
		node.position.z -= delta * float(f["speed"]) * 0.6
		if node.position.z < DREAM.z - 95.0:
			node.position.z = DREAM.z + 5.0
	if phase in ["mirror", "final"]:
		_update_reflection()
	if phase == "swim":
		_swim(delta)


func _update_reflection() -> void:
	## Reflexo espelhado pelo plano do espelho (z = ROOM.z − 2.5).
	var p := player.global_position
	var plane := ROOM.z - 2.5
	_reflection.global_position = Vector3(p.x, p.y, plane - (p.z - plane))
	_reflection.rotation.y = PI - player.rotation.y
	var near := p.distance_to(ROOM + Vector3(0, 0, -2.5)) < 1.8
	var facing := -player.camera.global_basis.z.dot(Vector3(0, 0, -1)) > 0.8
	if phase == "mirror" and near and facing and state.set_fact("mirror_seen"):
		# evt_mirror_look: nenhuma narração além do registro no Diário.
		_note(X.NOTES["mirror"])
		_after(4.0, func() -> void:
			app.save_checkpoint("cp08_final")
			_set_phase("final")
			_card("final"))


func _swim(delta: float) -> void:
	_swim_t += delta
	var fwd := -player.camera.global_basis.z
	fwd.y = 0
	if fwd.length() > 0.01 and Input.is_action_pressed("move_forward"):
		player.global_position += fwd.normalized() * 1.8 * delta
	player.global_position.y = SEA.y + 0.25 + sin(_swim_t * 1.6) * 0.08
	if player.global_position.z < _reef_z + 6.0 and not _descent:
		_start_descent()


func debug_event(id: String) -> void:
	## Só para capturas de QA (--capture --event=…).
	match id:
		"vault":
			for j in _jewels:
				j.visible = true
			player.set_view(0.0, -0.5)
		"dream2":
			_enter_dream(2)
		"palace":
			_enter_palace()
			_shoggoth.visible = true
		"mirror":
			_enter("night")
			_set_phase("mirror")
			_mirror_cloth.visible = false
			_reflection.visible = true
			_spawn(ROOM + Vector3(0, 0.05, -1.4), 0.0)
			_update_reflection()
		"chart":
			for d: String in ["doc_photo_eliza", "doc_photo_douglas", "doc_orne_letters", "doc_peabody_notes"]:
				state.add_doc(d)
			_open_chart()
		"swim":
			_final_descent_static()


func _final_descent_static() -> void:
	_set_phase("swim")
	_env_sea_night()
	player.set_physics_process(false)
	player.global_position = SEA + Vector3(0, 0.25, -40)
	player.set_view(0.0, 0.0)
