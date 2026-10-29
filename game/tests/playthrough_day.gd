extends SceneTree
## Jogada automatizada de ch00_frame a ch04_zadok, até o início de ch05 (integração).
## Uso: Godot --headless --path game --script res://tests/playthrough_day.gd
## Não valida imagem, som, input físico nem sensação de jogo.

const SPEED := 6.0

const REC = preload("res://tests/recorder.gd")

var app: AppRoot
var rec = null
var _fails := 0
var _count := 0


func _initialize() -> void:
	Engine.time_scale = SPEED
	app = load("res://main.tscn").instantiate()
	root.add_child(app)
	var rec_dir: String = REC.wanted()
	if rec_dir != "" and DisplayServer.get_name() != "headless":
		rec = REC.new()
		rec.setup(app, "dia", rec_dir)
		root.add_child(rec)
	_run.call_deferred()


func check(cond: bool, label: String) -> void:
	_count += 1
	if cond:
		print("  ok   ", label)
	else:
		_fails += 1
		print("  FALHA ", label)


func wait(game_seconds: float) -> void:
	await create_timer(game_seconds).timeout


func ch() -> ChapterBase:
	return app.chapter


func use(id: String) -> bool:
	var t: Interactable = ch().inter.get(id, null)
	if t == null or t.get_prompt() == "":
		check(false, "interação disponível: %s (fase %s)" % [id, ch().phase])
		return false
	ch()._on_interact(t)
	return true


func choose(i: int = 0) -> void:
	await wait(0.3)
	app._on_dialog_choice(i)


func close_doc() -> void:
	await wait(0.3)
	app.ui.close_document()
	await wait(0.2)


func at(pos: Vector3, yaw: float = 0.0) -> void:
	ch()._spawn(pos, yaw)
	await wait(0.4)


func wait_until(cond: Callable, max_seconds: float) -> bool:
	var t := 0.0
	while t < max_seconds:
		if cond.call():
			return true
		await wait(0.5)
		t += 0.5
	return bool(cond.call())


