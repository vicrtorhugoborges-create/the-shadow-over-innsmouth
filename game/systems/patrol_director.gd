class_name PatrolDirector
extends RefCounted
## Grupos roteirizados da fuga noturna (sys_pursuit / PatrolDirector, docs/09 §5 e docs/11 §4–5).
## Lógica pura: o capítulo fornece a posição e o estado do jogador e uma função de linha de visão.
## Os grupos não "pensam": seguem trilhas fixas e reagem a suspeita, sem pathfinding livre.

const SUSPICIOUS_AT := 0.35
const CALM_AT := 0.15
const MIN_SUSPICIOUS_TIME := 1.0
const CAPTURE_DIST := 1.6
const CHASE_SPEED := 3.8
const CHASE_SPEED_ASSIST := 3.2
const LOST_WINDOW := 5.0
const LOST_WINDOW_ASSIST := 10.0
const RATE := 0.5
const RATE_ASSIST := 0.3
const DECAY := 0.25
const DECAY_ASSIST := 0.4


class Group:
	var id: String
	var path: Array[Vector3] = []
	var speed := 1.4
	var idx := 1
	var pos := Vector3.ZERO
	var heading := Vector3.FORWARD
	var state := "hold"
	var suspicion := 0.0
	var sus_time := 0.0
	var lost_t := 0.0
	var last_seen := Vector3.ZERO
	var perceive := true
	var view_range := 30.0
	var half_angle := 55.0
	var min_df := 0.0
	var members := 1
	var loop := false


var groups: Dictionary = {}
var assisted := false
## Callable(from: Vector3, to: Vector3) -> bool. Sem ela, presume-se visão livre.
var los: Callable = Callable()


func add_group(id: String, path: Array[Vector3], speed: float, opts: Dictionary = {}) -> Group:
	var g := Group.new()
	g.id = id
	g.path = path
	g.speed = speed
	g.pos = path[0]
	if path.size() > 1:
		g.heading = (path[1] - path[0]).normalized()
	g.perceive = bool(opts.get("perceive", true))
	g.view_range = float(opts.get("range", 30.0))
	g.min_df = float(opts.get("min_df", 0.0))
	g.members = int(opts.get("members", 1))
	g.loop = bool(opts.get("loop", false))
	# Membros adicionais ampliam o cone ±15° cada, até 4 (docs/11 §4.1).
	g.half_angle = 55.0 + 15.0 * mini(maxi(g.members - 1, 0), 4)
	g.state = "hold" if bool(opts.get("hold", true)) else "patrol"
	groups[id] = g
	return g


func release(id: String) -> void:
	var g: Group = groups.get(id, null)
	if g and g.state == "hold":
		g.state = "patrol"


func remove(id: String) -> void:
	groups.erase(id)


func get_group(id: String) -> Group:
	return groups.get(id, null)


static func visibility(light: float, gait: String, in_moon: bool, dist: float, view_range: float, min_df: float) -> float:
	## Produto de fatores (docs/11 §4.1). Monotônica: mais luz ou passo mais ruidoso nunca reduz.
	if dist > view_range:
		return 0.0
	var g := 1.0
	match gait:
		"still":
			g = 0.3
		"crouch":
			g = 0.4
		"walk":
			g = 1.0
		"run":
			g = 1.8
		"shamble":
			# Engana apenas ao longe e ao luar [C "my stratagem must have deceived them"].
			if dist < 6.0:
				g = 0.8
			elif in_moon:
				g = 0.15
			else:
				g = 1.0
	var df := 1.0
	if dist > 5.0:
		df = lerpf(1.0, min_df, clampf((dist - 5.0) / maxf(view_range - 5.0, 0.01), 0.0, 1.0))
	return light * g * df


static func light_factor(in_moon: bool, flashlight: bool) -> float:
	if flashlight:
		return 2.5
	return 1.0 if in_moon else 0.45


func noise(at: Vector3, radius: float) -> Array[String]:
	## O grupo perceptivo mais próximo dentro do raio vira para o som e fica suspeito.
	var out: Array[String] = []
	var best: Group = null
	var best_d := radius
	for g: Group in groups.values():
		if not g.perceive or g.state not in ["patrol", "hold", "suspicious"]:
			continue
		var d := Vector2(g.pos.x - at.x, g.pos.z - at.z).length()
		if d <= best_d:
			best = g
			best_d = d
	if best:
		best.suspicion = maxf(best.suspicion, 0.45)
		var to := at - best.pos
		to.y = 0
		if to.length() > 0.01:
			best.heading = to.normalized()
		if best.state != "suspicious":
			best.state = "suspicious"
			best.sus_time = 0.0
			out.append("suspicious:" + best.id)
	return out


