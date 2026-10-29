class_name Player
extends CharacterBody3D
## Controle em primeira pessoa (sys_player + sys_camera). Sem combate.
## Andar, correr (ruidoso), agachar, andar arrastado; lanterna; raio de interação.

signal footstep(surface: String, loudness: float)
signal interact_requested(target: Interactable)
signal flashlight_toggled(on: bool)

const WALK := 2.3
const RUN := 4.3
const CROUCH := 1.2
const SHAMBLE := 1.35
const STAND_H := 1.62
const CROUCH_H := 1.0
const REACH := 2.3

var controls_enabled := true
var look_enabled := true
var sensitivity := 0.12
var invert_y := false
var toggle_crouch := false
var head_bob := false
var has_flashlight := false
## Sentado (ônibus, cais de Zadok): olhar e interagir, sem andar.
var seated := false
var surface := "wood"

var crouching := false
var shambling := false
var running := false
var focused: Interactable = null

var camera: Camera3D
var flashlight: SpotLight3D
var _head: Node3D
var _ray: RayCast3D
var _pitch := 0.0
var _step_accum := 0.0
var _bob_t := 0.0
var _eye_h := STAND_H
var _shake := 0.0


func _ready() -> void:
	collision_layer = 1
	collision_mask = 1 | 8
	floor_max_angle = deg_to_rad(50.0)
	floor_snap_length = 0.3
	var shape := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.28
	cap.height = 1.7
	shape.shape = cap
	shape.position.y = 0.85
	add_child(shape)
	_head = Node3D.new()
	_head.position.y = STAND_H
	add_child(_head)
	camera = Camera3D.new()
	camera.near = 0.05
	camera.far = 140.0
	camera.fov = 75.0
	_head.add_child(camera)
	camera.make_current()
	flashlight = SpotLight3D.new()
	flashlight.light_color = Color(1.0, 0.86, 0.62)
	flashlight.light_energy = 4.0
	flashlight.spot_range = 18.0
	flashlight.spot_angle = 24.0
	flashlight.spot_attenuation = 1.2
	flashlight.shadow_enabled = true
	flashlight.visible = false
	flashlight.position = Vector3(0.12, -0.12, 0.0)
	camera.add_child(flashlight)
	_ray = RayCast3D.new()
	_ray.target_position = Vector3(0, 0, -REACH)
	_ray.collide_with_areas = true
	_ray.collide_with_bodies = true
	_ray.collision_mask = 1 | 2
	_ray.add_exception(self)
	camera.add_child(_ray)


func apply_look(relative: Vector2) -> void:
	if not look_enabled:
		return
	var s := sensitivity * 0.01
	rotate_y(-relative.x * s)
	var dy := relative.y * s * (-1.0 if invert_y else 1.0)
	_pitch = clampf(_pitch - dy, deg_to_rad(-85.0), deg_to_rad(85.0))
	_head.rotation.x = _pitch


func set_view(yaw: float, pitch: float) -> void:
	rotation.y = yaw
	_pitch = pitch
	_head.rotation.x = pitch


func get_pitch() -> float:
	return _pitch


func set_eye_height(h: float) -> void:
	_eye_h = h


func add_shake(amount: float) -> void:
	_shake = maxf(_shake, amount)


func toggle_flashlight() -> void:
	if not has_flashlight:
		return
	flashlight.visible = not flashlight.visible
	flashlight_toggled.emit(flashlight.visible)


func is_flashlight_on() -> bool:
	return flashlight.visible


func handle_input(event: InputEvent) -> bool:
	## Chamado pelo AppRoot: o jogador vive dentro do SubViewport e não depende da propagação.
	if not controls_enabled:
		return false
	if event.is_action_pressed("interact"):
		if focused != null:
			interact_requested.emit(focused)
			return true
	elif event.is_action_pressed("flashlight"):
		toggle_flashlight()
		return true
	elif toggle_crouch and event.is_action_pressed("crouch"):
		crouching = not crouching
		return true
	return false


func _physics_process(delta: float) -> void:
	var gp := Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
	if gp.length() > 0.2 and look_enabled:
		apply_look(gp * 900.0 * delta)
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	var input := Vector2.ZERO
	if controls_enabled and not seated:
		input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		if not toggle_crouch:
			crouching = Input.is_action_pressed("crouch")
		shambling = Input.is_action_pressed("shamble") and not crouching
		running = Input.is_action_pressed("run") and not crouching and not shambling and input.y < 0.1
	else:
		running = false
	var speed := WALK
	if crouching:
		speed = CROUCH
	elif shambling:
		speed = SHAMBLE
	elif running:
		speed = RUN
	var dir := (transform.basis * Vector3(input.x, 0.0, input.y))
	dir.y = 0.0
	if dir.length() > 1.0:
		dir = dir.normalized()
	var target := dir * speed
	velocity.x = move_toward(velocity.x, target.x, 18.0 * delta)
	velocity.z = move_toward(velocity.z, target.z, 18.0 * delta)
	move_and_slide()
	_update_head(delta)
	_update_steps(delta)
	_update_focus()


func _update_head(delta: float) -> void:
	var goal := CROUCH_H if crouching else _eye_h
	_head.position.y = move_toward(_head.position.y, goal, delta * 3.0)
	var off := Vector3.ZERO
	var hspeed := Vector2(velocity.x, velocity.z).length()
	if head_bob and hspeed > 0.3 and is_on_floor():
		_bob_t += delta * hspeed * 2.6
		off.y = sin(_bob_t) * 0.025
	if shambling and hspeed > 0.3:
		# Balanço lateral do andar arrastado: cue visual sutil, sempre ativo (não é head bob).
		_bob_t += delta * 3.0
		off.x = sin(_bob_t) * 0.03
	if _shake > 0.0:
		off += Vector3(randf_range(-1, 1), randf_range(-1, 1), 0) * _shake * 0.03
		_shake = maxf(0.0, _shake - delta * 2.5)
	camera.position = off


func _update_steps(delta: float) -> void:
	var hspeed := Vector2(velocity.x, velocity.z).length()
	if hspeed < 0.4 or not is_on_floor():
		_step_accum = 0.0
		return
	_step_accum += hspeed * delta
	var stride := 0.75 if not running else 1.05
	if _step_accum >= stride:
		_step_accum = 0.0
		var loud := 0.5
		if running:
			loud = 1.0
		elif crouching:
			loud = 0.15
		elif shambling:
			loud = 0.35
		footstep.emit(surface, loud)


func _update_focus() -> void:
	var found: Interactable = null
	if controls_enabled and _ray.is_colliding():
		var n: Node = _ray.get_collider()
		while n != null and not (n is Interactable):
			n = n.get_parent()
		if n is Interactable and (n as Interactable).get_prompt() != "":
			found = n
	focused = found