func _run() -> void:
	await wait(0.5)
	print("Moldura e capítulo I")
	app._new_game()
	await wait(0.6)
	check(ch() is NewburyportChapter and ch().phase == "frame", "Nova partida começa na escrivaninha de Toledo")
	use("manuscript0")
	await close_doc()
	check(ch().state.docs.has("doc_manuscript"), "a primeira página do manuscrito")
	use("manuscript0")
	await wait(2.5)
	check(ch().phase == "station" and app.state.checkpoint == "cp01_station", "Newburyport: a bilheteria")
	check((ch().inter["station_door"] as Interactable).get_prompt() == "", "sem perguntar ao bilheteiro, a porta não é oferecida")
	use("agent")
	await choose(0)
	await choose(0)
	await choose(1)
	await choose(0)
	await choose(3)
	check(ch().state.has_fact("agent_bus") and ch().state.docs.has("doc_bus_timetable"), "o ônibus de Innsmouth e os horários")
	use("station_door")
	await wait(2.5)
	use("local_0")
	await wait(3.5)
	check(ch().state.has_fact("no_talk"), "ninguém quer falar de Innsmouth")
	use("library_door")
	await wait(2.5)
	check(ch().phase == "library", "a biblioteca")
	use("essex_book")
	await close_doc()
	use("jewellery_ref")
	await close_doc()
	use("librarian")
	await choose(0)
	await wait(2.5)
	check(ch().state.docs.has("doc_intro_note") and ch().phase == "street", "bilhete para a Srta. Tilton")
	use("society_door")
	await wait(2.5)
	check(ch().phase == "society" and app.state.checkpoint == "cp01_society", "a Sociedade Histórica")
	use("tiara_case")
	await wait_until(func() -> bool: return ch().state.has_fact("tiara_seen"), 25.0)
	check(ch().state.has_fact("tiara_seen"), "a tiara (evt_tiara_reveal)")
	use("tiara_label")
	await close_doc()
	use("tilton")
	for i in 3:
		await choose(0)
	check(ch().state.has_fact("tilton_done"), "a Srta. Tilton: 1873, os Marsh, a Ordem de Dagon")
	use("archive")
	await close_doc()
	use("society_exit")
	await wait_until(func() -> bool: return ch().phase == "morning", 20.0)
	check(app.state.checkpoint == "cp01_bus_stop", "Y.M.C.A.; manhã diante da Hammond's")
	await wait_until(func() -> bool: return (ch() as NewburyportChapter)._bus_ready, 40.0)
	check(ch().state.has_fact("avoidance_seen"), "os ociosos se afastam do ônibus")
	use("bus_door")
	await choose(0)
	await wait_until(func() -> bool: return ch() is DayChapter, 10.0)
	check(ch() is DayChapter and ch().phase == "bus" and ch().state.has_fact("sargent_paid"), "Sargent devolve o troco sem falar; a viagem começa")

	print("Capítulo II")
	await wait_until(func() -> bool: return ch().phase == "square", 200.0)
	check(ch().state.has_fact("crest_seen") and ch().state.has_fact("priest_seen"), "a crista, Devil Reef, o sino das onze e o padre no porão")
	check(app.state.checkpoint == "cp02_square", "a praça de Innsmouth; grava cp02_square")
	await at(Vector3(7.2, 0.05, -2), PI / 2)
	use("gilman_door")
	await wait(1.2)
	use("day_clerk")
	await choose(0)
	check(ch().state.has_fact("valise_checked"), "a valise fica no Gilman")
	use("register_day")
	await close_doc()
	use("lobby_exit")
	await wait(1.2)
	check(ch().phase == "square", "de volta à praça")
	await at(Vector3(42, 0.05, 10.5), PI)
	use("grocery_door")
	await wait(1.2)
	check(ch().phase == "grocery", "a mercearia First National")
	use("grocery_boy")
	await choose(0)
	for i2 in 6:
		await choose(i2)
		await choose(0)
	await choose(6)
	await choose(0)
	await choose(6)
	check(ch().state.has_fact("map_received") and ch().state.has_item("item_crackers") and ch().state.has_fact("grocery_zadok"), "o rapaz conta tudo, desenha o mapa; bolachas")
	use("grocery_exit")
	await wait(1.5)
	check(ch().phase == "tour" and app.state.checkpoint == "cp03_grocery", "III: o passeio; grava cp03_grocery")

	print("Capítulo III")
	await at(Vector3(72, 0.05, -48))
	await at(Vector3(130, 0.05, 20))
	await at(Vector3(-68, 0.05, -110))
	await at(Vector3(136, 0.05, -62))
	await wait(1.5)
	var d := ch() as DayChapter
	check(d._visits >= 4 and ch().state.has_fact("woman_seen"), "refinaria, orla sul, ruas antigas, norte do rio; a mulher fecha a veneziana")
	check(ch().state.has_fact("zadok_present"), "depois de três regiões, Zadok aparece no quartel")
	await at(Vector3(-23, 0.05, -18), PI)
	check(ch().phase == "zadok_seen" and ch().state.has_fact("zadok_sighted"), "Zadok Allen, no banco do quartel")
	await at(Vector3(16, 0.05, 32), -PI / 2)
	use("variety_door")
	await wait(1.2)
	use("seller")
	await choose(0)
	check(ch().state.has_item("item_whiskey") and app.state.checkpoint == "cp03_whiskey", "a garrafa de uísque; grava cp03_whiskey")
	use("variety_exit")
	await wait(1.2)
	check(ch().phase == "lure", "volta à rua para atrair Zadok")
	await at(Vector3(8, 0.05, -11.5), PI)
	use("zadok")
	check(ch().phase == "walk", "Zadok segue a garrafa")
	for p: Vector3 in [Vector3(30, 0.05, 2), Vector3(60, 0.05, 4), Vector3(102, 0.05, 6), Vector3(136, 0.05, 30), Vector3(152, 0.05, 70)]:
		await at(p, -PI / 2)
		await wait(4.0)
	await wait_until(func() -> bool: return ch().phase == "wharf", 15.0)
	check(ch().phase == "wharf" and app.state.checkpoint == "cp04_wharf", "IV: o cais; grava cp04_wharf")

	print("Capítulo IV")
	await wait_until(func() -> bool: return d._stall, 60.0)
	check(d._stall and d._move == 0, "Zadok trava depois da conversa do dia")
	use("zadok")
	await choose(0)
	await wait(2.0)
	use("zadok")
	await wait(0.5)
	check(d._early_offers == 1 and d._move == 1, "oferecer enquanto ele fala só pede calma")
	for m in 2:
		await wait_until(func() -> bool: return d._stall, 90.0)
		use("zadok")
		if m == 0:
			await choose(1)
			await wait(2.0)
			check(d._heard_topics.size() == 1, "um tema liberado pelas pistas enriquece o relato")
			use("zadok")
		await choose(0)
	await wait_until(func() -> bool: return d._move >= 4, 120.0)
	check(d._move >= 4, "depois do 4º movimento a garrafa acaba e ele segue sozinho")
	await wait_until(func() -> bool: return ch().phase == "after", 400.0)
	check(ch().state.has_fact("zadok_fled") and ch().state.docs.has("doc_zadok_record"), "o grito, a ondulação, a fuga de Zadok")
	var notes: Array = ch().notes
	check(notes.has(DayText.NOTES["jrn_obed_daughter"]) and notes.has(DayText.NOTES["jrn_obed_eyes"]), "as duas pistas para o capítulo VIII ficam no Diário")
	await at(Vector3(138, 0.05, 60), PI / 2)
	await wait_until(func() -> bool: return ch() is GilmanChapter, 30.0)
	check(ch() is GilmanChapter and ch().phase == "square" and app.state.checkpoint == "cp05_return", "V: 19h15 — a praça ao crepúsculo, sem voltar ao menu")

	print("Escolher capítulo")
	app.start_from("cp07_washington")
	await wait(0.8)
	check(ch() is NightChapter and ch().state.has_item("item_flashlight"), "começar pelo capítulo VII concede a lanterna")
	app.start_from("cp03_grocery")
	await wait(0.8)
	check(ch() is DayChapter and ch().phase == "tour" and ch().state.has_item("item_sketch_map"), "começar pelo capítulo III já com o mapa")

	app.saves.delete_all()
	print("\n%d verificações, %d falhas" % [_count, _fails])
	if rec:
		rec.finish()
	quit(1 if _fails > 0 else 0)
