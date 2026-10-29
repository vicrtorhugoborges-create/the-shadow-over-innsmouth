class_name Pushable
extends Interactable
## Móvel empurrável até um destino fixo (barricada). Deslizamento roteirizado e confiável,
## em vez de física livre (docs/08 §2, pz07_barricade).

var at_target := false
var target: Transform3D
var start_xform: Transform3D


func build_box(p_id: String, size: Vector3, mat: Material) -> Pushable:
	setup(p_id, size, Vector3(0, size.y * 0.5, 0))
	var mi := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = size
	mi.mesh = bm
	mi.material_override = mat
	mi.position.y = size.y * 0.5
	add_child(mi)
	return self


func set_target(t: Transform3D) -> void:
	start_xform = transform
	target = t


func slide(duration: float) -> Tween:
	var tw := create_tween()
	tw.tween_property(self, "transform", target, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	at_target = true
	return tw


func snap_to_target() -> void:
	transform = target
	at_target = true
