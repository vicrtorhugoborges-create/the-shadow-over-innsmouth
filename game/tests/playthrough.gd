extends SceneTree
## Jogada automatizada da fatia vertical (integração): percorre a sequência canônica
## do capítulo IV com as mesmas interações do jogador e verifica falha + retomada.
## Uso: Godot --headless --path game --script res://tests/playthrough.gd
## Não valida imagem, som, input físico nem sensação de jogo.

const SPEED := 6.0

const REC = preload("res://tests/recorder.gd")

var app: AppRoot
var rec = null
var _fails := 0
var _count := 0
var _failed_text := ""
var _finished := false


func _initialize() -> void:
	Engine.time_scale = SPEED
	app = load("res://main.tscn").instantiate()
	root.add_child(app)
	var rec_dir: String = REC.wanted()
	if rec_dir != "" and DisplayServer.get_name() != "headless":
		rec = REC.new()
		rec.setup(app, "gilman", rec_dir)
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


func ch() -> GilmanChapter:
	return app.chapter


func find(id: String) -> Interactable:
	var c := ch()
	if c.inter.has(id):
		return c.inter[id]
	if c.doors.has(id):
		return c.doors[id]
	return c.pushables.get(id, null)


func use(id: String) -> bool:
	var t := find(id)
	var p := t.get_prompt() if t else ""
	if t == null or p == "":
		check(false, "interação disponível: %s" % id)
		return false
	ch()._on_interact(t)
	return true


func at(pos: Vector3, yaw: float = 0.0) -> void:
	ch()._spawn(pos, yaw)
	await wait(0.2)


func choose(i: int) -> void:
	await wait(0.1)
	app._on_dialog_choice(i)


func _hook() -> void:
	_failed_text = ""
	_finished = false
	ch().failed.connect(func(t: String) -> void: _failed_text = t)
	ch().finished.connect(func() -> void: _finished = true)


