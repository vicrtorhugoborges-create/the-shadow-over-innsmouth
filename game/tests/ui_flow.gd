extends SceneTree
## Fluxos de interface da 1.1 (docs/16): aviso na primeira execução, capítulos liberados por
## progresso, confirmação ao sobrescrever, pausa com objetivo e Diário, créditos, opções novas.
## Uso: Godot --headless --path game --script res://tests/ui_flow.gd (perfil isolado em APPDATA).
## Apaga só as configurações e saves do perfil de QA antes de começar.

var app: AppRoot
var _fails := 0
var _count := 0


func _initialize() -> void:
	if FileAccess.file_exists(SettingsStore.PATH):
		DirAccess.remove_absolute(SettingsStore.PATH)
	var sv := SaveService.new()
	sv.delete_all()
	app = load("res://main.tscn").instantiate()
	root.add_child(app)
	_run.call_deferred()


func check(cond: bool, label: String) -> void:
	_count += 1
	print(("  ok   " if cond else "  FALHA ") + label)
	if not cond:
		_fails += 1


func wait(s: float) -> void:
	await create_timer(s).timeout


func layer(key: String) -> bool:
	return app.ui.modal == key and (app.ui._layers[key] as Control).visible


func _run() -> void:
	await wait(0.5)
	print("Primeira execução")
	check(layer("warning"), "aviso de conteúdo aparece num perfil novo")
	app.ui.warning_accepted.emit()
	await wait(0.3)
	check(layer("main") and bool(app.settings.get_value("content_warning_seen")), "aceitar grava e abre o menu")
	check(not app.ui._continue_btn.visible, "sem save, não há Continuar")
	app.ui.show_chapters()
	await wait(0.2)
	var buttons := app.ui._chapters_box.find_children("*", "Button", true, false)
	check(buttons.size() == 1, "só a moldura está liberada no começo (%d botão)" % buttons.size())

	print("Progresso libera capítulos")
	app.start_from("cp05_return")
	await wait(0.8)
	check(app.chapter is GilmanChapter, "começa no V")
	check((app.settings.get_value("chapters_unlocked") as Array).has("cp05_return"), "o V fica liberado")
	app.save_checkpoint("cp06_knock")
	check((app.settings.get_value("chapters_unlocked") as Array).has("cp06_knock"), "gravar um checkpoint do VI libera o VI")

	print("Pausa")
	var ev := InputEventAction.new()
	ev.action = "pause"
	ev.pressed = true
	app._unhandled_input(ev)
	await wait(0.2)
	check(layer("pause") and get_root().get_tree().paused, "Esc pausa e congela a árvore")
	check(app.ui._pause_objective.text.begins_with("Objetivo: "), "a pausa mostra o objetivo")
	app.ui.journal_requested.emit()
	await wait(0.2)
	check(layer("journal"), "Diário abre pela pausa")
	app.ui.close_modal("journal")
	await wait(0.2)
	check(app.mode == "game" and not paused, "fechar o Diário volta ao jogo")

	print("Menu com save")
	app._to_menu()
	await wait(0.3)
	check(app.ui._continue_btn.visible, "com save, há Continuar")
	app.ui._confirm_overwrite(func() -> void: pass)
	await wait(0.2)
	check(layer("confirm"), "Nova partida com save pede confirmação")
	app.ui.show_main(true)
	app.ui.show_chapters()
	await wait(0.2)
	buttons = app.ui._chapters_box.find_children("*", "Button", true, false)
	check(buttons.size() == 3, "três capítulos liberados aparecem (%d)" % buttons.size())
	app.ui.show_layer("credits")
	await wait(0.1)
	check(layer("credits") and UiRoot.CREDITS_TEXT.contains("MIT") and UiRoot.CREDITS_TEXT.contains("Open Sans"), "créditos com as licenças")

	print("Opções")
	app.ui.setting_changed.emit("ambience_volume", 0.5)
	app.ui.setting_changed.emit("brightness", 1.3)
	await wait(0.1)
	var amb := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Ambience"))
	check(absf(amb - linear_to_db(0.5)) < 0.05, "volume de ambiente vai para o canal Ambience")
	check(is_equal_approx(float(app._retro_mat.get_shader_parameter("gamma")), 1.3), "brilho chega ao shader")
	app.ui.open_settings("main")
	await wait(0.2)
	var sliders := app.ui._settings_box.find_children("*", "HSlider", true, false)
	check(sliders.size() == 9 and app.ui._calib.size() == 3, "configurações com %d controles deslizantes e calibração de brilho" % sliders.size())

	app.saves.delete_all()
	DirAccess.remove_absolute(SettingsStore.PATH)
	print("\n%d verificações, %d falhas" % [_count, _fails])
	quit(1 if _fails > 0 else 0)
