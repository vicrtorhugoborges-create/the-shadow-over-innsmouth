class_name UiRoot
extends CanvasLayer
## Interface em resolução nativa (sys_ui, docs/16). Emite intenções; não altera progressão.

signal new_game_requested
signal chapter_requested(cp: String)
signal continue_requested
signal quit_requested
signal resume_requested
signal retry_requested
signal checkpoint_requested
signal menu_requested
signal setting_changed(key: String, value: Variant)
signal key_rebound(action: String, keycode: int)
signal dialog_choice(index: int)
signal modal_closed(kind: String)
signal hint_requested
signal warning_accepted
signal journal_requested

const CREDITS_TEXT := """THE SHADOW OVER INNSMOUTH
Adaptação de "The Shadow over Innsmouth", de H. P. Lovecraft (1936), conto tratado como domínio público. Diálogos e textos em português são redação original desta adaptação; cartas, jornais, documentos e notas do jogo são criação da adaptação a partir de fatos do conto, e o capítulo final é uma cena simbólica.

PRODUÇÃO
Projeto VHB. Programação, textos, geometria, texturas e sons foram produzidos dentro do próprio projeto com assistência de IA (Claude Code, Anthropic), sob direção do responsável pelo projeto. Texturas e sons são gerados por código no momento da execução; nenhum arquivo de arte ou áudio de terceiros é usado.

TECNOLOGIA
Godot Engine 4.7.2 — licença MIT.
Copyright (c) 2014-present Godot Engine contributors.
Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.
A engine inclui componentes de terceiros, entre eles a fonte Open Sans (SIL Open Font License 1.1). Os textos completos das licenças acompanham o jogo: GODOT_LICENSE.txt e GODOT_COPYRIGHT.txt.

AVISO
Esta adaptação não endossa as visões racistas e eugenistas presentes no conto de 1936. A "aparência de Innsmouth" é representada por traços anfíbios, nunca étnicos."""

const BG := Color(0.03, 0.035, 0.04, 0.94)
const FG := Color(0.86, 0.83, 0.74)
const DIM := Color(0.55, 0.53, 0.48)
const ACCENT := Color(0.72, 0.62, 0.38)

var text_size := 22
var captions_enabled := true
var modal := ""

var _prompt: Label
var _dot: ColorRect
var _subs: VBoxContainer
var _fade: ColorRect
var _eyes: ColorRect
var _card: Label
var _status: Label
var _layers: Dictionary = {}
var _dialog_speaker: Label
var _dialog_text: Label
var _dialog_choices: VBoxContainer
var _doc_title: Label
var _doc_body: RichTextLabel
var _journal_obj: Label
var _journal_hint: Label
var _journal_notes: RichTextLabel
var _journal_docs: VBoxContainer
var _journal_hint_btn: Button
var _fail_label: Label
var _settings_box: VBoxContainer
var _settings_return := ""
var _rebinding := ""
var _rebind_buttons: Dictionary = {}
var _continue_btn: Button
var _main_first: Button
var _pause_first: Button
var _settings_values: Dictionary = {}
var _doc_open_from := ""
var _end_title: Label
var _end_body: Label
var _end_default := ""
var _chapters_first: Button
var _chapters_box: VBoxContainer
var _pause_objective: Label
var _credits_first: Button
var _subtitle_bg := 0.78
var _center_dot := true
var _calib: Array[ColorRect] = []
var _confirm_action: Callable = Callable()
var _confirm_no: Button


func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	_build_hud(root)
	_build_dialog(root)
	_build_document(root)
	_build_journal(root)
	_build_pause(root)
	_build_main(root)
	_build_settings(root)
	_build_warning(root)
	_build_fail(root)
	_build_end(root)
	_build_chapters(root)
	_build_credits(root)
	_build_confirm(root)
	_fade = _rect(root, Color.BLACK)
	_fade.modulate.a = 0.0
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hide_all()


# ---------------------------------------------------------------- construção

