class_name SettingsStore
extends RefCounted
## Preferências do jogador (sys_settings). Esquema 1, somente primitivos.

const PATH := "user://settings.json"
const SCHEMA := 1

const DEFAULTS: Dictionary = {
	"master_volume": 0.8,
	"ambience_volume": 1.0,
	"effects_volume": 1.0,
	"mouse_sensitivity": 0.12,
	"fov": 75.0,
	"invert_y": false,
	"text_size": 22,
	"internal_height": 240,
	"dither": true,
	"retro_strength": 1.0,
	"brightness": 1.0,
	"fullscreen": false,
	"vsync": true,
	"center_dot": true,
	"subtitle_bg": 0.78,
	"head_bob": false,
	"assisted_escape": false,
	"hold_instead_of_mash": false,
	"toggle_crouch": false,
	"sound_captions": true,
	"street_names": false,
	"content_warning_seen": false,
	"keys": {},
	"chapters_unlocked": ["cp00_frame"],
}

const LIMITS: Dictionary = {
	"master_volume": [0.0, 1.0],
	"ambience_volume": [0.0, 1.0],
	"effects_volume": [0.0, 1.0],
	"mouse_sensitivity": [0.03, 0.4],
	"fov": [60.0, 100.0],
	"text_size": [16, 36],
	"retro_strength": [0.0, 1.0],
	"brightness": [0.6, 1.6],
	"subtitle_bg": [0.0, 1.0],
}

## Inícios de capítulo que o menu "Escolher capítulo" pode liberar (allowlist do progresso).
const CHAPTER_IDS: Array[String] = [
	"cp00_frame", "cp02_bus_ride", "cp03_grocery", "cp04_wharf",
	"cp05_return", "cp06_knock", "cp07_washington", "cp08_rain",
]

var values: Dictionary = DEFAULTS.duplicate(true)


func load_from_disk() -> void:
	values = DEFAULTS.duplicate(true)
	if not FileAccess.file_exists(PATH):
		return
	var text := FileAccess.get_file_as_string(PATH)
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var data: Dictionary = parsed
	if int(data.get("schema", -1)) != SCHEMA:
		return
	var src: Variant = data.get("values", {})
	if typeof(src) != TYPE_DICTIONARY:
		return
	values = sanitize(src)


static func sanitize(src: Dictionary) -> Dictionary:
	var out: Dictionary = DEFAULTS.duplicate(true)
	for key: String in DEFAULTS.keys():
		if not src.has(key):
			continue
		var def: Variant = DEFAULTS[key]
		var v: Variant = src[key]
		match typeof(def):
			TYPE_BOOL:
				if typeof(v) == TYPE_BOOL:
					out[key] = v
			TYPE_FLOAT:
				if typeof(v) == TYPE_FLOAT or typeof(v) == TYPE_INT:
					out[key] = clampf(float(v), LIMITS[key][0], LIMITS[key][1])
			TYPE_INT:
				if typeof(v) == TYPE_FLOAT or typeof(v) == TYPE_INT:
					if key == "internal_height":
						out[key] = 360 if int(v) == 360 else 240
					else:
						out[key] = clampi(int(v), LIMITS[key][0], LIMITS[key][1])
			TYPE_DICTIONARY:
				if typeof(v) == TYPE_DICTIONARY:
					var keys: Dictionary = {}
					for action: Variant in v.keys():
						if typeof(action) == TYPE_STRING and InputSetup.ACTIONS.has(action):
							var code: Variant = v[action]
							if typeof(code) == TYPE_FLOAT or typeof(code) == TYPE_INT:
								keys[action] = int(code)
					out[key] = keys
			TYPE_ARRAY:
				if typeof(v) == TYPE_ARRAY:
					var ids: Array = ["cp00_frame"]
					for id: Variant in v:
						if typeof(id) == TYPE_STRING and CHAPTER_IDS.has(id) and not ids.has(id):
							ids.append(id)
					out[key] = ids
	return out


static func chapter_start_for(cp: String) -> String:
	## Início de capítulo (CHAPTER_IDS) que contém o checkpoint `cp`; "" se nenhum.
	if cp.begins_with("cp01"):
		return "cp00_frame"
	for id: String in CHAPTER_IDS:
		if cp.substr(0, 4) == id.substr(0, 4):
			return id
	return ""


func save_to_disk() -> void:
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	if f == null:
		push_warning("Não foi possível gravar configurações.")
		return
	f.store_string(JSON.stringify({"schema": SCHEMA, "values": values}, "\t"))


func get_value(key: String) -> Variant:
	return values.get(key, DEFAULTS.get(key))


func set_value(key: String, v: Variant) -> void:
	var probe: Dictionary = values.duplicate(true)
	probe[key] = v
	values = sanitize(probe)
