extends SceneTree
## Jogada automatizada de ch07_night (integração): rota canônica da Washington ao desmaio,
## captura pela sentinela da South e queda no vão da ponte coberta.
## Uso: Godot --headless --path game --script res://tests/playthrough_night.gd
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
		rec.setup(app, "noite", rec_dir)
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


func ch() -> NightChapter:
	return app.chapter as NightChapter


func at(pos: Vector3, yaw: float = PI) -> void:
	ch()._spawn(pos, yaw)
	await wait(0.25)


func wait_until(cond: Callable, max_seconds: float) -> bool:
	var t := 0.0
	while t < max_seconds:
		if cond.call():
			return true
		if _failed_text != "":
			return false
		await wait(0.5)
		t += 0.5
	return bool(cond.call())


func _hook() -> void:
	_failed_text = ""
	_finished = false
	ch().failed.connect(func(t: String) -> void: _failed_text = t)
	ch().finished.connect(func() -> void: _finished = true)


func start_at(cp: String) -> void:
	var s := StoryState.new()
	for it: String in ["item_flashlight", "item_sketch_map", "item_watch", "item_keyring_tool"]:
		s.give_item(it)
	s.add_doc("doc_sketch_map")
	s.set_checkpoint(cp)
	app.saves.save_state(s)
	app._retry()
	await wait(0.6)
	_hook()


func release_all() -> void:
	for a: String in ["move_forward", "shamble", "run", "crouch", "close_eyes"]:
		Input.action_release(a)