func _rect(parent: Control, c: Color) -> ColorRect:
	var r := ColorRect.new()
	r.color = c
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(r)
	return r


func _panel_style(alpha: float = 0.94) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(BG.r, BG.g, BG.b, alpha)
	sb.border_color = Color(0.3, 0.27, 0.2)
	sb.set_border_width_all(1)
	sb.set_content_margin_all(18)
	return sb


func _label(parent: Node, text: String, size: int, color: Color = FG) -> Label:
	var l := Label.new()
	l.text = text
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	parent.add_child(l)
	return l


func _button(parent: Node, text: String, cb: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_ALL
	b.add_theme_font_size_override("font_size", 22)
	b.add_theme_color_override("font_color", FG)
	b.add_theme_color_override("font_focus_color", ACCENT)
	b.add_theme_color_override("font_hover_color", ACCENT)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.08, 0.08, 0.08, 0.9)
	sb.set_content_margin_all(8)
	var sf := sb.duplicate()
	sf.border_color = ACCENT
	sf.set_border_width_all(1)
	b.add_theme_stylebox_override("normal", sb)
	b.add_theme_stylebox_override("hover", sf)
	b.add_theme_stylebox_override("focus", sf)
	b.add_theme_stylebox_override("pressed", sf)
	b.pressed.connect(cb)
	parent.add_child(b)
	return b


func _centered_panel(parent: Control, key: String, w: float, h: float) -> VBoxContainer:
	var holder := Control.new()
	holder.set_anchors_preset(Control.PRESET_FULL_RECT)
	holder.mouse_filter = Control.MOUSE_FILTER_STOP
	parent.add_child(holder)
	var dim := _rect(holder, Color(0, 0, 0, 0.55))
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _panel_style())
	p.set_anchors_preset(Control.PRESET_CENTER)
	p.custom_minimum_size = Vector2(w, h)
	p.offset_left = -w / 2
	p.offset_right = w / 2
	p.offset_top = -h / 2
	p.offset_bottom = h / 2
	holder.add_child(p)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	p.add_child(v)
	_layers[key] = holder
	return v


func _build_hud(root: Control) -> void:
	var hud := Control.new()
	hud.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(hud)
	_layers["hud"] = hud
	_eyes = _rect(hud, Color.BLACK)
	_eyes.modulate.a = 0.0
	_dot = ColorRect.new()
	_dot.color = Color(0.85, 0.82, 0.7, 0.55)
	_dot.size = Vector2(3, 3)
	_dot.set_anchors_preset(Control.PRESET_CENTER)
	_dot.position = Vector2(-1.5, -1.5)
	hud.add_child(_dot)
	_prompt = Label.new()
	_prompt.set_anchors_preset(Control.PRESET_CENTER)
	_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt.offset_left = -400
	_prompt.offset_right = 400
	_prompt.offset_top = 40
	_prompt.offset_bottom = 90
	_prompt.add_theme_color_override("font_color", FG)
	_prompt.add_theme_color_override("font_outline_color", Color.BLACK)
	_prompt.add_theme_constant_override("outline_size", 6)
	hud.add_child(_prompt)
	_subs = VBoxContainer.new()
	_subs.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_subs.offset_left = -520
	_subs.offset_right = 520
	_subs.offset_top = -230
	_subs.offset_bottom = -40
	_subs.alignment = BoxContainer.ALIGNMENT_END
	_subs.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(_subs)
	_status = Label.new()
	_status.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_status.position = Vector2(24, 20)
	_status.add_theme_color_override("font_color", DIM)
	_status.add_theme_color_override("font_outline_color", Color.BLACK)
	_status.add_theme_constant_override("outline_size", 4)
	hud.add_child(_status)
	_card = Label.new()
	_card.set_anchors_preset(Control.PRESET_FULL_RECT)
	_card.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_card.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_card.add_theme_font_size_override("font_size", 34)
	_card.add_theme_color_override("font_color", FG)
	_card.modulate.a = 0.0
	hud.add_child(_card)


