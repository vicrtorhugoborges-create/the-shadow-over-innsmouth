class_name SaveService
extends RefCounted
## Gravação por checkpoint (sys_save). JSON primitivo, schema_version, backup da versão anterior.
## Nunca carrega scripts, objetos ou caminhos vindos do arquivo.

const SCHEMA := 1
const DIR := "user://saves"

var slot: int = 1


func path() -> String:
	return "%s/slot%d.json" % [DIR, slot]


func backup_path() -> String:
	return path() + ".bak"


func has_save() -> bool:
	return load_state() != null


func save_state(state: StoryState) -> bool:
	DirAccess.make_dir_recursive_absolute(DIR)
	var p := path()
	if FileAccess.file_exists(p) and _read(p) != null:
		# Preserva a cópia anterior válida antes de sobrescrever.
		DirAccess.copy_absolute(p, backup_path())
	var tmp := p + ".tmp"
	var f := FileAccess.open(tmp, FileAccess.WRITE)
	if f == null:
		return false
	var payload := {"schema_version": SCHEMA, "state": state.to_dict()}
	f.store_string(JSON.stringify(payload, "\t"))
	f.close()
	if FileAccess.file_exists(p):
		DirAccess.remove_absolute(p)
	return DirAccess.rename_absolute(tmp, p) == OK


func load_state() -> StoryState:
	var s := _read(path())
	if s == null:
		s = _read(backup_path())
	return s


func load_reports_recovery() -> bool:
	## true quando o primário está corrompido e o backup foi usado.
	return _read(path()) == null and _read(backup_path()) != null


func delete_all() -> void:
	for p: String in [path(), backup_path()]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)


static func _read(p: String) -> StoryState:
	if not FileAccess.file_exists(p):
		return null
	var json := JSON.new()
	if json.parse(FileAccess.get_file_as_string(p)) != OK:
		return null
	if typeof(json.data) != TYPE_DICTIONARY:
		return null
	var d: Dictionary = json.data
	if int(d.get("schema_version", -1)) != SCHEMA:
		return null
	var st: Variant = d.get("state", null)
	if typeof(st) != TYPE_DICTIONARY:
		return null
	return StoryState.from_dict(st)
