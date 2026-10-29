extends SceneTree
## Testes de lógica em modo headless (docs/23). Uso:
## Godot --headless --path game --script res://tests/run_tests.gd
## Testa comportamento e invariantes; não exercita imagem, som ou input físico.

var _fails := 0
var _count := 0


func _init() -> void:
	_test_story_state()
	_test_save_service()
	_test_settings()
	_test_input()
	_test_director_timing()
	_test_director_success_path()
	_test_director_fairness()
	_test_synth()
	_test_patrol_visibility()
	_test_patrol_states()
	_test_patrol_band_crossing()
	print("\n%d verificações, %d falhas" % [_count, _fails])
	quit(1 if _fails > 0 else 0)


func check(cond: bool, label: String) -> void:
	_count += 1
	if cond:
		print("  ok   ", label)
	else:
		_fails += 1
		print("  FALHA ", label)


func _run(d: SiegeDirector, seconds: float, step: float = 0.1) -> Array[String]:
	var out: Array[String] = []
	var t := 0.0
	while t < seconds - 0.0001:
		out.append_array(d.advance(step))
		t += step
	return out


func _test_story_state() -> void:
	print("StoryState")
	var s := StoryState.new()
	check(s.set_fact("bolt_fitted"), "primeira concessão de fato retorna true")
	check(not s.set_fact("bolt_fitted"), "fato único não é concedido duas vezes")
	check(not s.set_fact("fato_inventado"), "fato fora da allowlist é recusado")
	check(s.give_item("item_flashlight") and not s.give_item("item_flashlight"), "item não duplica")
	check(not s.give_item("item_revolver"), "item fora da allowlist é recusado")
	s.set_checkpoint("cp06_knock")
	var r := StoryState.from_dict(s.to_dict())
	check(r != null and r.checkpoint == "cp06_knock" and r.has_fact("bolt_fitted") and r.has_item("item_flashlight"), "ida e volta preserva estado")
	check(StoryState.from_dict({"content_id": "outro", "checkpoint": "cp06_knock"}) == null, "content_id errado é rejeitado")
	check(StoryState.from_dict({"content_id": "innsmouth", "checkpoint": "res://hack.gd"}) == null, "checkpoint arbitrário é rejeitado")
	var mixed := StoryState.from_dict({"content_id": "innsmouth", "checkpoint": "cp05_room", "facts": ["bolt_fitted", "res://x", 42], "items": [], "docs": []})
	check(mixed != null and mixed.has_fact("bolt_fitted") and mixed.facts.size() == 1, "IDs desconhecidos e tipos errados são ignorados")


func _test_save_service() -> void:
	print("SaveService")
	var sv := SaveService.new()
	sv.slot = 7
	sv.delete_all()
	check(sv.load_state() == null, "sem save, nada carrega")
	var s := StoryState.new()
	s.set_checkpoint("cp05_room")
	check(sv.save_state(s), "grava primeiro save")
	s.set_fact("room_entered")
	s.set_checkpoint("cp06_knock")
	check(sv.save_state(s), "grava segundo save (backup do primeiro)")
	var loaded := sv.load_state()
	check(loaded != null and loaded.checkpoint == "cp06_knock", "carrega o mais recente")
	var f := FileAccess.open(sv.path(), FileAccess.WRITE)
	f.store_string("{ corrompido")
	f.close()
	var rec := sv.load_state()
	check(rec != null and rec.checkpoint == "cp05_room", "primário corrompido recupera o backup anterior")
	check(sv.load_reports_recovery(), "recuperação é reportada")
	var f2 := FileAccess.open(sv.path(), FileAccess.WRITE)
	f2.store_string(JSON.stringify({"schema_version": 99, "state": {}}))
	f2.close()
	check(SaveService._read(sv.path()) == null, "esquema futuro é rejeitado")
	# Migração (INN-507): um save escrito à mão como a 0.3.0/1.0 gravava continua carregando na 1.1.
	var f3 := FileAccess.open(sv.path(), FileAccess.WRITE)
	f3.store_string(JSON.stringify({"schema_version": 1, "state": {"content_id": "innsmouth", "checkpoint": "cp08_vault",
		"facts": ["ch07_done", "procession_seen", "peabody_met", "chart_complete"], "items": ["item_valise", "item_watch", "item_flashlight"],
		"docs": ["doc_zadok_record", "doc_raid_clippings"]}}))
	f3.close()
	var old_save := sv.load_state()
	check(old_save != null and old_save.checkpoint == "cp08_vault" and old_save.has_fact("procession_seen") and old_save.has_item("item_flashlight"), "save da 0.3.0/1.0 carrega na 1.1")
	sv.delete_all()


