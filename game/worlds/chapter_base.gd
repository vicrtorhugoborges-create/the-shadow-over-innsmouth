class_name ChapterBase
extends Node3D
## Base comum dos capítulos jogáveis: composição do jogador, ambiente, interação,
## legendas, Diário e dicas. Cada capítulo define conteúdo e fluxo próprios.

signal failed(text: String)
signal finished

var app: AppRoot
var capture_mode := false
var player: Player
var state: StoryState

var phase := ""
var notes: Array[String] = []
var hint_levels: Dictionary = {}
var inter: Dictionary = {}
var busy := false
var hold_mode := false
var assisted := false

var _world: Node3D
var _env: Environment
var _sky: ProceduralSkyMaterial
var _sun: DirectionalLight3D
var _failed := false

var M_WALL: Material
var M_FLOOR: Material
var M_CEIL: Material
var M_WOOD: Material
var M_BRICK: Material
var M_SLATE: Material
var M_COBBLE: Material
var M_CLAP: Material
var M_PLASTER: Material
var M_DIRT: Material


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


# ---------------------------------------------------------------- pontos de extensão

func _objectives() -> Dictionary:
	return {}


func _hints() -> Dictionary:
	return {}


func _docs() -> Dictionary:
	return {}


func _journal_key() -> String:
	return phase


func _update_ambience() -> void:
	pass


func _apply_chapter_settings(_v: Dictionary) -> void:
	pass


# ---------------------------------------------------------------- composição

func apply_settings(v: Dictionary) -> void:
	hold_mode = bool(v.get("hold_instead_of_mash", false))
	assisted = bool(v.get("assisted_escape", false))
	if player:
		player.sensitivity = float(v.get("mouse_sensitivity", 0.12))
		player.invert_y = bool(v.get("invert_y", false))
		player.toggle_crouch = bool(v.get("toggle_crouch", false))
		player.head_bob = bool(v.get("head_bob", false))
		player.camera.fov = float(v.get("fov", 75.0))
	_apply_chapter_settings(v)


func _init_world() -> void:
	M_WALL = TexFactory.material("wallpaper", 1.6)
	M_FLOOR = TexFactory.material("wood_floor", 2.0)
	M_CEIL = TexFactory.material("plaster", 3.0)
	M_WOOD = TexFactory.material("wood_dark", 1.2)
	M_BRICK = TexFactory.material("brick", 2.5)
	M_SLATE = TexFactory.material("slate", 2.0)
	M_COBBLE = TexFactory.material("cobble", 2.5)
	M_CLAP = TexFactory.material("clapboard", 2.5)
	M_PLASTER = TexFactory.material("plaster", 2.0)
	M_DIRT = TexFactory.material("dirt", 3.0)
	_world = Node3D.new()
	add_child(_world)
	_build_environment()


func _make_player() -> void:
	player = Player.new()
	add_child(player)
	player.interact_requested.connect(_on_interact)
	player.footstep.connect(_on_footstep)
	apply_settings(app.settings.values)


func _build_environment() -> void:
	var we := WorldEnvironment.new()
	_env = Environment.new()
	_env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	_sky = ProceduralSkyMaterial.new()
	sky.sky_material = _sky
	_env.sky = sky
	_env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	_env.fog_enabled = true
	_env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	we.environment = _env
	_world.add_child(we)
	_sun = DirectionalLight3D.new()
	_sun.shadow_enabled = true
	_sun.directional_shadow_max_distance = 60.0
	_world.add_child(_sun)


func _set_night(fog_density: float = 0.016) -> void:
	## Perfil tod_moon_night (docs/14): lua quase cheia a sudoeste, ruas sem iluminação.
	_sky.sky_top_color = Color(0.015, 0.02, 0.04)
	_sky.sky_horizon_color = Color(0.07, 0.09, 0.14)
	_sky.ground_horizon_color = Color(0.04, 0.05, 0.07)
	_sky.ground_bottom_color = Color(0.01, 0.01, 0.02)
	_env.ambient_light_color = Color(0.17, 0.19, 0.27)
	_env.ambient_light_energy = 1.0
	_env.fog_light_color = Color(0.05, 0.06, 0.09)
	_env.fog_density = fog_density
	_sun.light_color = Color(0.62, 0.70, 0.95)
	_sun.light_energy = 0.75
	_aim_light(_sun, Vector3(1.0, -0.62, -0.9))


