class_name Interactable
extends Node3D
## Objeto examinável/utilizável (sys_interaction). O texto e a ação vêm do controlador do capítulo:
## o objeto não concede itens nem altera progressão por conta própria.

var id: String = ""
## Retorna o texto do prompt ("" = indisponível agora).
var prompt_provider: Callable = Callable()
## Executa a ação. Recebe este objeto.
var on_use: Callable = Callable()
var body: StaticBody3D


func setup(p_id: String, size: Vector3, offset: Vector3 = Vector3.ZERO, solid: bool = true) -> Interactable:
	id = p_id
	name = p_id
	body = StaticBody3D.new()
	body.collision_layer = 2 | (1 if solid else 0)
	body.collision_mask = 0
	var cs := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	cs.shape = box
	cs.position = offset
	body.add_child(cs)
	add_child(body)
	return self


func get_prompt() -> String:
	if prompt_provider.is_valid():
		return str(prompt_provider.call())
	return ""


func use() -> void:
	if on_use.is_valid():
		on_use.call(self)