func _test_settings() -> void:
	print("SettingsStore")
	var v := SettingsStore.sanitize({"fov": 999, "text_size": "grande", "invert_y": 1, "internal_height": 500, "keys": {"interact": 69, "hack": 1}})
	check(is_equal_approx(float(v["fov"]), 100.0), "FOV é limitado")
	check(int(v["text_size"]) == 22, "tipo errado mantém padrão")
	check(v["invert_y"] == false, "booleano exige tipo booleano")
	check(int(v["internal_height"]) == 240, "altura interna aceita só 240/360")
	check((v["keys"] as Dictionary).size() == 1 and int(v["keys"]["interact"]) == 69, "teclas: só ações conhecidas")
	# Migração 1.0 → 1.1 (INN-507): um arquivo antigo, sem as chaves novas, mantém o que tinha.
	var old := SettingsStore.sanitize({"master_volume": 0.4, "dither": false, "text_size": 28, "keys": {"interact": 70}})
	check(is_equal_approx(float(old["master_volume"]), 0.4) and old["dither"] == false and int(old["text_size"]) == 28, "configurações da 1.0 continuam valendo")
	check(is_equal_approx(float(old["brightness"]), 1.0) and old["fullscreen"] == false and (old["chapters_unlocked"] as Array) == ["cp00_frame"], "chaves novas da 1.1 entram com o padrão")
	var u := SettingsStore.sanitize({"chapters_unlocked": ["cp05_return", "cp99_hack", 7, "cp05_return"], "brightness": 9.0})
	var unlocked: Array = u["chapters_unlocked"]
	check(unlocked == ["cp00_frame", "cp05_return"], "capítulos liberados: só inícios conhecidos, sem repetição, moldura sempre")
	check(is_equal_approx(float(u["brightness"]), 1.6), "brilho é limitado")
	check(SettingsStore.chapter_start_for("cp01_society") == "cp00_frame" and SettingsStore.chapter_start_for("cp06_roof") == "cp06_knock", "checkpoint → início de capítulo")


func _test_input() -> void:
	print("InputSetup")
	InputSetup.apply({"interact": KEY_F})
	var ok := true
	for a: String in InputSetup.ACTIONS:
		ok = ok and InputMap.has_action(a)
	check(ok, "todas as ações remapeáveis existem")
	var evs := InputMap.action_get_events("interact")
	var has_f := false
	for e in evs:
		if e is InputEventKey and (e as InputEventKey).physical_keycode == KEY_F:
			has_f = true
	check(has_f, "remapeamento aplicado")
	InputSetup.apply({})


func _test_director_timing() -> void:
	print("SiegeDirector — tempos")
	var d := SiegeDirector.new()
	d.configure(false, {})
	d.start()
	d.notify("prep_min")
	var ev := _run(d, 19.0)
	check(not ev.has("knock_first"), "S1 não começa antes de 20 s, mesmo com preparação")
	ev = _run(d, 1.5)
	check(ev.has("knock_first"), "S1 começa após 20 s com preparação mínima")
	var d2 := SiegeDirector.new()
	d2.configure(false, {})
	d2.start()
	ev = _run(d2, 179.0)
	check(not ev.has("knock_first"), "sem preparação, S1 espera até o máximo")
	ev = _run(d2, 1.5)
	check(ev.has("knock_first"), "S1 começa no tempo máximo (180 s)")
	# T1: jogador nunca arromba.
	var d3 := SiegeDirector.new()
	d3.configure(false, {})
	d3.start(SiegeDirector.Phase.S1_KNOCK)
	ev = _run(d3, 8.0 + 60.0 + 44.0)
	check(not ev.has("fail:F1"), "F1 não ocorre antes de 45 s de golpes")
	ev = _run(d3, 2.0)
	check(ev.has("fail:F1"), "F1 ocorre após 45 s de golpes sem arrombar")
	var d4 := SiegeDirector.new()
	d4.configure(false, {})
	d4.notify("bureau_hall")
	d4.start(SiegeDirector.Phase.S1_KNOCK)
	ev = _run(d4, 8.0 + 60.0 + 60.0)
	check(not ev.has("fail:F1"), "cômoda acrescenta 20 s a T1")