func _run() -> void:
	await wait(0.5)
	print("Rota canônica de ch07")
	await start_at("cp07_washington")
	var c := ch()
	check(c != null and c.phase == "washington", "começa na Washington, ao sair pela veneziana")
	await at(Vector3(-30, 0.05, 32))
	check(c.phase == "bates", "passos na Bates: dupla de figuras em espera")
	await at(Vector3(-46, 0.05, 46))
	check(c.is_hidden(), "vestíbulo escuro esconde o jogador")
	var ok := await wait_until(func() -> bool: return c.state.has_fact("bates_passed"), 60.0)
	check(ok and _failed_text == "", "a dupla cruza a Bates sem vê-lo")
	await at(Vector3(-34, 0.05, 84))
	await wait(0.3)
	check(app.state.checkpoint == "cp07_south_crossing", "grava cp07_south_crossing antes do espaço aberto")
	await at(Vector3(-30, 0.05, 104), -PI / 2)
	ok = await wait_until(func() -> bool: return c.phase == "hide_portal", 20.0)
	check(ok and c.state.has_fact("reef_signals_seen") and c.state.has_fact("swimmers_seen"), "sinais do recife, resposta da cúpula e nadadores")
	check(_failed_text == "", "a sentinela distante da South não vê quem fica na praça")
	await at(Vector3(-46, 0.05, 130))
	check(c.phase == "plan", "portal escuro: hora de pensar")
	c._on_interact(c.inter["map_portal"])
	await wait(0.3)
	check(app.ui.modal == "document", "mapa consultado à lanterna")
	app.ui.close_document()
	await wait(0.3)
	check(c.state.has_fact("railway_plan") and app.state.checkpoint == "cp07_babson", "plano da ferrovia; grava cp07_babson")

	await at(Vector3(-46, 0.05, 148), PI / 2)
	check(c.director.get_group("ipswich_car") != null, "motor na Eliot")
	await at(Vector3(-50, 0.05, 142), PI / 2)
	check(c.is_hidden(), "segunda pausa num portal da Babson")
	ok = await wait_until(func() -> bool: return c.state.has_fact("ipswich_party_seen"), 40.0)
	check(ok and _failed_text == "", "o grupo de Ipswich passa pelo espaço aberto sem vê-lo")
	await at(Vector3(-66, 0.05, 138), 0.0)
	check(c.phase == "lafayette" and c.director.get_group("band") != null, "Lafayette; o bando desce a Washington")
	await wait(9.0)
	check(c.director.get_group("band").state == "hold", "o bando espera fora da vista")

	await at(Vector3(-66, 0.05, 120.5), 0.0)
	Input.action_press("shamble")
	Input.action_press("move_forward")
	ok = await wait_until(func() -> bool: return c.player.global_position.z < 97.0, 30.0)
	Input.action_release("move_forward")
	check(ok and c.phase == "south2" and c.state.has_fact("rowboat_seen"), "2ª travessia da South com o andar arrastado; bote e brilho no recife")
	var band := c.director.get_group("band")
	check(_failed_text == "" and (band == null or band.state != "chasing"), "o bando passa a uma quadra sem mudar o rumo")
	Input.action_release("shamble")
	ok = await wait_until(func() -> bool: return c.state.has_fact("band_passed"), 60.0)
	check(ok, "bando segue para o sul e sai de cena")

	await at(Vector3(-66, 0.05, 60), PI / 2)
	check(c.phase == "adams", "Bates para oeste")
	await at(Vector3(-96, 0.05, 37), 0.0)
	await wait(0.5)
	check(c.state.has_fact("drunk_seen") and _failed_text == "", "o bêbado da Adams assusta, mas não ameaça")
	await at(Vector3(-96, 0.05, -20), PI / 2)
	check(c.phase == "bank" and app.state.checkpoint == "cp07_bank_street", "Bank Street; grava cp07_bank_street")
	await at(Vector3(-190, 0.05, -22), PI / 2)
	await at(Vector3(-220, 0.05, -25), 0.0)
	check(c.phase == "bridge" and app.state.checkpoint == "cp07_bridge", "ponte coberta; grava cp07_bridge")
	await at(Vector3(-220, 0.05, -36), 0.0)
	check(c.state.has_fact("bats_seen"), "nuvem de morcegos")
	await at(Vector3(-220, 0.05, -50.8), 0.0)
	c._on_interact(c.inter["bridge_gap"])
	await wait(1.5)
	check(c.state.has_fact("gap_jumped") and c.player.global_position.z < -54.5 and c.player.global_position.y > -1.0, "salta o vão dos dormentes")
	await at(Vector3(-220, 0.05, -84), 0.0)
	check(c.phase == "marsh", "pântano: menos cheiro de peixe")
	await at(Vector3(-220, 0.05, -172), 0.0)
	check(c.state.has_fact("column_seen"), "olhar para trás: a coluna ondulante na estrada de Ipswich")
	await at(Vector3(-220, 0.05, -206), 0.0)
	check(c.phase == "cut" and app.state.checkpoint == "cp07_cut", "corte de mato; grava cp07_cut")
	await at(Vector3(-220, 0.05, -239), 0.0)
	Input.action_press("crouch")
	ok = await wait_until(func() -> bool: return c.phase == "procession", 5.0)
	check(ok, "agachado no mato, a procissão começa")
	Input.action_press("close_eyes")
	await wait(26.0)
	check(c.state.has_fact("eyes_failed"), "manter os olhos fechados falha sozinho")
	Input.action_release("close_eyes")
	ok = await wait_until(func() -> bool: return _finished, 60.0)
	release_all()
	check(ok and app.state.has_fact("procession_seen") and app.state.checkpoint == "cp08_rain", "vê a procissão e desmaia; grava cp08_rain")
	await wait(0.5)
	check(app.chapter is InheritanceChapter and app.mode == "game", "segue direto para o capítulo VIII, sem voltar ao menu")

	print("Captura pela sentinela")
	await start_at("cp07_south_crossing")
	c = ch()
	c.state.set_fact("reef_signals_seen")
	await at(Vector3(-14, 0.05, 108), -PI / 2)
	Input.action_press("run")
	Input.action_press("move_forward")
	await wait(1.5)
	release_all()
	c.player.toggle_flashlight()
	ok = await wait_until(func() -> bool: return _failed_text != "", 45.0)
	check(_failed_text != "" and app.mode == "fail", "lanterna acesa ao luar diante da sentinela da South leva à captura")
	app._retry()
	await wait(0.6)
	check(ch() != null and ch().phase == "crossing" and app.state.checkpoint == "cp07_south_crossing", "tentar novamente volta a cp07_south_crossing")

	print("Queda no vão")
	await start_at("cp07_bridge")
	c = ch()
	await at(Vector3(-220, 0.05, -53.2), 0.0)
	ok = await wait_until(func() -> bool: return _failed_text != "", 10.0)
	check(ok, "andar para dentro do vão é queda")

	app.saves.delete_all()
	print("\n%d verificações, %d falhas" % [_count, _fails])
	if rec:
		rec.finish()
	quit(1 if _fails > 0 else 0)
