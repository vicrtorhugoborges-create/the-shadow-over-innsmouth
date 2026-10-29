extends SceneTree
## Jogada automatizada de ch08_inheritance: do despertar na chuva à cena final simbólica.
## Uso: Godot --headless --path game --script res://tests/playthrough_heritage.gd
## Não valida imagem, som, input físico nem sensação de jogo.

const SPEED := 6.0

const REC = preload("res://tests/recorder.gd")

var app: AppRoot
var rec = null
var _fails := 0
var _count := 0
var _finished := false


func _initialize() -> void:
	Engine.time_scale = SPEED
	app = load("res://main.tscn").instantiate()
	root.add_child(app)
	var rec_dir: String = REC.wanted()
	if rec_dir != "" and DisplayServer.get_name() != "headless":
		rec = REC.new()
		rec.setup(app, "heranca", rec_dir)
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


func ch() -> InheritanceChapter:
	return app.chapter as InheritanceChapter


func use(id: String) -> bool:
	var t: Interactable = ch().inter.get(id, null)
	if t == null or t.get_prompt() == "":
		check(false, "interação disponível: %s" % id)
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
	print("Capítulo VIII")
	var s := StoryState.new()
	s.give_item("item_sketch_map")
	s.add_doc("doc_zadok_record")
	s.set_checkpoint("cp08_rain")
	app.saves.save_state(s)
	app._retry()
	await wait(0.6)
	var c := ch()
	c.finished.connect(func() -> void: _finished = true)
	check(c != null and c.phase == "rain", "8a: desperta no corte, sob a chuva")
	use("rowley_sign")
	await wait(0.3)
	check(c.phase == "rain", "a placa de Rowley espera o exame da lama")
	use("mud")
	await wait(0.3)
	check(c.state.has_fact("no_prints_seen"), "lama fresca sem nenhuma pegada")
	use("rowley_sign")
	await wait(2.5)
	check(c.phase == "interview" and app.state.checkpoint == "cp08_arkham", "8b: Arkham; grava cp08_arkham")

	use("officer")
	for i in 4:
		await choose(0)
		await wait(0.6)
	check(c.state.has_fact("told_zadok") and c.state.has_fact("told_procession"), "relata as quatro partes na ordem escolhida")
	await choose(0)
	await wait(2.5)
	check(c.state.has_fact("testimony_done") and c.phase == "society", "fim do depoimento; Sociedade Histórica")
	use("peabody")
	for i2 in 6:
		await choose(0)
	await wait(0.4)
	check(c.state.has_fact("marsh_eyes_heard") and c.state.has_item("item_peabody_notes") and c.state.docs.has("doc_peabody_notes"), "Peabody: a noiva Marsh e os olhos Marsh; notas nos Bolsos")
	use("museum_plaque")
	use("society_door")
	await wait(2.5)
	check(c.phase == "oberlin", "8c: Oberlin")
	use("clippings")
	await close_doc()
	await wait(8.0)
	check(c.state.has_fact("clippings_read") and c.phase == "cleveland" and app.state.checkpoint == "cp08_cleveland", "recortes lidos; batida à porta; 8d Cleveland")

	use("walter")
	await choose(0)
	for id: String in ["photo_eliza", "photo_douglas", "letters", "miniature"]:
		use(id)
		await close_doc()
	use("photo_eliza")
	await close_doc()
	check(c.state.has_fact("photo_shift_seen"), "ao rever a foto, o rosto sugere algo (evt_photo_shift)")
	use("chart")
	await wait(0.3)
	check(c._chart != null and app.mode == "modal", "quadro genealógico aberto (jogo pausado)")
	c._on_chart_placed("slot_eliza", "c_douglas", false)
	check(not c._solved.has("slot_eliza"), "ficha errada não encaixa")
	for pair: Array in [["slot_eliza", "c_eliza"], ["slot_douglas", "c_douglas"], ["slot_walter", "c_walter"], ["slot_benjamin", "c_benjamin"], ["slot_bride", "c_bride"], ["slot_parents", "c_parents"]]:
		c._on_chart_placed(pair[0], pair[1], false)
	check(c.state.has_fact("chart_complete") and not c.state.has_fact("chart_question"), "quadro completo sem a posição opcional")
	c._on_chart_placed("slot_question", "c_zadok", false)
	check(c.state.has_fact("chart_question"), "a posição '?' registra uma pergunta, não um fato")
	c._close_chart()
	await wait(6.0)
	await choose(0)
	await wait(2.5)
	check(c.phase == "vault" and app.state.checkpoint == "cp08_vault", "8e: o cofre; grava cp08_vault")
	use("governess_note")
	await close_doc()
	use("vault_walter")
	for i3 in 3:
		await choose(0)
	ok_wait("tiara: desmaio silencioso, dois anos, Toledo", func() -> bool: return c.phase == "night" and app.state.checkpoint == "cp08_dreams", 20.0)
	await wait_until(func() -> bool: return c.phase == "night", 20.0)
	check(not AudioServer.is_bus_mute(0), "o som volta depois do desmaio")

	use("bed_toledo")
	await wait(1.5)
	check(c.phase == "dream1", "1ª noite: o sonho submerso")
	c._spawn(InheritanceChapter.DREAM + Vector3(0, 0.05, -44), 0.0)
	await wait_until(func() -> bool: return c.phase == "night", 10.0)
	check(c.state.has_fact("dream1_done"), "acorda com horror")
	use("bed_toledo")
	await wait(1.5)
	check(c.phase == "dream2" and c._hands != null, "2ª noite: com eles, mãos com membranas")
	c._spawn(InheritanceChapter.DREAM + Vector3(0, 0.05, -85), 0.0)
	await wait_until(func() -> bool: return c.phase == "night", 10.0)
	check(c.state.has_fact("dream2_done") and c.state.docs.has("doc_dream_notes") and c._hands == null, "acorda; o pai à porta; notas dos sonhos")
	use("bed_toledo")
	await wait(1.5)
	check(c.phase == "dream3", "3ª noite: o palácio fosforescente")
	use("grandmother")
	for i4 in 4:
		await choose(0)
	await wait_until(func() -> bool: return c.phase == "mirror", 15.0)
	check(c.state.has_fact("dream3_done") and c.phase == "mirror", "a avó, Pth'thya-l'yi, o shoggoth; acorda gritando")
	c._spawn(InheritanceChapter.ROOM + Vector3(0, 0.05, -1.4), 0.0)
	await wait(5.0)
	check(c.state.has_fact("mirror_seen") and c.phase == "final" and app.state.checkpoint == "cp08_final", "o espelho; grava cp08_final")
	use("drawer")
	check(c.state.has_fact("drawer_seen") and not c.player.has_flashlight, "a gaveta só pode ser olhada (D-015)")
	use("manuscript")
	await close_doc()
	check(c.state.has_fact("plan_written"), "as últimas páginas: o plano de Canton")
	use("manuscript")
	await wait(3.0)
	check(c.phase == "swim", "8g: a tinta vira água; Devil Reef ao luar [O simbólico]")
	Input.action_press("move_forward")
	await wait_until(func() -> bool: return c.phase == "descent", 80.0)
	Input.action_release("move_forward")
	check(c.phase == "descent", "nada até o recife e começa a descida")
	await wait_until(func() -> bool: return _finished, 40.0)
	await wait(1.0)
	check(_finished and c.state.has_fact("ch08_done") and app.mode == "end", "fim do manuscrito; tela FIM")
	app._continue_game()
	await wait(0.5)
	check(app.mode == "end", "Continuar depois do fim não reinicia o capítulo em laço")

	app.saves.delete_all()
	print("\n%d verificações, %d falhas" % [_count, _fails])
	if rec:
		rec.finish()
	quit(1 if _fails > 0 else 0)


func ok_wait(label: String, cond: Callable, max_seconds: float) -> void:
	var ok := await wait_until(cond, max_seconds)
	check(ok, label)