func _test_director_success_path() -> void:
	print("SiegeDirector — caminho canônico")
	var d := SiegeDirector.new()
	d.configure(false, {})
	d.start(SiegeDirector.Phase.S1_KNOCK)
	_run(d, 3.0)
	var ev := d.notify("north_hit")
	check(ev.has("hall_blows"), "primeiro golpe do jogador inicia S3")
	ev = d.notify("north_forced")
	check(ev.has("passkeys_neighbors"), "arrombar dispara chaves nos vizinhos")
	_run(d, 4.0)
	d.notify("n1_bolted")
	ev = _run(d, 3.2)
	check(ev.has("passkey_n2"), "chave-mestra em n2 após 3 s")
	check(d.requires_hall_n2_push(), "porta de n2 exige ação")
	_run(d, 3.0)
	ev = d.notify("n2_bolted")
	check(ev.has("lateral_attack") and d.phase == SiegeDirector.Phase.S6_LATERAL, "trancar n2 inicia ataque lateral")
	ev = d.notify("barricade")
	check(d.phase == SiegeDirector.Phase.S6_LATERAL, "barricada sem a porta norte trancada não antecipa o aríete")
	d.notify("n2_north_bolted")
	ev = d.notify("barricade")
	check(ev.has("ram_start") and d.phase == SiegeDirector.Phase.S7_RAM, "barricada com porta norte trancada inicia o aríete")
	ev = _run(d, 40.0)
	check(not ev.any(func(e: String) -> bool: return e.begins_with("fail:")), "duas barricadas seguram ao menos 40 s")
	check(ev.has("panel_crack_1"), "painel racha antes da ruptura (aviso visível)")
	d.notify("descent_started")
	check(d.phase == SiegeDirector.Phase.ESCAPED and d.failure == "", "descer encerra o cerco sem falha")
	ev = _run(d, 100.0)
	check(ev.is_empty(), "diretor inativo após a fuga")


func _test_director_fairness() -> void:
	print("SiegeDirector — justiça")
	var d := SiegeDirector.new()
	var counts := {}
	d.configure(false, counts)
	d.start(SiegeDirector.Phase.S1_KNOCK)
	d.notify("north_forced")
	var ev := _run(d, 5.9)
	check(not ev.has("fail:F2"), "T2 padrão dá 6 s")
	ev = _run(d, 0.3)
	check(ev.has("fail:F2"), "F2 após 6 s sem trancar n1")
	var a := SiegeDirector.new()
	a.configure(true, {})
	a.start(SiegeDirector.Phase.S1_KNOCK)
	a.notify("north_forced")
	ev = _run(a, 11.8)
	check(not ev.has("fail:F2"), "fuga assistida dá 12 s em T2")
	var r := SiegeDirector.new()
	r.configure(false, {"T2": 2})
	r.start(SiegeDirector.Phase.S1_KNOCK)
	r.notify("north_forced")
	ev = _run(r, 7.4)
	check(not ev.has("fail:F2"), "após duas falhas, T2 recebe +25 %")
	check(int(counts.get("T2", 0)) == 1, "falha é contada na memória transitória")
	var g := SiegeDirector.new()
	g.configure(false, {})
	g.start(SiegeDirector.Phase.S6_LATERAL)
	ev = _run(g, 24.9)
	check(ev.has("passkey_n3") and not ev.has("ram_start"), "aviso de correria antes do aríete automático")
	ev = _run(g, 0.2)
	check(ev.has("ram_start"), "aríete automático aos 25 s")
	ev = _run(g, 2.2)
	check(not ev.has("fail:F4"), "tolerância de 2,5 s para fechar a porta norte")
	ev = _run(g, 0.5)
	check(ev.has("fail:F4"), "porta norte aberta após a tolerância leva a F4")
	var p := SiegeDirector.new()
	p.configure(false, {})
	p.start(SiegeDirector.Phase.S4_PASSKEYS)
	var before := p.phase_time()
	check(is_equal_approx(before, 0.0) and p.phase == SiegeDirector.Phase.S4_PASSKEYS, "sem advance (pausa), tempo não corre")