func _aim_light(l: DirectionalLight3D, dir: Vector3) -> void:
	l.basis = Basis.looking_at(dir.normalized(), Vector3.UP)


func _loop(id: String, db: float) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.stream = app.synth.get_stream(id)
	p.volume_db = db
	p.bus = &"Ambience"
	add_child(p)
	if not capture_mode:
		p.play()
	return p


func _loop3d(id: String, pos: Vector3, db: float, unit: float = 8.0) -> AudioStreamPlayer3D:
	var p := AudioStreamPlayer3D.new()
	p.stream = app.synth.get_stream(id)
	p.volume_db = db
	p.bus = &"Ambience"
	p.unit_size = unit
	p.max_distance = 200.0
	add_child(p)
	p.global_position = pos
	if not capture_mode:
		p.play()
	return p


func _fade_db(p: Node, db: float, seconds: float = 1.5) -> void:
	if p == null:
		return
	var t := create_tween()
	t.tween_property(p, "volume_db", db, seconds)


func _spawn(pos: Vector3, yaw: float) -> void:
	player.global_position = pos
	player.set_view(yaw, 0.0)
	player.velocity = Vector3.ZERO


# ---------------------------------------------------------------- interação

func _inter(id: String, pos: Vector3, size: Vector3, prompt: Callable, use: Callable, solid: bool = false) -> Interactable:
	var it := Interactable.new()
	it.setup(id, size, Vector3.ZERO, solid)
	it.position = pos
	it.prompt_provider = prompt
	it.on_use = use
	_world.add_child(it)
	inter[id] = it
	return it


func _on_interact(target: Interactable) -> void:
	if busy or _failed:
		return
	target.use()


func _on_footstep(_surface: String, loud: float) -> void:
	app.play_sound("sfx_step_stone", Vector3.INF, linear_to_db(0.12 + loud * 0.3), randf_range(0.9, 1.1))


func _timed(sec: float, snd: String, at: Vector3, cb: Callable) -> void:
	busy = true
	player.controls_enabled = false
	if snd != "":
		app.play_sound(snd, at)
	app.ui.set_status("…")
	await get_tree().create_timer(sec, false).timeout
	if not is_inside_tree() or _failed:
		return
	app.ui.set_status("")
	busy = false
	player.controls_enabled = true
	cb.call()


func _after(sec: float, cb: Callable) -> void:
	await get_tree().create_timer(sec, false).timeout
	if is_inside_tree() and not _failed:
		cb.call()


func _think(text: String, sec: float = 5.0) -> void:
	app.say(text, sec, "thought")


func _caption(text: String, sec: float = 4.0) -> void:
	app.say(text, sec, "sound")


func _see(text: String, sec: float = 4.0) -> void:
	## Descrição de algo visível: aparece mesmo com as legendas de som desligadas (docs/16 §5).
	app.say(text, sec, "action")


func _note(text: String) -> void:
	if not notes.has(text):
		notes.append(text)


func _set_phase(p: String) -> void:
	phase = p
	_update_ambience()


func _open_doc(id: String) -> void:
	state.add_doc(id)
	var d: Dictionary = _docs()[id]
	app.show_document(d["title"], d["body"])


func get_journal() -> Dictionary:
	var key := _journal_key()
	var docs: Array = []
	var all := _docs()
	for id: String in state.docs:
		if all.has(id):
			docs.append(all[id])
	var level := int(hint_levels.get(key, 0))
	var hints: Array = _hints().get(key, [])
	var hint_text := ""
	for i in level:
		hint_text += "Pista %d: %s\n" % [i + 1, hints[i]]
	return {
		"objective": _objectives().get(key, ""),
		"hint": hint_text.strip_edges(),
		"can_hint": level < hints.size(),
		"notes": notes,
		"docs": docs,
	}


func request_hint() -> void:
	var key := _journal_key()
	var hints: Array = _hints().get(key, [])
	hint_levels[key] = mini(int(hint_levels.get(key, 0)) + 1, hints.size())
