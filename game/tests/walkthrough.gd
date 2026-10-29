extends SceneTree
## Andarilho automático (QA de geometria): percorre as rotas dos capítulos V–VII com input real
## de movimento — sem teletransporte entre os pontos — e acusa onde o jogador fica preso ou cai.
## Uso: Godot --headless --path game --script res://tests/walkthrough.gd
## Percepção e cerco ficam desligados: o objetivo é só a navegabilidade.

const SPEED := 4.0

var app: AppRoot
var _fails := 0
var _count := 0


func _initialize() -> void:
	Engine.time_scale = SPEED
	app = load("res://main.tscn").instantiate()
	root.add_child(app)
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


func start_at(cp: String) -> void:
	var s := StoryState.new()
	for it: String in ["item_flashlight", "item_sketch_map", "item_watch", "item_keyring_tool"]:
		s.give_item(it)
	s.add_doc("doc_sketch_map")
	s.set_checkpoint(cp)
	app.saves.save_state(s)
	app._retry()
	await wait(0.6)
	if app.chapter is GilmanChapter:
		(app.chapter as GilmanChapter).director = SiegeDirector.new()
	if app.chapter is NightChapter:
		(app.chapter as NightChapter).qa_ghost = true


func walk(label: String, points: Array) -> void:
	## Caminha de ponto em ponto girando a câmera como o mouse faria; preso = sem progresso por 4 s.
	var p: Player = app.chapter.player
	for wp: Vector3 in points:
		var t := 0.0
		var best := INF
		var last_improve := 0.0
		while true:
			if app.mode != "game":
				Input.action_release("move_forward")
				check(false, "%s: falha/queda a caminho de %s (jogador em %s)" % [label, wp, p.global_position.snapped(Vector3.ONE * 0.1)])
				return
			var pos := p.global_position
			var to := Vector2(wp.x - pos.x, wp.z - pos.z)
			var d := to.length()
			if d < 0.6:
				break
			p.set_view(atan2(-to.x, -to.y), 0.0)
			Input.action_press("move_forward")
			await wait(0.1)
			t += 0.1
			if d < best - 0.25:
				best = d
				last_improve = t
			if t - last_improve > 4.0:
				Input.action_release("move_forward")
				check(false, "%s: preso a caminho de %s (jogador em %s)" % [label, wp, p.global_position.snapped(Vector3.ONE * 0.1)])
				return
	Input.action_release("move_forward")
	check(true, label)