func _run() -> void:
	await wait(0.5)
	print("Jogada canônica")
	app.start_from("cp05_return")
	await wait(0.5)
	_hook()
	var c := ch()
	check(c.phase == "square", "começa na praça ao crepúsculo")
	use("gilman_door")
	await wait(0.3)
	check(c.phase == "square", "hotel exige ouvir Sargent primeiro")
	use("sargent")
	await choose(1)
	check(c.state.has_fact("breakdown_heard"), "Sargent anuncia o defeito")
	use("gilman_door")
	await wait(1.5)
	check(c.phase == "lobby", "entra no saguão")
	use("night_clerk")
	await choose(0)
	await choose(0)
	check(c.phase == "upstairs" and c.state.docs.has("doc_evening_paper"), "quarto 428, jantar e jornal")
	use("lobby_stairs")
	await wait(4.0)
	check(c.phase == "room" and app.state.checkpoint == "cp05_room", "sobe ao 428 e grava cp05_room")

	await at(Vector3(-1.5, 9.05, 2.0), PI / 2)
	use("bed_428")
	await wait(0.5)
	check(c.phase == "room" and not c.state.has_fact("lay_down"), "não deita sem os ferrolhos")
	use("hall_428")
	await wait(1.0)
	check(c.state.has_fact("missing_bolt_seen"), "fechar a porta revela o ferrolho ausente")
	use("wardrobe")
	await wait(3.2)
	check(c.state.has_fact("bolt_removed"), "desaparafusa o ferrolho do armário")
	use("hall_428")
	await wait(3.6)
	check(c.state.has_fact("bolt_fitted") and c.phase == "bed", "instala o ferrolho na porta")
	use("hall_428")
	use("c_428_n1")
	use("c_s1_428")
	use("valise")
	await wait(0.3)
	check(c.state.has_fact("hall_bolted") and c.state.has_fact("north_bolted") and c.state.has_fact("south_bolted"), "três ferrolhos corridos")
	check(c.player.has_flashlight, "lanterna no bolso")
	use("bed_428")
	await wait(46.0)
	check(c.state.has_fact("key_in_lock_done") and c.state.has_fact("connecting_tries_done"), "escuta: chave na fechadura e portas testadas")
	check(c.phase == "prepare", "levanta para preparar a fuga")
	await wait(3.0)
	check(c.state.has_fact("power_cut_done") and c.director.phase == SiegeDirector.Phase.S0_SILENCE, "luz cortada; diretor em S0")

	await at(Vector3(-1.5, 9.05, 2.0), PI)
	use("window_428_0")
	use("c_428_n1")
	use("c_s1_428")
	await wait(0.3)
	check(c.state.has_fact("north_hinge_read") and c.state.has_fact("south_hinge_read"), "lê as dobradiças das duas portas")
	use("c_428_n1")
	await wait(0.3)
	check(not c.state.has_fact("north_forced") and c._ram_hits == 0, "não arromba antes das batidas (barulho)")
	use("bed_428")
	await wait(2.8)
	use("bureau_428")
	await wait(2.8)
	check(c.state.has_fact("bed_at_south") and c.state.has_fact("bureau_at_hall"), "cama contra a porta sul, cômoda contra a do corredor")
	var waited := 0.0
	while c.director.phase == SiegeDirector.Phase.S0_SILENCE and waited < 200.0:
		await wait(1.0)
		waited += 1.0
	check(c.director.phase == SiegeDirector.Phase.S1_KNOCK and app.state.checkpoint == "cp06_knock", "batidas começam e gravam cp06_knock")
	for i in 5:
		use("c_428_n1")
		await wait(0.45)
	check(c.state.has_fact("north_forced") and c.phase == "n1", "arromba a porta norte com o ombro")

	await at(Vector3(-2.0, 9.05, -2.0), 0.0)
	use("hall_n1")
	check(c.state.has_fact("n1_bolted"), "tranca a porta do corredor de n1 a tempo")
	await wait(3.3)
	check(c.director.requires_hall_n2_push(), "chave-mestra na porta de n2")
	use("c_n1_n2")
	await wait(0.4)
	await at(Vector3(-2.0, 9.05, -6.0), 0.0)
	use("hall_n2")
	await wait(0.2)
	check(c.state.has_fact("n2_bolted") and c.phase == "barricade", "empurra e tranca a porta de n2")
	use("c_n2_n3")
	use("bed_n2")
	await wait(1.9)
	check(c.director.phase == SiegeDirector.Phase.S7_RAM and app.state.checkpoint == "cp06_window", "aríete começa após a barricada e grava cp06_window")
	use("c_n1_n2")
	use("bureau_n2")
	await wait(1.7)
	use("washstand_n2")
	await wait(1.5)
	check(c.state.has_fact("n2_bureau") and c.state.has_fact("n2_washstand"), "três barricadas")
	use("curtains")
	await wait(1.3)
	check(c.state.has_fact("drapery_down"), "derruba as cortinas")
	use("curtains")
	await wait(4.0)
	check(c.phase == "roof" and app.state.checkpoint == "cp06_roof" and _failed_text == "", "desce pela cortina sem ruptura")
	check(c.director.phase == SiegeDirector.Phase.ESCAPED, "cerco encerrado")

	await wait(1.0)
	check(c.player.global_position.y > 5.0, "jogador está sobre o telhado (não caiu)")
	use("skylight")
	await wait(1.5)
	check(c.phase == "attic", "desce pela claraboia ao sótão")
	await at(Vector3(-9.1, 0.95, -5.2), PI)
	use("paine_door")
	use("warehouse_back")
	await wait(0.5)
	check(c.phase == "courtyard" and app.state.checkpoint == "cp06_courtyard", "sai ao pátio e grava cp06_courtyard")
	await at(Vector3(-23.5, 0.05, -2.0), PI / 2)
	use("wedged_door")
	await wait(0.3)
	check(c.phase == "hall", "porta da rua emperrada")
	await at(Vector3(-22.0, 0.05, -4.8), PI / 2)
	use("side_door")
	await wait(5.0)
	check(c._crowd_active and _failed_text == "", "multidão sai do Gilman; jogador fora do pátio não é visto")
	use("shutters")
	await wait(2.0)
	check(c.phase == "street", "sai pelas venezianas para a Washington")
	await at(Vector3(-25.6, 0.05, -4.5), -PI / 2)
	use("shutters")
	await wait(0.3)
	check(c.state.has_fact("shutter_closed"), "fecha a veneziana como estava")
	await wait(7.0)
	check(_finished and app.state.checkpoint == "cp07_washington", "fatia concluída; cp07_washington gravado")
	await wait(1.5)
	check(app.chapter is NightChapter and app.mode == "game" and (app.chapter as NightChapter).phase == "washington", "segue direto para o capítulo VII, sem voltar ao menu")

	print("Falha e retomada")
	var s := StoryState.new()
	s.give_item("item_flashlight")
	s.set_checkpoint("cp06_knock")
	app.saves.save_state(s)
	app._retry()
	await wait(0.5)
	_hook()
	c = ch()
	check(c.phase == "ram" and c.state.has_fact("bed_at_south") and c.state.has_fact("bureau_at_hall"), "cp06_knock restaura o estado justo mínimo")
	check(not c.state.has_fact("lay_down") or c.state.has_fact("key_in_lock_done"), "eventos de escuta não se repetem")
	# O cerco anda no passo de física: com renderização a 6×, a física pode ficar atrás do relógio
	# do teste. Espera até a falha acontecer (prazo nominal 3 + 8 + 60 + 66 s), com folga.
	var f1_wait := 0.0
	while _failed_text == "" and f1_wait < 137.0 * 2.5:
		await wait(1.0)
		f1_wait += 1.0
	check(_failed_text != "" and app.mode == "fail", "sem arrombar, a porta do corredor cede (F1)")
	check(f1_wait >= 130.0, "e não cede antes do prazo nominal (%.0f s de jogo)" % f1_wait)
	app._retry()
	await wait(0.5)
	check(ch().phase == "ram" and app.mode == "game", "tentar novamente volta a cp06_knock sem diálogos")

	print("Pátio vigiado")
	var s2 := StoryState.new()
	s2.give_item("item_flashlight")
	s2.set_checkpoint("cp06_courtyard")
	app.saves.save_state(s2)
	app._retry()
	await wait(0.5)
	_hook()
	c = ch()
	use("warehouse_back")
	await at(Vector3(-23.5, 0.05, -2.0), PI / 2)
	use("wedged_door")
	await wait(5.0)
	await at(Vector3(-11.0, 0.05, 0.0), 0.0)
	await wait(1.5)
	check(_failed_text != "", "voltar ao pátio com a multidão leva a F6")

	app.saves.delete_all()
	print("\n%d verificações, %d falhas" % [_count, _fails])
	if rec:
		rec.finish()
	quit(1 if _fails > 0 else 0)