func _build_dialog(root: Control) -> void:
	var holder := Control.new()
	holder.set_anchors_preset(Control.PRESET_FULL_RECT)
	holder.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(holder)
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _panel_style())
	p.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	p.offset_left = -560
	p.offset_right = 560
	p.offset_top = -330
	p.offset_bottom = -30
	holder.add_child(p)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	p.add_child(v)
	_dialog_speaker = _label(v, "", 20, ACCENT)
	_dialog_text = _label(v, "", 22)
	_dialog_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_dialog_choices = VBoxContainer.new()
	v.add_child(_dialog_choices)
	_layers["dialog"] = holder


func _build_document(root: Control) -> void:
	var v := _centered_panel(root, "document", 860, 600)
	_doc_title = _label(v, "", 26, ACCENT)
	var sc := ScrollContainer.new()
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(sc)
	_doc_body = RichTextLabel.new()
	_doc_body.fit_content = true
	_doc_body.bbcode_enabled = true
	_doc_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_doc_body.add_theme_color_override("default_color", FG)
	sc.add_child(_doc_body)
	var h := HBoxContainer.new()
	v.add_child(h)
	_button(h, "A−", func() -> void: _bump_text(-2))
	_button(h, "A+", func() -> void: _bump_text(2))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(sp)
	_button(h, "Voltar (Esc)", close_document)


func _build_journal(root: Control) -> void:
	var v := _centered_panel(root, "journal", 900, 620)
	_label(v, "DIÁRIO", 26, ACCENT)
	_journal_obj = _label(v, "", 22)
	_journal_hint = _label(v, "", 20, DIM)
	_journal_hint_btn = _button(v, "Pedir uma pista", func() -> void: hint_requested.emit())
	var sc := ScrollContainer.new()
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(sc)
	var inner := VBoxContainer.new()
	inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(inner)
	_journal_notes = RichTextLabel.new()
	_journal_notes.fit_content = true
	_journal_notes.bbcode_enabled = true
	_journal_notes.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_journal_notes.add_theme_color_override("default_color", FG)
	inner.add_child(_journal_notes)
	_label(inner, "Documentos", 20, ACCENT)
	_journal_docs = VBoxContainer.new()
	inner.add_child(_journal_docs)
	_button(v, "Fechar (J / Esc)", func() -> void: close_modal("journal"))


func _build_pause(root: Control) -> void:
	var v := _centered_panel(root, "pause", 560, 500)
	_label(v, "PAUSA", 28, ACCENT)
	_pause_objective = _label(v, "", 19, DIM)
	_pause_first = _button(v, "Continuar", func() -> void: resume_requested.emit())
	_button(v, "Diário", func() -> void: journal_requested.emit())
	_button(v, "Configurações", func() -> void: open_settings("pause"))
	_button(v, "Voltar ao último checkpoint", func() -> void: checkpoint_requested.emit())
	_button(v, "Menu principal", func() -> void: menu_requested.emit())


func _build_main(root: Control) -> void:
	var holder := Control.new()
	holder.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(holder)
	var bg := _rect(holder, Color(0.0, 0.0, 0.0, 0.35))
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	v.offset_left = 90
	v.offset_right = 700
	v.offset_top = -300
	v.offset_bottom = 320
	v.add_theme_constant_override("separation", 12)
	holder.add_child(v)
	_label(v, "THE SHADOW OVER INNSMOUTH", 44, FG)
	_label(v, "segundo H. P. Lovecraft", 18, DIM)
	_label(v, "Versão 1.1", 18, DIM)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 24)
	v.add_child(gap)
	_continue_btn = _button(v, "Continuar", func() -> void: continue_requested.emit())
	_main_first = _button(v, "Nova partida", func() -> void:
		_confirm_overwrite(func() -> void: new_game_requested.emit()))
	_button(v, "Escolher capítulo", show_chapters)
	_button(v, "Configurações", func() -> void: open_settings("main"))
	_button(v, "Créditos e licenças", func() -> void: show_layer("credits", _credits_first))
	_button(v, "Aviso de conteúdo", func() -> void: show_layer("warning"))
	_button(v, "Sair", func() -> void: quit_requested.emit())
	_layers["main"] = holder


