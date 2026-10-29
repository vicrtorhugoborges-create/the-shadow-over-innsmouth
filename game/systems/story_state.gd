class_name StoryState
extends RefCounted
## Estado de partida serializável (sys_story_state).
## Apenas fatos booleanos, itens e documentos de listas permitidas; checkpoint de lista permitida.
## Fatos únicos nunca voltam a falso: restaurar um checkpoint não repete concessões.

const CONTENT_ID := "innsmouth"

const ALLOWED_FACTS: Array[String] = [
	# ch05
	"breakdown_heard", "room_given", "dinner_done", "paper_bought",
	"room_entered", "missing_bolt_seen", "bolt_removed", "bolt_fitted",
	"hall_bolted", "north_bolted", "south_bolted", "lay_down",
	"key_in_lock_done", "connecting_tries_done", "power_cut_done",
	# ch06
	"window_examined", "south_hinge_read", "north_hinge_read",
	"bed_at_south", "bureau_at_hall", "map_consulted_room",
	"north_forced", "n1_bolted", "n2_bolted",
	"n2_bed", "n2_bureau", "n2_washstand", "n2_north_bolted", "n2_south_bolted",
	"drapery_down", "rope_ready", "roof_reached", "church_lights_seen",
	"attic_reached", "courtyard_reached", "wedged_door_seen", "crowd_seen",
	"shutter_closed", "washington_reached",
	# ch07
	"bates_passed", "reef_signals_seen", "swimmers_seen", "motor_heard", "railway_plan",
	"ipswich_party_seen", "rowboat_seen", "band_passed", "drunk_seen", "bank_reached",
	"bats_seen", "gap_jumped", "marsh_reached", "column_seen", "wind_shift_seen",
	"eyes_failed", "procession_seen", "ch07_done",
	# ch08
	"no_prints_seen", "told_zadok", "told_hotel", "told_signals", "told_procession", "testimony_done",
	"peabody_met", "marsh_eyes_heard", "museum_skipped", "clippings_read", "letter_read",
	"photos_eliza", "photos_douglas", "photo_shift_seen", "letters_read", "miniature_seen",
	"chart_complete", "chart_question", "governess_read", "tiara_fainted",
	"dream1_done", "dream2_done", "dream3_done", "mirror_seen", "drawer_seen", "plan_written",
	"final_seen", "ch08_done",
	# ch00–ch04
	"frame_written", "agent_bus", "agent_town", "agent_hotel", "no_talk", "essex_read",
	"jewellery_read", "intro_note", "tiara_seen", "tilton_done", "offers_read", "ymca_done",
	"avoidance_seen", "sargent_paid", "crest_seen", "priest_seen", "valise_checked", "grocery_met",
	"grocery_streets", "grocery_avoid", "grocery_churches", "grocery_people", "grocery_marsh",
	"grocery_zadok", "map_received", "tour_started", "grocery_hint", "visit_refinery",
	"visit_waterfront", "visit_north", "visit_patrician", "tract_read", "woman_seen",
	"order_watched", "washington_bridge", "zadok_present", "zadok_sighted", "hey_mister",
	"zadok_fled",
]

const ALLOWED_ITEMS: Array[String] = [
	"item_valise", "item_keyring_tool", "item_sketch_map", "item_watch",
	"item_flashlight", "item_crackers", "item_peabody_notes", "item_whiskey",
]

const ALLOWED_DOCS: Array[String] = [
	"doc_evening_paper", "doc_sketch_map", "doc_zadok_record", "doc_gilman_register",
	"doc_peabody_notes", "doc_raid_clippings", "doc_federal_letter", "doc_orne_letters",
	"doc_photo_eliza", "doc_photo_douglas", "doc_miniature", "doc_governess_note",
	"doc_family_chart", "doc_dream_notes", "doc_canton_plan",
	"doc_manuscript", "doc_bus_timetable", "doc_essex_history", "doc_jewellery_note",
	"doc_intro_note", "doc_tiara_label", "doc_marsh_offers", "doc_bridge_warning",
	"doc_order_notice", "doc_church_tract",
]

const ALLOWED_CHECKPOINTS: Array[String] = [
	"cp00_frame", "cp01_station", "cp01_library", "cp01_society", "cp01_bus_stop",
	"cp02_bus_ride", "cp02_square", "cp03_grocery", "cp03_whiskey", "cp04_wharf",
	"cp05_return", "cp05_room", "cp06_knock", "cp06_window", "cp06_roof",
	"cp06_courtyard", "cp07_washington", "cp07_south_crossing", "cp07_babson",
	"cp07_bank_street", "cp07_bridge", "cp07_cut", "cp08_rain", "cp08_arkham",
	"cp08_cleveland", "cp08_vault", "cp08_dreams", "cp08_final",
]

var checkpoint: String = "cp00_frame"
var facts: Dictionary = {}
var items: Array[String] = []
var docs: Array[String] = []


func has_fact(id: String) -> bool:
	return bool(facts.get(id, false))


func set_fact(id: String) -> bool:
	## Retorna true somente na primeira concessão.
	if not ALLOWED_FACTS.has(id):
		push_error("Fato não permitido: %s" % id)
		return false
	if has_fact(id):
		return false
	facts[id] = true
	return true


func has_item(id: String) -> bool:
	return items.has(id)


func give_item(id: String) -> bool:
	if not ALLOWED_ITEMS.has(id) or items.has(id):
		return false
	items.append(id)
	return true


func add_doc(id: String) -> bool:
	if not ALLOWED_DOCS.has(id) or docs.has(id):
		return false
	docs.append(id)
	return true


func set_checkpoint(id: String) -> void:
	if ALLOWED_CHECKPOINTS.has(id):
		checkpoint = id
	else:
		push_error("Checkpoint não permitido: %s" % id)


func to_dict() -> Dictionary:
	var f: Array[String] = []
	for k: String in facts.keys():
		if facts[k]:
			f.append(k)
	f.sort()
	return {
		"content_id": CONTENT_ID,
		"checkpoint": checkpoint,
		"facts": f,
		"items": items.duplicate(),
		"docs": docs.duplicate(),
	}


static func from_dict(d: Dictionary) -> StoryState:
	## Retorna null para dados inválidos. Ignora IDs fora das listas.
	if str(d.get("content_id", "")) != CONTENT_ID:
		return null
	var cp: Variant = d.get("checkpoint", "")
	if typeof(cp) != TYPE_STRING or not ALLOWED_CHECKPOINTS.has(cp):
		return null
	var s := StoryState.new()
	s.checkpoint = cp
	for key: String in ["facts", "items", "docs"]:
		var arr: Variant = d.get(key, [])
		if typeof(arr) != TYPE_ARRAY:
			return null
		for v: Variant in arr:
			if typeof(v) != TYPE_STRING:
				continue
			match key:
				"facts":
					if ALLOWED_FACTS.has(v):
						s.facts[v] = true
				"items":
					s.give_item(v)
				"docs":
					s.add_doc(v)
	return s


func duplicate_state() -> StoryState:
	return from_dict(to_dict())