func _patrol_run(d: PatrolDirector, seconds: float, info: Dictionary, step: float = 0.1) -> Array[String]:
	var out: Array[String] = []
	var t := 0.0
	while t < seconds - 0.0001:
		out.append_array(d.advance(step, info))
		t += step
	return out


func _has_prefix(evs: Array[String], prefix: String) -> bool:
	for e in evs:
		if e.begins_with(prefix):
			return true
	return false


func _test_patrol_visibility() -> void:
	print("PatrolDirector — percepção")
	var mono := true
	for gait: String in ["still", "crouch", "walk", "run", "shamble"]:
		for moon: bool in [false, true]:
			for d: float in [2.0, 8.0, 20.0, 29.0]:
				var dark := PatrolDirector.visibility(PatrolDirector.light_factor(false, false), gait, moon, d, 30.0, 0.0)
				var lit := PatrolDirector.visibility(PatrolDirector.light_factor(true, false), gait, moon, d, 30.0, 0.0)
				var torch := PatrolDirector.visibility(PatrolDirector.light_factor(moon, true), gait, moon, d, 30.0, 0.0)
				mono = mono and lit >= dark and torch >= lit
	check(mono, "mais luz nunca reduz a visibilidade (lanterna ≥ luar ≥ sombra)")
	var near := PatrolDirector.visibility(1.0, "walk", true, 4.0, 30.0, 0.0)
	var far := PatrolDirector.visibility(1.0, "walk", true, 20.0, 30.0, 0.0)
	check(near > far and PatrolDirector.visibility(1.0, "walk", true, 31.0, 30.0, 0.0) == 0.0, "distância reduz e o limite do cone zera")
	var sham := PatrolDirector.visibility(1.0, "shamble", true, 20.0, 30.0, 0.0)
	var walk := PatrolDirector.visibility(1.0, "walk", true, 20.0, 30.0, 0.0)
	check(sham < walk * 0.3, "andar arrastado engana ao longe e ao luar")
	check(PatrolDirector.visibility(1.0, "shamble", true, 4.0, 30.0, 0.0) >= 0.8 * PatrolDirector.visibility(1.0, "walk", true, 4.0, 30.0, 0.0), "andar arrastado perde o efeito de perto")
	check(PatrolDirector.visibility(1.0, "run", true, 10.0, 30.0, 0.0) > walk, "correr é mais visível que andar")
	var d := PatrolDirector.new()
	d.add_group("g", [Vector3(0, 0, 0), Vector3(0, 0, 10)] as Array[Vector3], 0.0, {"hold": true})
	var ev := _patrol_run(d, 10.0, {"pos": Vector3(0, 0, 6), "gait": "run", "in_moon": true, "hidden": true, "flash": false})
	check(ev.is_empty() and d.get_group("g").suspicion == 0.0, "esconderijo zera a percepção, mesmo correndo ao luar")
	ev = _patrol_run(d, 10.0, {"pos": Vector3(0, 0, -6), "gait": "run", "in_moon": true, "hidden": false, "flash": true})
	check(ev.is_empty(), "jogador às costas do grupo, fora do cone, não é visto")
	d.los = func(_a: Vector3, _b: Vector3) -> bool: return false
	ev = _patrol_run(d, 10.0, {"pos": Vector3(0, 0, 6), "gait": "run", "in_moon": true, "hidden": false, "flash": true})
	check(ev.is_empty(), "sem linha de visão (parede), nada é percebido")