func _build_settings(root: Control) -> void:
	var v := _centered_panel(root, "settings", 820, 640)
	_label(v, "CONFIGURAÇÕES", 26, ACCENT)
	var sc := ScrollContainer.new()
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(sc)
	_settings_box = VBoxContainer.new()
	_settings_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_settings_box.add_theme_constant_override("separation", 6)
	sc.add_child(_settings_box)
	_button(v, "Voltar", _close_settings)


func _build_warning(root: Control) -> void:
	var v := _centered_panel(root, "warning", 880, 580)
	_label(v, "AVISO DE CONTEÚDO", 26, ACCENT)
	_label(v, "Esta adaptação contém horror corporal e transformação, perseguição e confinamento, violência e morte implícitas, menções a sacrifícios humanos e ao massacre de 1846, violência de Estado e prisões sem julgamento, embriaguez, menções a suicídio e a internação psiquiátrica, e o preconceito histórico presente no conto de 1936, que o jogo não endossa.\n\nNão há combate nem violência gráfica. O jogo pode ser pausado a qualquer momento; leitura e menus interrompem todo perigo.\n\nSe algum desses temas tocar você de perto, procure apoio. No Brasil, o CVV atende de graça pelo telefone 188, 24 horas.", 20)
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(sp)
	_button(v, "Entendi", func() -> void: warning_accepted.emit())


func _build_fail(root: Control) -> void:
	var v := _centered_panel(root, "fail", 640, 300)
	_fail_label = _label(v, "", 24)
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(sp)
	_button(v, "Tentar novamente", func() -> void: retry_requested.emit())
	_button(v, "Menu principal", func() -> void: menu_requested.emit())


func _build_chapters(root: Control) -> void:
	var v := _centered_panel(root, "chapters", 620, 600)
	_label(v, "ESCOLHER CAPÍTULO", 26, ACCENT)
	_label(v, "Começa uma partida nova nesse ponto, com o que o narrador teria consigo. Capítulos aparecem aqui depois de alcançados.", 18, DIM)
	_chapters_box = VBoxContainer.new()
	_chapters_box.add_theme_constant_override("separation", 8)
	v.add_child(_chapters_box)
	_button(v, "Voltar", func() -> void: show_main(_continue_btn.visible))


func show_chapters() -> void:
	## Lista só os capítulos já alcançados (docs/16 §2.1); a lista vem das configurações.
	for c in _chapters_box.get_children():
		c.queue_free()
	_chapters_first = null
	var unlocked: Array = _settings_values.get("chapters_unlocked", ["cp00_frame"])
	for c: Array in AppRoot.CHAPTER_STARTS:
		var cp: String = c[1]
		if not unlocked.has(cp):
			continue
		var b := _button(_chapters_box, str(c[0]), func() -> void:
			_confirm_overwrite(func() -> void: chapter_requested.emit(cp)))
		if _chapters_first == null:
			_chapters_first = b
	var hidden := AppRoot.CHAPTER_STARTS.size() - _chapters_box.get_child_count()
	if hidden > 0:
		_label(_chapters_box, "%d capítulo(s) ainda não alcançado(s)." % hidden, 17, DIM)
	show_layer("chapters", _chapters_first)


func _confirm_overwrite(action: Callable) -> void:
	## Substituir o manuscrito em andamento pede confirmação (docs/16 §2.2).
	if not _continue_btn.visible:
		action.call()
		return
	_confirm_action = action
	show_layer("confirm", _confirm_no)