func advance(delta: float, p: Dictionary) -> Array[String]:
	## p: pos (Vector3), gait (String), in_moon (bool), hidden (bool), flash (bool)
	var out: Array[String] = []
	var ppos: Vector3 = p.get("pos", Vector3.ZERO)
	var hidden := bool(p.get("hidden", false))
	var rate := RATE_ASSIST if assisted else RATE
	var decay := DECAY_ASSIST if assisted else DECAY
	for g: Group in groups.values():
		match g.state:
			"patrol":
				_move_along(g, delta, out)
			"chasing":
				# Persegue a última posição vista; escondido, o jogador não é capturado (docs/09 §7).
				var seen := not hidden and _sees(g, ppos)
				if seen:
					g.last_seen = ppos
				var dp := Vector2(ppos.x - g.pos.x, ppos.z - g.pos.z).length()
				if dp <= CAPTURE_DIST and not hidden:
					out.append("fail:CAPTURE")
					return out
				var to := g.last_seen - g.pos
				to.y = 0
				var d := to.length()
				var spd := CHASE_SPEED_ASSIST if assisted else CHASE_SPEED
				if d > 0.05:
					g.heading = to / d
					g.pos += g.heading * minf(spd * delta, d)
				if not seen:
					g.lost_t += delta
					if g.lost_t >= (LOST_WINDOW_ASSIST if assisted else LOST_WINDOW):
						g.state = "returning"
						g.suspicion = 0.0
						out.append("lost:" + g.id)
				else:
					g.lost_t = 0.0
				continue
			"returning":
				var target := g.path[clampi(g.idx - 1, 0, g.path.size() - 1)]
				var to2 := target - g.pos
				to2.y = 0
				if to2.length() < 0.3:
					g.state = "patrol"
				else:
					g.heading = to2.normalized()
					g.pos += g.heading * minf(g.speed * delta, to2.length())
				continue
			"done":
				continue
		if not g.perceive or g.state == "done":
			continue
		var vis := _visibility_for(g, p)
		if vis > 0.0:
			g.suspicion = minf(1.0, g.suspicion + vis * rate * delta)
		else:
			g.suspicion = maxf(0.0, g.suspicion - decay * delta)
		if g.state in ["patrol", "hold"] and g.suspicion >= SUSPICIOUS_AT:
			g.state = "suspicious"
			g.sus_time = 0.0
			out.append("suspicious:" + g.id)
		elif g.state == "suspicious":
			g.sus_time += delta
			if vis > 0.0:
				var to3 := ppos - g.pos
				to3.y = 0
				if to3.length() > 0.01:
					g.heading = to3.normalized()
			if g.suspicion >= 1.0 and g.sus_time >= MIN_SUSPICIOUS_TIME:
				# Justiça: nunca alerta sem passar ≥ 1 s audível/visível em suspeita.
				g.state = "chasing"
				g.lost_t = 0.0
				g.last_seen = ppos
				out.append("alert:" + g.id)
				for other: Group in groups.values():
					if other != g and other.perceive and other.state in ["patrol", "hold"] and other.pos.distance_to(g.pos) < 50.0:
						other.suspicion = maxf(other.suspicion, 0.5)
			elif g.suspicion < CALM_AT:
				g.state = "patrol"
				out.append("calm:" + g.id)
	return out


func _visibility_for(g: Group, p: Dictionary) -> float:
	if bool(p.get("hidden", false)):
		return 0.0
	var ppos: Vector3 = p.get("pos", Vector3.ZERO)
	var to := ppos - g.pos
	to.y = 0
	var d := to.length()
	if d > g.view_range:
		return 0.0
	if d > 0.5:
		var ang := rad_to_deg(g.heading.angle_to(to.normalized()))
		if ang > g.half_angle:
			return 0.0
	if not _sees(g, ppos):
		return 0.0
	var in_moon := bool(p.get("in_moon", false))
	var flash := bool(p.get("flash", false))
	return visibility(light_factor(in_moon, flash), str(p.get("gait", "walk")), in_moon, d, g.view_range, g.min_df)


func _sees(g: Group, ppos: Vector3) -> bool:
	if los.is_valid():
		return bool(los.call(g.pos + Vector3(0, 1.5, 0), ppos + Vector3(0, 1.3, 0)))
	return true


func _move_along(g: Group, delta: float, out: Array[String]) -> void:
	if g.idx >= g.path.size():
		if g.loop:
			g.idx = 0
		else:
			g.state = "done"
			out.append("done:" + g.id)
			return
	var target := g.path[g.idx]
	var to := target - g.pos
	to.y = 0
	var step := g.speed * delta
	if to.length() <= step:
		g.pos = Vector3(target.x, g.pos.y, target.z)
		g.idx += 1
		out.append("reached:%s:%d" % [g.id, g.idx - 1])
	else:
		g.heading = to.normalized()
		g.pos += g.heading * step