func _test_patrol_states() -> void:
	print("PatrolDirector — estados e justiça")
	var d := PatrolDirector.new()
	d.add_group("g", [Vector3(0, 0, 0), Vector3(0, 0, 40)] as Array[Vector3], 1.5, {"hold": true})
	_patrol_run(d, 3.0, {"pos": Vector3(50, 0, 50), "gait": "walk"})
	check(d.get_group("g").pos == Vector3.ZERO, "grupo em espera não se move")
	d.release("g")
	_patrol_run(d, 2.0, {"pos": Vector3(50, 0, 50), "gait": "walk"})
	check(d.get_group("g").pos.z > 2.5, "liberado, segue a trilha")
	var info := {"pos": Vector3(0, 0, 9), "gait": "run", "in_moon": true, "hidden": false, "flash": false}
	var evs: Array[String] = []
	var alert_at := -1.0
	var sus_at := -1.0
	var t := 0.0
	while t < 8.0 and alert_at < 0.0:
		var e := d.advance(0.05, info)
		t += 0.05
		if _has_prefix(e, "suspicious") and sus_at < 0.0:
			sus_at = t
		if _has_prefix(e, "alert"):
			alert_at = t
		evs.append_array(e)
	check(sus_at > 0.0 and alert_at > 0.0, "corrida ao luar à frente do grupo leva a suspeita e depois alerta")
	check(alert_at - sus_at >= 0.99, "nunca alerta sem ≥ 1 s de suspeita audível/visível")
	info["hidden"] = true
	var lost := _patrol_run(d, 5.2, info)
	check(_has_prefix(lost, "lost") and d.get_group("g").state == "returning", "quebrar a linha de visão por 5 s faz o grupo desistir")
	var c := PatrolDirector.new()
	c.add_group("c", [Vector3(0, 0, 0), Vector3(0, 0, 1)] as Array[Vector3], 0.0, {"hold": true})
	c.get_group("c").state = "chasing"
	var cap := _patrol_run(c, 3.0, {"pos": Vector3(0, 0, 4), "gait": "still", "in_moon": true})
	check(cap.has("fail:CAPTURE"), "perseguição que alcança o jogador resulta em captura")
	var a := PatrolDirector.new()
	a.assisted = true
	a.add_group("c", [Vector3(0, 0, 0), Vector3(0, 0, 1)] as Array[Vector3], 0.0, {"hold": true})
	a.get_group("c").state = "chasing"
	_patrol_run(a, 9.0, {"pos": Vector3(0, 0, 60), "gait": "walk", "hidden": true})
	check(a.get_group("c").state == "chasing", "fuga assistida dá janela de 10 s antes de desistir")
	var n := PatrolDirector.new()
	n.add_group("near", [Vector3(0, 0, 0), Vector3(0, 0, 1)] as Array[Vector3], 0.0, {"hold": true})
	n.add_group("far", [Vector3(30, 0, 0), Vector3(30, 0, 1)] as Array[Vector3], 0.0, {"hold": true})
	var ne := n.noise(Vector3(5, 0, 0), 14.0)
	check(ne == ["suspicious:near"] and n.get_group("far").suspicion == 0.0, "ruído alerta só o grupo mais próximo no raio")
	check(n.noise(Vector3(5, 0, 0), 0.0).is_empty() or n.get_group("far").suspicion == 0.0, "passo agachado (raio 0) não é ouvido")


func _test_patrol_band_crossing() -> void:
	print("PatrolDirector — o bando da Washington (docs/09 §7)")
	# Bando a ~28 m, ao luar, atravessando a South; jogador cruza devagar diante dele.
	var results := {}
	for gait: String in ["shamble", "walk", "run"]:
		var d := PatrolDirector.new()
		var g := d.add_group("band", [Vector3(-34, 0, 100), Vector3(-34, 0, 160)] as Array[Vector3], 0.0, {"range": 45.0, "min_df": 0.5, "members": 8, "hold": true})
		g.heading = Vector3(-1, 0, 0.3).normalized()
		var secs := 10.0 if gait == "shamble" else (6.0 if gait == "walk" else 4.0)
		var ev := _patrol_run(d, secs, {"pos": Vector3(-62, 0, 108), "gait": gait, "in_moon": true, "hidden": false, "flash": false})
		results[gait] = _has_prefix(ev, "alert")
	check(not results["shamble"], "andar arrastado: o bando segue sem mudar o rumo")
	check(results["walk"], "andar normal na travessia: detectado")
	check(results["run"], "correr na travessia: detectado")


func _test_synth() -> void:
	print("SoundSynth")
	var s := SoundSynth.new()
	s.build()
	var ok := true
	for id: String in ["sfx_knock", "sfx_blow", "sfx_key", "sfx_croak", "amb_wind", "amb_drone"]:
		ok = ok and s.get_stream(id) is AudioStreamWAV and (s.get_stream(id) as AudioStreamWAV).data.size() > 1000
	check(ok, "sons provisórios gerados")
	var loop := s.get_stream("amb_room") as AudioStreamWAV
	check(loop.loop_mode == AudioStreamWAV.LOOP_FORWARD, "ambiências em laço")