func _build_confirm(root: Control) -> void:
	var v := _centered_panel(root, "confirm", 620, 260)
	_label(v, "Começar outro manuscrito apaga o progresso gravado. Os capítulos já alcançados continuam liberados.", 21)
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(sp)
	_button(v, "Começar mesmo assim", func() -> void:
		var a := _confirm_action
		_confirm_action = Callable()
		if a.is_valid():
			a.call())
	_confirm_no = _button(v, "Voltar", func() -> void: show_main(_continue_btn.visible))


func _build_credits(root: Control) -> void:
	var v := _centered_panel(root, "credits", 860, 620)
	_label(v, "CRÉDITOS E LICENÇAS", 26, ACCENT)
	var sc := ScrollContainer.new()
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(sc)
	var l := _label(sc, CREDITS_TEXT, 18)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_credits_first = _button(v, "Voltar", func() -> void: show_main(_continue_btn.visible))


func _build_end(root: Control) -> void:
	var v := _centered_panel(root, "end", 760, 420)
	_end_title = _label(v, "FIM", 26, ACCENT)
	_end_body = _label(v, "O manuscrito termina aqui.", 21)
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(sp)
	_button(v, "Menu principal", func() -> void: menu_requested.emit())


# ---------------------------------------------------------------- estado

func hide_all() -> void:
	for k: String in _layers.keys():
		_layers[k].visible = false
	modal = ""


func show_layer(key: String, focus: Control = null) -> void:
	for k: String in _layers.keys():
		if k != "hud":
			_layers[k].visible = (k == key)
	modal = key
	if focus:
		focus.call_deferred("grab_focus")


func show_hud() -> void:
	for k: String in _layers.keys():
		_layers[k].visible = (k == "hud")
	modal = ""


func show_main(has_continue: bool) -> void:
	_layers["hud"].visible = false
	_continue_btn.visible = has_continue
	show_layer("main", _continue_btn if has_continue else _main_first)


func show_warning() -> void:
	_layers["hud"].visible = false
	show_layer("warning")


func show_pause(objective: String = "") -> void:
	if objective != "":
		_pause_objective.text = "Objetivo: " + objective
	show_layer("pause", _pause_first)


func show_fail(text: String) -> void:
	_fail_label.text = text
	show_layer("fail")
	var btns: Array = _layers["fail"].find_children("*", "Button", true, false)
	if btns.size() > 0:
		(btns[0] as Button).call_deferred("grab_focus")


func show_end(title: String = "", body: String = "") -> void:
	if _end_default == "":
		_end_default = _end_body.text
	_end_title.text = title if title != "" else "FIM"
	_end_body.text = body if body != "" else _end_default
	show_layer("end")
	var btns: Array = _layers["end"].find_children("*", "Button", true, false)
	if btns.size() > 0:
		(btns[0] as Button).call_deferred("grab_focus")


func close_modal(kind: String) -> void:
	if modal != kind:
		return
	show_hud()
	modal_closed.emit(kind)


func set_prompt(text: String) -> void:
	_prompt.text = text
	_dot.visible = _center_dot and text == ""


func set_status(text: String) -> void:
	_status.text = text


func apply_text_size(size: int) -> void:
	text_size = size
	_prompt.add_theme_font_size_override("font_size", size)
	_dialog_text.add_theme_font_size_override("font_size", size)
	_doc_body.add_theme_font_size_override("normal_font_size", size)
	_doc_body.add_theme_font_size_override("bold_font_size", size)
	_doc_body.add_theme_font_size_override("italics_font_size", size)
	_journal_notes.add_theme_font_size_override("normal_font_size", size - 2)
	_journal_notes.add_theme_font_size_override("italics_font_size", size - 2)
	_journal_notes.add_theme_font_size_override("bold_font_size", size - 2)
	_status.add_theme_font_size_override("font_size", size - 4)


func _bump_text(d: int) -> void:
	setting_changed.emit("text_size", clampi(text_size + d, 16, 36))


# ---------------------------------------------------------------- legendas

