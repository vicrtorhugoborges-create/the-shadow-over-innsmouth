class_name Door
extends Interactable
## Porta com dobradiça visível, ferrolho e estados físicos (docs/08 §2).
## `opens_toward_player` descreve o lado de quem está no cômodo de referência (`ref_room`).

enum State { CLOSED, OPEN, AJAR, BROKEN }

var state: State = State.CLOSED
var bolted := false
var locked_other_side := false
var has_bolt := true
var ref_room := ""
var opens_toward_ref := false
var width := 0.9
var height := 2.05

var _hinge: Node3D
var _leaf: MeshInstance3D
var _open_sign := 1.0
var _tween: Tween


func build(p_id: String, w: float, h: float, wall_axis_x: bool, open_sign: float, leaf_mat: Material) -> Door:
	id = p_id
	name = p_id
	width = w
	height = h
	_open_sign = open_sign
	_hinge = Node3D.new()
	add_child(_hinge)
	# A dobradiça fica numa borda; a folha se estende ao longo da parede.
	var along := Vector3(w, h, 0.06) if wall_axis_x else Vector3(0.06, h, w)
	var center := Vector3(w * 0.5, h * 0.5, 0) if wall_axis_x else Vector3(0, h * 0.5, w * 0.5)
	_leaf = MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = along
	_leaf.mesh = bm
	_leaf.material_override = leaf_mat
	_leaf.position = center
	_hinge.add_child(_leaf)
	# Dobradiças: dois blocos escuros, visíveis do lado para o qual a porta abre.
	for yy: float in [0.35, h - 0.35]:
		var hm := MeshInstance3D.new()
		var hb := BoxMesh.new()
		hb.size = Vector3(0.05, 0.14, 0.05)
		hm.mesh = hb
		hm.material_override = TexFactory.flat(Color(0.08, 0.07, 0.06))
		# rotation.y > 0 leva +X para -Z e +Z para +X: as dobradiças ficam do lado da abertura.
		hm.position = Vector3(0.0, yy, -0.05 * open_sign) if wall_axis_x else Vector3(0.05 * open_sign, yy, 0.0)
		_hinge.add_child(hm)
	body = StaticBody3D.new()
	body.collision_layer = 1 | 2
	body.collision_mask = 0
	var cs := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = along
	cs.shape = box
	cs.position = center
	body.add_child(cs)
	_hinge.add_child(body)
	return self


func set_state(s: State, animate: bool = true) -> void:
	state = s
	var angle := 0.0
	match s:
		State.OPEN, State.BROKEN:
			angle = 95.0
		State.AJAR:
			angle = 28.0
	var target := deg_to_rad(angle) * _open_sign
	if _tween:
		_tween.kill()
	if animate:
		_tween = create_tween()
		_tween.tween_property(_hinge, "rotation:y", target, 0.45).set_trans(Tween.TRANS_SINE)
	else:
		_hinge.rotation.y = target
	if s == State.BROKEN:
		_leaf.rotation.z = 0.12


func is_passable() -> bool:
	return state != State.CLOSED


func shake(strength: float = 1.0) -> void:
	if state != State.CLOSED:
		return
	var base := _hinge.rotation.y
	var t := create_tween()
	t.tween_property(_hinge, "rotation:y", base + 0.035 * strength * _open_sign, 0.05)
	t.tween_property(_hinge, "rotation:y", base, 0.12)


func push_partly(amount_deg: float) -> void:
	## A porta começa a se abrir para dentro (chave-mestra girando).
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_hinge, "rotation:y", deg_to_rad(amount_deg) * _open_sign, 1.6)


func splinter(level: int) -> void:
	_leaf.rotation.x = 0.02 * level
	var m := StandardMaterial3D.new()
	var src := _leaf.material_override as StandardMaterial3D
	if src:
		m = src.duplicate()
		m.albedo_color = Color(1, 1 - 0.12 * level, 1 - 0.18 * level)
		_leaf.material_override = m
