class_name ChartPanel
extends Control
## Quadro genealógico (pz12_genealogy, docs/12). Emite intenções; o capítulo decide os fatos.
## Fichas disponíveis dependem dos documentos já lidos; nenhuma posição bloqueia o progresso
## sem pista: os documentos da mesa liberam todas as fichas necessárias.

signal placed(slot_id: String, card_id: String, correct: bool)
signal closed

const FG := Color(0.86, 0.83, 0.74)
const ACCENT := Color(0.72, 0.62, 0.38)
const OK := Color(0.55, 0.75, 0.5)

var _rows: Dictionary = {}
var _labels: Dictionary = {}
var _cards_by_index: Dictionary = {}
var _status: Label
var _first: Control


func build(slots: Array, cards: Dictionary, available: Array[String], solved: Dictionary, text_size: int) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.6)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(dim)
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.05, 0.045, 0.035, 0.97)
	sb.border_color = Color(0.35, 0.3, 0.2)
	sb.set_border_width_all(1)
	sb.set_content_margin_all(20)
	p.add_theme_stylebox_override("panel", sb)
	p.set_anchors_preset(Control.PRESET_CENTER)
	p.custom_minimum_size = Vector2(1040, 620)
	p.offset_left = -520
	p.offset_right = 520
	p.offset_top = -310
	p.offset_bottom = 310
	add_child(p)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	p.add_child(v)
	var title := Label.new()
	title.text = "A FAMÍLIA DE MINHA MÃE"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", ACCENT)
	v.add_child(title)
	var intro := Label.new()
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.text = "Você — nascido em Toledo, Ohio. Sua mãe, já falecida. Escolha a ficha de cada posição; só os documentos lidos oferecem fichas."
	intro.add_theme_font_size_override("font_size", text_size - 2)
	intro.add_theme_color_override("font_color", FG)
	v.add_child(intro)
	for s: Array in slots:
		var slot_id: String = s[0]
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 12)
		v.add_child(h)
		var l := Label.new()
		l.text = s[1]
		l.custom_minimum_size = Vector2(300, 0)
		l.add_theme_font_size_override("font_size", text_size - 2)
		l.add_theme_color_override("font_color", FG)
		h.add_child(l)
		var ob := OptionButton.new()
		ob.custom_minimum_size = Vector2(640, 34)
		ob.clip_text = true
		ob.fit_to_longest_item = false
		ob.add_theme_font_size_override("font_size", text_size - 4)
		ob.focus_mode = Control.FOCUS_ALL
		ob.add_item("—")
		var ids: Array[String] = []
		for cid: String in cards.keys():
			if available.has(cid):
				ob.add_item(str(cards[cid][0]))
				ids.append(cid)
		_cards_by_index[slot_id] = ids
		if solved.has(slot_id):
			var idx := ids.find(str(solved[slot_id]))
			if idx >= 0:
				ob.select(idx + 1)
			ob.disabled = true
			l.add_theme_color_override("font_color", OK)
		ob.item_selected.connect(func(i: int) -> void: _on_pick(slot_id, i, ob, l))
		h.add_child(ob)
		_rows[slot_id] = ob
		_labels[slot_id] = l
		if _first == null and not ob.disabled:
			_first = ob
	_status = Label.new()
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status.add_theme_font_size_override("font_size", text_size - 2)
	_status.add_theme_color_override("font_color", Color(0.78, 0.78, 0.86))
	_status.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(_status)
	var close := Button.new()
	close.text = "Fechar (Esc)"
	close.add_theme_font_size_override("font_size", 20)
	close.pressed.connect(func() -> void: closed.emit())
	v.add_child(close)
	if _first == null:
		_first = close
	_first.call_deferred("grab_focus")


func say(text: String) -> void:
	_status.text = text


func _on_pick(slot_id: String, index: int, _ob: OptionButton, _label: Label) -> void:
	if index <= 0:
		return
	var card: String = _cards_by_index[slot_id][index - 1]
	# O capítulo responde com `confirm` ou `reject`.
	placed.emit(slot_id, card, false)


func confirm(slot_id: String) -> void:
	var ob: OptionButton = _rows[slot_id]
	ob.disabled = true
	(_labels[slot_id] as Label).add_theme_color_override("font_color", OK)


func reject(slot_id: String) -> void:
	(_rows[slot_id] as OptionButton).select(0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		closed.emit()