func _run() -> void:
	await wait(0.5)
	print("Capítulos V–VI — Gilman House")
	await start_at("cp05_return")
	await walk("praça: do ônibus até a porta do Gilman", [Vector3(12.9, 0, 4.0), Vector3(7.2, 0, 0.6)])
	app.chapter._spawn(Vector3(5.2, 0.05, 0.0), PI / 2)
	await wait(0.3)
	await walk("saguão: balcão e pé da escada", [Vector3(4.0, 0, -0.8), Vector3(4.0, 0, 2.2), Vector3(2.9, 0, 2.8)])

	await start_at("cp05_room")
	await walk("4º andar: corredor ida e volta pela porta do 428", [Vector3(1.1, 9, 2.0), Vector3(1.1, 9, -9.0), Vector3(1.1, 9, 2.0), Vector3(-1.6, 9, 2.0)])
	await walk("quarto 428: janela, armário, valise", [Vector3(-4.1, 9, 0.9), Vector3(-3.6, 9, 1.0), Vector3(-2.0, 9, 1.4)])

	await start_at("cp06_knock")
	var g := app.chapter as GilmanChapter
	g.doors["c_428_n1"].set_state(Door.State.BROKEN, false)
	g.doors["c_n1_n2"].set_state(Door.State.OPEN, false)
	await wait(0.3)
	await walk("cerco: 428 → n1 pela porta arrombada", [Vector3(-0.8, 9, 0.6), Vector3(-0.8, 9, -0.9), Vector3(-2.0, 9, -2.0), Vector3(-0.5, 9, -2.0)])
	await walk("cerco: n1 → n2 pela porta de ligação até a janela sul", [Vector3(-0.8, 9, -3.4), Vector3(-0.8, 9, -4.8), Vector3(-2.5, 9, -5.6), Vector3(-4.2, 9, -4.9)])

	await start_at("cp06_roof")
	await walk("telhado da Paine até a claraboia (sem cair)", [Vector3(-7.5, 7, -5.9), Vector3(-9.3, 7, -6.3)])
	check(app.chapter.player.global_position.y > 5.5, "jogador continua sobre o telhado")

	await start_at("cp06_roof")
	app.chapter._spawn(Vector3(-9.5, 4.95, -6.3), PI / 2)
	app.chapter._set_phase("attic")
	await wait(0.3)
	await walk("sótão → escada → 2º andar", [Vector3(-7.0, 5, -9.5), Vector3(-6.0, 5, -12.6), Vector3(-11.6, 3, -12.6)])
	check(absf(app.chapter.player.global_position.y - 2.9) < 0.4, "chegou ao 2º andar (y ≈ 2,9)")
	await walk("2º andar → escada → térreo → porta dos fundos", [Vector3(-12.2, 3, -12.1), Vector3(-12.2, 3, -10.95), Vector3(-6.2, 1, -10.95), Vector3(-5.8, 1, -7.0), Vector3(-9.1, 1, -5.0)])
	check(absf(app.chapter.player.global_position.y - 0.9) < 0.4, "chegou ao térreo (y ≈ 0,9)")

	await start_at("cp06_courtyard")
	g = app.chapter as GilmanChapter
	g.doors["warehouse_back"].set_state(Door.State.OPEN, false)
	g.doors["side_door"].set_state(Door.State.OPEN, false)
	await wait(0.3)
	await walk("degraus → pátio → corredor do lado da Washington", [Vector3(-9.1, 0, -3.0), Vector3(-9.1, 0, -1.8), Vector3(-16.0, 0, -2.0), Vector3(-23.5, 0, -2.0)])
	await walk("porta lateral → sala vazia das venezianas", [Vector3(-21.05, 0, -2.3), Vector3(-21.05, 0, -3.6), Vector3(-23.6, 0, -4.5)])

	print("Capítulos II–IV — Innsmouth de dia")
	await start_at("cp03_grocery")
	await walk("praça → ponte da Federal → New Church Green", [Vector3(32, 0, -8), Vector3(30, 0, -20), Vector3(30, 0, -40), Vector3(30, 0, -100)])
	await walk("Green → Old Square e a refinaria", [Vector3(30, 0, -48), Vector3(60, 0, -48), Vector3(72, 0, -48)])
	await walk("Old Square → margem do rio → norte do rio: Main, Church e Water", [Vector3(72, 0, -40), Vector3(104, 0, -40), Vector3(104, 0, -84), Vector3(136, 0, -84), Vector3(136, 0, -40)])
	await walk("ponte precária da Water → orla sul → cais de Zadok", [Vector3(136, 0, -28), Vector3(136, 0, -10), Vector3(136, 0, 44), Vector3(150, 0, 70)])
	await walk("orla → Waite → praça → Eliot", [Vector3(104, 0, 44), Vector3(104, 0, 4), Vector3(60, 0, 4), Vector3(30, 0, 0), Vector3(16, 0, 30)])
	await walk("Eliot → praça → Paine → ponte da Washington → casarões", [Vector3(17.5, 0, 4), Vector3(6, 0, -17), Vector3(-44, 0, -17),Vector3(-44, 0, -40), Vector3(-44, 0, -96), Vector3(-66, 0, -96)])

	print("Capítulo VII — fuga noturna")
	await start_at("cp07_washington")
	await walk("Washington até o vestíbulo da Bates", [Vector3(-34, 0, 10), Vector3(-34, 0, 40), Vector3(-41, 0, 46), Vector3(-46, 0, 46)])
	await walk("Bates → espaço aberto → boca da South", [Vector3(-34, 0, 50), Vector3(-34, 0, 84), Vector3(-28, 0, 104), Vector3(-16, 0, 108)])
	await walk("praça → portal da Washington", [Vector3(-30, 0, 112), Vector3(-36, 0, 124), Vector3(-41, 0, 130), Vector3(-46, 0, 130)])
	await walk("Babson e seus portais", [Vector3(-34, 0, 136), Vector3(-34, 0, 148), Vector3(-50, 0, 148), Vector3(-50, 0, 142), Vector3(-54, 0, 147.5), Vector3(-58, 0, 142)])
	await walk("espaço aberto da Eliot → Lafayette → 2ª travessia da South", [Vector3(-66, 0, 140), Vector3(-66, 0, 120), Vector3(-66, 0, 100)])
	await walk("Lafayette → Bates oeste → Adams → Bank Street", [Vector3(-66, 0, 58), Vector3(-96, 0, 58), Vector3(-96, 0, 30), Vector3(-96, 0, -22)])
	await walk("Bank Street → estação → beira do desfiladeiro", [Vector3(-150, 0, -22), Vector3(-188, 0, -22), Vector3(-220, 0, -22)])
	await walk("ponte coberta até a beira do vão", [Vector3(-220, 0, -30), Vector3(-220, 0, -50.6)])
	var n := app.chapter as NightChapter
	n._jump_gap()
	await wait(1.2)
	check(n.player.global_position.z < -54.5 and n.player.global_position.y > -1.0, "salto do vão aterrissa na outra metade da ponte")
	await walk("ponte → River Street → aterro → corte", [Vector3(-220, 0, -62), Vector3(-220, 0, -84), Vector3(-220, 0, -150), Vector3(-220, 0, -200), Vector3(-220, 0, -238)])

	app.saves.delete_all()
	print("\n%d verificações, %d falhas" % [_count, _fails])
	quit(1 if _fails > 0 else 0)