func subtitle(text: String, seconds: float = 4.0, kind: String = "speech") -> void:
	## kind: speech | thought | sound | action. Legendas de som respeitam a opção correspondente;
	## "action" descreve algo visível (gesto, letreiro, luz) e aparece sempre.
	if kind == "sound" and not captions_enabled:
		return
	var pc := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, _subtitle_bg)
	sb.set_content_margin_all(8)
	pc.add_theme_stylebox_override("panel", sb)
	var l := Label.new()
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", text_size)
	match kind:
		"thought":
			l.text = text
			l.add_theme_color_override("font_color", Color(0.78, 0.78, 0.86))
		"sound":
			l.text = "[" + text + "]"
			l.add_theme_color_override("font_color", Color(0.75, 0.72, 0.55))
		"action":
			l.text = "(" + text + ")"
			l.add_theme_color_override("font_color", Color(0.70, 0.78, 0.72))
		_:
			l.text = text
			l.add_theme_color_override("font_color", FG)
	pc.add_child(l)
	_subs.add_child(pc)
	while _subs.get_child_count() > 4:
		var old := _subs.get_child(0)
		_subs.remove_child(old)
		old.queue_free()
	# Referência fraca: a legenda pode já ter sido descartada pelo limite de linhas.
	var ref: WeakRef = weakref(pc)
	var timer := get_tree().create_timer(seconds, false)
	timer.timeout.connect(func() -> void:
		var node: Object = ref.get_ref()
		if node != null:
			(node as Node).queue_free())


func clear_subtitles() -> void:
	for c in _subs.get_children():
		c.queue_free()


func chapter_card(text: String, seconds: float = 4.0) -> void:
	_card.text = text
	var t := create_tween()
	t.tween_property(_card, "modulate:a", 1.0, 1.0)
	t.tween_interval(maxf(0.5, seconds - 2.0))
	t.tween_property(_card, "modulate:a", 0.0, 1.0)


func fade_to(alpha: float, seconds: float) -> Tween:
	var t := create_tween()
	t.tween_property(_fade, "modulate:a", alpha, seconds)
	return t


func set_eyes(closed_amount: float) -> void:
	_eyes.modulate.a = clampf(closed_amount, 0.0, 1.0)


# ---------------------------------------------------------------- diálogo

func show_dialog(speaker: String, text: String, choices: Array) -> void:
	_dialog_speaker.text = speaker
	_dialog_text.text = text
	for c in _dialog_choices.get_children():
		c.queue_free()
	var first: Button = null
	for i in choices.size():
		var idx := i
		var b := _button(_dialog_choices, str(choices[i]), func() -> void: dialog_choice.emit(idx))
		if first == null:
			first = b
	show_layer("dialog", first)


# ---------------------------------------------------------------- documentos e diário

func show_document(title: String, body: String, from: String = "") -> void:
	_doc_title.text = title
	_doc_body.text = body
	_doc_open_from = from
	show_layer("document")


func close_document() -> void:
	if modal != "document":
		return
	if _doc_open_from == "journal":
		show_layer("journal", _journal_hint_btn)
		return
	show_hud()
	modal_closed.emit("document")


func show_journal(objective: String, hint: String, can_hint: bool, notes: Array, docs: Array) -> void:
	_journal_obj.text = "Objetivo: " + objective
	_journal_hint.text = hint
	_journal_hint_btn.disabled = not can_hint
	var bb := ""
	for n: String in notes:
		bb += "[i]" + n + "[/i]\n\n"
	_journal_notes.text = bb
	for c in _journal_docs.get_children():
		c.queue_free()
	for d: Dictionary in docs:
		var title: String = d["title"]
		var body: String = d["body"]
		_button(_journal_docs, title, func() -> void: show_document(title, body, "journal"))
	show_layer("journal", _journal_hint_btn)


func update_journal_hint(hint: String, can_hint: bool) -> void:
	_journal_hint.text = hint
	_journal_hint_btn.disabled = not can_hint


