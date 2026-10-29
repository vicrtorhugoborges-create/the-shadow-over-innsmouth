class_name FigureAnimator
extends Node
## Andar simples das figuras de `FigureKit`: balança pernas e braços pela velocidade do nó no
## espaço do pai (uma figura dentro do ônibus não "anda" com o ônibus) e respira quando parada.
## Pausa junto com a árvore.

var root: Node3D
var body: Node3D
var legs: Array[Node3D] = []
var arms: Array[Node3D] = []
var gait := 1.0
var hop := 0.0
var arm_rest := 0.0
var base_y := 0.0
var seated := false

var _last := Vector3.INF
var _speed := 0.0
var _phase := 0.0
var _t := 0.0


func _ready() -> void:
	_t = randf() * 10.0
	for a in arms:
		a.rotation.x = arm_rest


func _process(delta: float) -> void:
	if delta <= 0.0 or root == null:
		return
	var p := root.position
	if _last != Vector3.INF:
		var d := p - _last
		d.y = 0.0
		# Teleportes (respawn, troca de cena) não viram corrida.
		var sp := d.length() / delta
		if sp > 8.0:
			sp = 0.0
		_speed = lerpf(_speed, sp, clampf(delta * 8.0, 0.0, 1.0))
	_last = p
	_t += delta
	var k := clampf(_speed / 1.2, 0.0, 1.0)
	if seated or (k < 0.02 and absf(_phase) < 0.001):
		_breathe()
		return
	_phase += delta * (2.2 + _speed * 3.0)
	if k < 0.02:
		_phase = 0.0
	var s := sin(_phase) * 0.55 * gait * k
	for i in legs.size():
		legs[i].rotation.x = s if i == 0 else -s
	for j in arms.size():
		arms[j].rotation.x = arm_rest + (-s * 0.7 if j == 0 else s * 0.7)
	if body:
		body.position.y = base_y + absf(sin(_phase)) * (0.025 + hop) * k


func _breathe() -> void:
	if body:
		body.position.y = base_y + sin(_t * 1.6) * 0.004
	for j in arms.size():
		arms[j].rotation.x = arm_rest + sin(_t * 1.6 + j) * 0.015