# ---------------------------------------------------------------- configurações

func set_settings_values(v: Dictionary) -> void:
	_settings_values = v.duplicate(true)
	captions_enabled = bool(v.get("sound_captions", true))
	_subtitle_bg = float(v.get("subtitle_bg", 0.78))
	_center_dot = bool(v.get("center_dot", true))
	if _dot:
		_dot.visible = _center_dot and _prompt.text == ""


func open_settings(from: String) -> void:
	_settings_return = from
	_rebuild_settings()
	show_layer("settings")
	var first := _settings_box.find_children("*", "Control", true, false)
	for c: Node in first:
		if c is Slider or c is Button:
			(c as Control).call_deferred("grab_focus")
			break


func _close_settings() -> void:
	_rebinding = ""
	if _settings_return == "pause":
		show_pause()
	else:
		show_main(_continue_btn.visible)


func _rebuild_settings() -> void:
	for c in _settings_box.get_children():
		c.queue_free()
	_rebind_buttons.clear()
	_calib.clear()
	_label(_settings_box, "Imagem", 20, ACCENT)
	_slider("Brilho", "brightness", 0.6, 1.6, 0.05)
	_build_calibration()
	_check("Resolução do mundo 360 linhas (mais legível)", "internal_height", true)
	_check("Efeitos retrô (pontilhado, cores, grão)", "dither")
	_slider("Intensidade do efeito retrô", "retro_strength", 0.0, 1.0, 0.05)
	_check("Tela cheia", "fullscreen")
	_check("Sincronização vertical (V-Sync)", "vsync")
	_label(_settings_box, "Som", 20, ACCENT)
	_slider("Volume geral", "master_volume", 0.0, 1.0, 0.05)
	_slider("Ambiente", "ambience_volume", 0.0, 1.0, 0.05)
	_slider("Efeitos", "effects_volume", 0.0, 1.0, 0.05)
	_label(_settings_box, "Texto e legendas", 20, ACCENT)
	_slider("Tamanho do texto", "text_size", 16, 36, 1)
	_slider("Fundo das legendas", "subtitle_bg", 0.0, 1.0, 0.05)
	_check("Legendas de sons", "sound_captions")
	_label(_settings_box, "Câmera e conforto", 20, ACCENT)
	_slider("Sensibilidade do mouse", "mouse_sensitivity", 0.03, 0.4, 0.01)
	_slider("Campo de visão", "fov", 60.0, 100.0, 1.0)
	_check("Inverter eixo vertical", "invert_y")
	_check("Ponto central na tela", "center_dot")
	_check("Balanço de cabeça ao andar", "head_bob")
	_label(_settings_box, "Acessibilidade", 20, ACCENT)
	_check("Agachar alterna (em vez de segurar)", "toggle_crouch")
	_check("Segurar em vez de pressionar repetidamente", "hold_instead_of_mash")
	_check("Fuga assistida (prazos maiores nas perseguições)", "assisted_escape")
	_label(_settings_box, "Teclas (clique e pressione a nova tecla)", 20, ACCENT)
	var keys: Dictionary = _settings_values.get("keys", {})
	for action: String in InputSetup.ACTIONS:
		var h := HBoxContainer.new()
		_settings_box.add_child(h)
		var l := _label(h, InputSetup.LABELS[action], 19)
		l.custom_minimum_size = Vector2(330, 0)
		var code: int = int(keys.get(action, InputSetup.DEFAULT_KEYS[action]))
		var a := action
		var b := _button(h, InputSetup.key_name(code), func() -> void: _begin_rebind(a))
		_rebind_buttons[action] = b
	_button(_settings_box, "Restaurar teclas padrão", func() -> void:
		for action: String in InputSetup.ACTIONS:
			key_rebound.emit(action, int(InputSetup.DEFAULT_KEYS[action]))
		call_deferred("_rebuild_settings"))


func _slider(title: String, key: String, mn: float, mx: float, step: float) -> void:
	var h := HBoxContainer.new()
	_settings_box.add_child(h)
	var l := _label(h, title, 19)
	l.custom_minimum_size = Vector2(330, 0)
	var s := HSlider.new()
	s.min_value = mn
	s.max_value = mx
	s.step = step
	s.value = float(_settings_values.get(key, mn))
	s.custom_minimum_size = Vector2(300, 28)
	s.focus_mode = Control.FOCUS_ALL
	h.add_child(s)
	var val := _label(h, _fmt(s.value), 19, DIM)
	s.value_changed.connect(func(x: float) -> void:
		val.text = _fmt(x)
		var out: Variant = int(x) if key == "text_size" else x
		_settings_values[key] = out
		if key == "brightness":
			_update_calibration()
		setting_changed.emit(key, out))


func _build_calibration() -> void:
	## Calibração de brilho (docs/16 §4): três tons escuros passam pela mesma curva de gama do mundo.
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	_settings_box.add_child(h)
	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.custom_minimum_size = Vector2(330, 56)
	h.add_child(bg)
	for i in 3:
		var r := ColorRect.new()
		r.custom_minimum_size = Vector2(56, 40)
		r.position = Vector2(14 + i * 104, 8)
		bg.add_child(r)
		_calib.append(r)
	var l := _label(h, "Ajuste até que o quadrado da esquerda quase desapareça e o do meio continue visível.", 17, DIM)
	l.custom_minimum_size = Vector2(380, 0)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_update_calibration()


func _update_calibration() -> void:
	var g := float(_settings_values.get("brightness", 1.0))
	var tones: Array[float] = [0.012, 0.035, 0.09]
	for i in _calib.size():
		var v := pow(tones[i], 1.0 / g)
		_calib[i].color = Color(v, v, v)


func _fmt(x: float) -> String:
	return str(int(x)) if absf(x - roundf(x)) < 0.001 else "%.2f" % x


func _check(title: String, key: String, is_height: bool = false) -> void:
	var c := CheckButton.new()
	c.text = title
	c.add_theme_font_size_override("font_size", 19)
	c.add_theme_color_override("font_color", FG)
	c.add_theme_color_override("font_focus_color", ACCENT)
	if is_height:
		c.button_pressed = int(_settings_values.get(key, 240)) == 360
	else:
		c.button_pressed = bool(_settings_values.get(key, false))
	c.toggled.connect(func(on: bool) -> void:
		var out: Variant = (360 if on else 240) if is_height else on
		_settings_values[key] = out
		if key == "sound_captions":
			captions_enabled = on
		setting_changed.emit(key, out))
	_settings_box.add_child(c)


func _begin_rebind(action: String) -> void:
	_rebinding = action
	(_rebind_buttons[action] as Button).text = "…"


func _input(event: InputEvent) -> void:
	if _rebinding != "" and event is InputEventKey and event.pressed and not event.echo:
		var code: int = (event as InputEventKey).physical_keycode
		if code == 0:
			code = (event as InputEventKey).keycode
		var action := _rebinding
		_rebinding = ""
		var keys: Dictionary = _settings_values.get("keys", {})
		keys[action] = code
		_settings_values["keys"] = keys
		(_rebind_buttons[action] as Button).text = InputSetup.key_name(code)
		key_rebound.emit(action, code)
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		match modal:
			"document":
				close_document()
				get_viewport().set_input_as_handled()
			"journal":
				close_modal("journal")
				get_viewport().set_input_as_handled()
			"settings":
				_close_settings()
				get_viewport().set_input_as_handled()
			"chapters", "credits", "confirm":
				show_main(_continue_btn.visible)
				get_viewport().set_input_as_handled()
			"pause":
				resume_requested.emit()
				get_viewport().set_input_as_handled()
	elif event.is_action_pressed("journal") and modal == "journal":
		close_modal("journal")
		get_viewport().set_input_as_handled()
