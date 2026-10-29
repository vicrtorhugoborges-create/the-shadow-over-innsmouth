class_name FigureKit
extends RefCounted
## Figuras procedurais de baixa contagem de polígonos (pessoas e Profundos), no espírito do PS1:
## cores por vértice, sombreamento por vértice e membros em nós próprios para um andar simples.
## Autoria própria, geradas em tempo de execução; nenhuma malha externa (docs/18).
## Convenção: a frente da figura é −Z; a origem fica entre os pés.

const SKIN: Array[Color] = [
	Color(0.80, 0.64, 0.52), Color(0.70, 0.54, 0.42), Color(0.86, 0.72, 0.60),
	Color(0.58, 0.42, 0.32), Color(0.76, 0.60, 0.50),
]
const COATS: Array[Color] = [
	Color(0.20, 0.19, 0.18), Color(0.27, 0.22, 0.17), Color(0.16, 0.18, 0.22),
	Color(0.24, 0.24, 0.20), Color(0.30, 0.27, 0.22), Color(0.13, 0.13, 0.13),
]
const DRESSES: Array[Color] = [
	Color(0.22, 0.17, 0.15), Color(0.16, 0.17, 0.24), Color(0.26, 0.24, 0.22), Color(0.20, 0.22, 0.18),
]
const HAIR: Array[Color] = [
	Color(0.10, 0.08, 0.06), Color(0.24, 0.17, 0.10), Color(0.45, 0.42, 0.38), Color(0.18, 0.12, 0.08),
]

static var _cache: Dictionary = {}
static var _mat_cloth: StandardMaterial3D
static var _mat_deep: StandardMaterial3D
static var _mat_eyes: StandardMaterial3D
static var _mat_gold: StandardMaterial3D


# ================================================================ construtor de malha

class Builder:
	extends RefCounted
	var st := SurfaceTool.new()
	var count := 0

	func _init() -> void:
		st.begin(Mesh.PRIMITIVE_TRIANGLES)

	func _v(p: Vector3, n: Vector3, c: Color) -> void:
		st.set_color(c)
		st.set_normal(n)
		st.add_vertex(p)

	func quad(a: Vector3, b: Vector3, c: Vector3, d: Vector3, col: Color) -> void:
		## a→b→c→d em sentido anti-horário visto de fora; emite em sentido horário (frente no Godot).
		var n := (b - a).cross(c - a).normalized()
		_v(a, n, col); _v(c, n, col); _v(b, n, col)
		_v(a, n, col); _v(d, n, col); _v(c, n, col)
		count += 2

	func tri(a: Vector3, b: Vector3, c: Vector3, col: Color) -> void:
		var n := (b - a).cross(c - a).normalized()
		_v(a, n, col); _v(c, n, col); _v(b, n, col)
		count += 1

	func box(center: Vector3, size: Vector3, col: Color, top: Vector2 = Vector2.ONE, shear: Vector3 = Vector3.ZERO, col_top: Color = Color(0, 0, 0, 0)) -> void:
		## Caixa afunilada: `top` escala a face de cima (x, z); `shear` desloca a face de cima.
		var ct := col if col_top.a == 0.0 else col_top
		var hx := size.x * 0.5
		var hz := size.z * 0.5
		var y0 := center.y - size.y * 0.5
		var y1 := center.y + size.y * 0.5
		var o := Vector3(center.x, 0, center.z)
		var tx := hx * top.x
		var tz := hz * top.y
		var b0 := o + Vector3(-hx, y0, -hz)
		var b1 := o + Vector3(hx, y0, -hz)
		var b2 := o + Vector3(hx, y0, hz)
		var b3 := o + Vector3(-hx, y0, hz)
		var t0 := o + shear + Vector3(-tx, y1, -tz)
		var t1 := o + shear + Vector3(tx, y1, -tz)
		var t2 := o + shear + Vector3(tx, y1, tz)
		var t3 := o + shear + Vector3(-tx, y1, tz)
		quad(b0, t0, t1, b1, col)
		quad(b2, t2, t3, b3, col)
		quad(b1, t1, t2, b2, col)
		quad(b3, t3, t0, b0, col)
		quad(t0, t3, t2, t1, ct)
		quad(b0, b1, b2, b3, col)

	func ellipsoid(c: Vector3, r: Vector3, col: Color, segs: int = 8, rings: int = 5, col_low: Color = Color(0, 0, 0, 0), cut: float = 1.0) -> void:
		## Elipsoide facetado; `col_low` pinta a metade de baixo; `cut` < 1 corta a parte inferior.
		var low := col if col_low.a == 0.0 else col_low
		var pts: Array = []
		for j in rings + 1:
			var th := PI * float(j) / rings * cut
			var row: Array = []
			for i in segs + 1:
				var ph := TAU * float(i) / segs
				row.append(Vector3(sin(th) * cos(ph), cos(th), sin(th) * sin(ph)))
			pts.append(row)
		for j in rings:
			for i in segs:
				var u: Array = [pts[j][i], pts[j][i + 1], pts[j + 1][i + 1], pts[j + 1][i]]
				var col_q: Color = col if (u[0] as Vector3).y + (u[2] as Vector3).y > 0.0 else low
				var p: Array = []
				var nn: Array = []
				for q: Vector3 in u:
					p.append(c + Vector3(q.x * r.x, q.y * r.y, q.z * r.z))
					nn.append(Vector3(q.x / r.x, q.y / r.y, q.z / r.z).normalized())
				# u0→u1→u2→u3 é anti-horário visto de fora; emite em sentido horário.
				_v(p[0], nn[0], col_q); _v(p[2], nn[2], col_q); _v(p[1], nn[1], col_q)
				_v(p[0], nn[0], col_q); _v(p[3], nn[3], col_q); _v(p[2], nn[2], col_q)
				count += 2

	func prism(base: Vector3, rb: float, rt: float, h: float, col: Color, sides: int = 8, cap: bool = true, squash: float = 1.0) -> void:
		var bottom: Array = []
		var topv: Array = []
		for i in sides + 1:
			var ph := TAU * float(i) / sides
			var d := Vector3(cos(ph), 0, sin(ph) * squash)
			bottom.append(base + d * rb)
			topv.append(base + d * rt + Vector3(0, h, 0))
		for i in sides:
			quad(bottom[i], topv[i], topv[i + 1], bottom[i + 1], col)
		if cap:
			var ct := base + Vector3(0, h, 0)
			for i in sides:
				tri(ct, topv[i + 1], topv[i], col)
				tri(base, bottom[i], bottom[i + 1], col)

	func commit(mesh: ArrayMesh = null) -> ArrayMesh:
		if mesh == null:
			return st.commit()
		return st.commit(mesh)


# ================================================================ materiais

static func _materials() -> void:
	if _mat_cloth:
		return
	_mat_cloth = StandardMaterial3D.new()
	_mat_cloth.vertex_color_use_as_albedo = true
	_mat_cloth.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	_mat_cloth.roughness = 0.95
	_mat_deep = StandardMaterial3D.new()
	_mat_deep.vertex_color_use_as_albedo = true
	_mat_deep.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	# "Shiny and slippery" [C]: especular alto para captar o luar.
	_mat_deep.roughness = 0.3
	_mat_deep.metallic_specular = 0.9
	_mat_eyes = StandardMaterial3D.new()
	_mat_eyes.vertex_color_use_as_albedo = true
	_mat_eyes.emission_enabled = true
	_mat_eyes.emission = Color(0.22, 0.22, 0.16)
	_mat_eyes.roughness = 0.15
	_mat_gold = StandardMaterial3D.new()
	_mat_gold.albedo_color = Color(0.80, 0.70, 0.40)
	_mat_gold.metallic = 0.8
	_mat_gold.roughness = 0.35
	_mat_gold.emission_enabled = true
	_mat_gold.emission = Color(0.25, 0.20, 0.08)
	_mat_gold.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX


static func _instance(parent: Node3D, mesh: Mesh, name: String = "") -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	if name != "":
		mi.name = name
	parent.add_child(mi)
	return mi


static func _limb(parent: Node3D, name: String, pivot: Vector3, mesh: Mesh) -> Node3D:
	var n := Node3D.new()
	n.name = name
	n.position = pivot
	parent.add_child(n)
	# Membros não projetam sombra: poupa chamadas de desenho nas multidões (docs/19).
	_instance(n, mesh).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return n


static func _seed_from(pos: Vector3, tall: float) -> int:
	return absi(int(pos.x * 73.0) * 73856093 ^ int(pos.z * 71.0) * 19349663 ^ int(tall * 100.0) * 83492791)


static func head_center(root: Node3D) -> Vector3:
	return root.get_meta("head", Vector3(0, 1.6, -0.06))


# ================================================================ pessoas

static func human(parent: Node, pos: Vector3, tall: float = 1.75, robed: bool = false, tiara: bool = false, style: String = "") -> Node3D:
	## Habitante, funcionário ou perseguidor humano. `style`: man | woman | old | clerk | grocer |
	## child | robed (vazio = sorteado de forma determinística pela posição).
	_materials()
	var rng := RandomNumberGenerator.new()
	rng.seed = _seed_from(pos, tall)
	if style == "":
		if robed:
			style = "robed"
		elif tall < 1.3:
			style = "child"
		else:
			style = "woman" if rng.randf() < 0.3 else "man"
	var skin: Color = SKIN[rng.randi() % SKIN.size()]
	var coat: Color = COATS[rng.randi() % COATS.size()]
	var hair: Color = HAIR[rng.randi() % HAIR.size()]
	var dress: Color = DRESSES[rng.randi() % DRESSES.size()]
	var hat := rng.randi() % 3
	if style == "old":
		hair = Color(0.62, 0.60, 0.56)
	var key := "%s|%.2f|%s|%s|%s|%s|%d|%s" % [style, tall, skin.to_html(), coat.to_html(), hair.to_html(), dress.to_html(), hat, tiara]
	var root := Node3D.new()
	root.position = pos
	parent.add_child(root)
	var body := Node3D.new()
	body.name = "body"
	root.add_child(body)
	var parts: Dictionary = _cache.get(key, {})
	if parts.is_empty():
		parts = _build_human(style, tall, skin, coat, hair, dress, hat)
		_cache[key] = parts
	_instance(body, parts["torso"], "torso")
	var anim := FigureAnimator.new()
	anim.name = "anim"
	anim.root = root
	anim.body = body
	if parts.has("leg"):
		anim.legs.append(_limb(body, "leg_l", parts["hip_l"], parts["leg"]))
		anim.legs.append(_limb(body, "leg_r", parts["hip_r"], parts["leg"]))
	anim.arms.append(_limb(body, "arm_l", parts["sh_l"], parts["arm"]))
	anim.arms.append(_limb(body, "arm_r", parts["sh_r"], parts["arm"]))
	anim.gait = 0.6 if style in ["old", "robed"] else 1.0
	root.add_child(anim)
	root.set_meta("head", parts["head"])
	if tiara:
		var t := _instance(body, _tiara_mesh(), "tiara")
		t.position = parts["head"] + Vector3(0, 0.12, 0.0)
	return root


static func _build_human(style: String, tall: float, skin: Color, coat: Color, hair: Color, dress: Color, hat: int) -> Dictionary:
	var t := tall
	var child := style == "child"
	var hip := t * (0.46 if child else 0.48)
	var sh := t * (0.78 if child else 0.80)
	var hunch := -0.05
	var width := 0.40
	if style == "old":
		hunch = -0.13
		width = 0.37
	elif style == "woman":
		width = 0.34
	elif child:
		width = 0.30
	var head_r := Vector3(0.095, 0.12, 0.105) * (1.12 if child else 1.0)
	var head := Vector3(0, sh + 0.06 + head_r.y, hunch - 0.03)
	var shirt := Color(0.78, 0.76, 0.70)
	var trousers := coat.darkened(0.3)
	var top := coat
	var sleeve := coat
	var b := Builder.new()
	match style:
		"woman":
			top = dress.lightened(0.25)
			sleeve = top
			# Saia longa até a canela, alargada embaixo.
			b.box(Vector3(0, (t * 0.12 + hip + 0.04) * 0.5, 0), Vector3(width * 1.25, hip + 0.04 - t * 0.12, 0.30), dress, Vector2(0.72, 0.72))
		"robed":
			top = Color(0.13, 0.10, 0.08)
			sleeve = top
			b.box(Vector3(0, sh * 0.5, 0), Vector3(0.64, sh, 0.46), top, Vector2(0.66, 0.6), Vector3(0, 0, hunch))
		"clerk":
			top = shirt
			sleeve = shirt
		"grocer":
			top = Color(0.62, 0.60, 0.55)
			sleeve = top
	# Tronco e paletó.
	b.box(Vector3(0, (hip + sh) * 0.5, 0), Vector3(width, sh - hip, 0.24), top, Vector2(1.08, 0.92), Vector3(0, 0, hunch))
	if style == "man" or style == "old":
		# Abas do casaco e lapelas claras (camisa).
		b.box(Vector3(0, hip - 0.1, 0.01), Vector3(width + 0.04, 0.22, 0.26), coat, Vector2(0.96, 0.95))
		b.box(Vector3(0, sh - 0.12, hunch * 0.85 - 0.125), Vector3(0.08, 0.16, 0.01), shirt)
	elif style == "clerk":
		b.box(Vector3(0, (hip + sh) * 0.5 - 0.03, hunch * 0.5 - 0.122), Vector3(width * 0.8, (sh - hip) * 0.8, 0.012), coat.darkened(0.2))
	elif style == "grocer":
		b.box(Vector3(0, hip + 0.02, hunch * 0.3 - 0.125), Vector3(width * 0.8, 0.62, 0.012), Color(0.86, 0.85, 0.80))
	# Pescoço e cabeça.
	b.box(Vector3(0, sh + 0.03, hunch - 0.02), Vector3(0.08, 0.08, 0.08), skin)
	b.ellipsoid(head, head_r, skin, 8, 5)
	# Cabelo, barba e chapéu.
	if style == "robed":
		b.ellipsoid(head + Vector3(0, 0.02, 0.02), head_r * 1.35, Color(0.10, 0.08, 0.07), 8, 5, Color(0, 0, 0, 0), 0.62)
	else:
		b.ellipsoid(head + Vector3(0, 0.035, 0.012), head_r * Vector3(1.06, 0.85, 1.06), hair, 8, 4, Color(0, 0, 0, 0), 0.5)
		if style == "woman":
			b.ellipsoid(head + Vector3(0, 0.02, 0.11), Vector3(0.055, 0.05, 0.05), hair, 6, 3)
		if style == "old":
			b.ellipsoid(head + Vector3(0, -0.085, -0.06), Vector3(0.07, 0.07, 0.05), hair, 6, 3)
		var hat_col := coat.darkened(0.45)
		if style in ["man", "old"] and hat == 1:
			b.prism(head + Vector3(0, 0.05, 0), 0.105, 0.095, 0.11, hat_col)
			b.prism(head + Vector3(0, 0.045, 0), 0.18, 0.18, 0.015, hat_col)
		elif style in ["man", "old"] and hat == 2:
			b.ellipsoid(head + Vector3(0, 0.07, -0.01), Vector3(0.11, 0.05, 0.12), hat_col, 8, 3, Color(0, 0, 0, 0), 0.5)
			b.box(head + Vector3(0, 0.07, -0.14), Vector3(0.14, 0.015, 0.07), hat_col)
		elif style == "woman" and hat == 1:
			b.ellipsoid(head + Vector3(0, 0.04, 0.0), head_r * Vector3(1.18, 0.95, 1.18), dress.darkened(0.3), 8, 4, Color(0, 0, 0, 0), 0.55)
	var torso := b.commit()
	torso.surface_set_material(0, _mat_cloth)
	var parts := {"torso": torso, "head": head}
	# Braços: pivô no ombro, mão no fim.
	var arm_len := t * 0.36
	var ab := Builder.new()
	ab.box(Vector3(0, -arm_len * 0.45, 0), Vector3(0.1, arm_len * 0.9, 0.11), sleeve, Vector2(1.1, 1.1))
	ab.box(Vector3(0, -arm_len * 0.95, -0.01), Vector3(0.075, arm_len * 0.14, 0.09), skin)
	var arm := ab.commit()
	arm.surface_set_material(0, _mat_cloth)
	parts["arm"] = arm
	parts["sh_l"] = Vector3(-width * 0.5 - 0.06, sh - 0.04, hunch * 0.9)
	parts["sh_r"] = Vector3(width * 0.5 + 0.06, sh - 0.04, hunch * 0.9)
	if style != "robed":
		var lb := Builder.new()
		var leg_col := trousers
		if style == "woman":
			leg_col = Color(0.30, 0.26, 0.24)
		lb.box(Vector3(0, -hip * 0.5, 0), Vector3(0.15, hip, 0.16), leg_col, Vector2(1.15, 1.1))
		lb.box(Vector3(0, -hip + 0.04, -0.05), Vector3(0.12, 0.08, 0.26), Color(0.07, 0.06, 0.05))
		var leg := lb.commit()
		leg.surface_set_material(0, _mat_cloth)
		parts["leg"] = leg
		parts["hip_l"] = Vector3(-0.09, hip, 0)
		parts["hip_r"] = Vector3(0.09, hip, 0)
	return parts


static func set_seated(root: Node3D, on: bool, seat_h: float = 0.45) -> void:
	## Senta a figura num assento de altura `seat_h` (o pivô do quadril desce até ele e as
	## pernas inclinam até os pés tocarem o chão), ou a põe de pé.
	var body: Node3D = root.get_node_or_null("body")
	var anim: FigureAnimator = root.get_node_or_null("anim")
	if body == null or anim == null:
		return
	var leg: Node3D = body.get_node_or_null("leg_l")
	var hip := leg.position.y if leg else 0.8
	anim.seated = on
	anim.base_y = (seat_h - hip) if on else 0.0
	anim.arm_rest = 0.45 if on else 0.0
	var ang := acos(clampf(seat_h / hip, 0.0, 1.0)) if on else 0.0
	for name: String in ["leg_l", "leg_r"]:
		var l: Node3D = body.get_node_or_null(name)
		if l:
			l.rotation.x = ang
	body.position.y = anim.base_y
	for a in anim.arms:
		a.rotation.x = anim.arm_rest


static func add_staring_eyes(root: Node3D) -> MeshInstance3D:
	## "Aparência de Innsmouth" em traços anfíbios (D-013): olhos saltados que não piscam e
	## pescoço vincado — nunca traços étnicos.
	_materials()
	var h := head_center(root)
	var key := "eyes|%.3f|%.3f" % [h.y, h.z]
	var mesh: ArrayMesh = _cache.get(key, null)
	if mesh == null:
		var b := Builder.new()
		for sx: float in [-0.042, 0.042]:
			b.ellipsoid(h + Vector3(sx, 0.012, -0.088), Vector3(0.03, 0.026, 0.024), Color(0.86, 0.85, 0.74), 6, 3)
			b.box(h + Vector3(sx, 0.012, -0.113), Vector3(0.012, 0.012, 0.004), Color(0.03, 0.03, 0.03))
		for sx2: float in [-0.045, 0.045]:
			for k in 2:
				b.box(h + Vector3(sx2, -0.15 - k * 0.025, -0.01), Vector3(0.012, 0.008, 0.07), Color(0.18, 0.16, 0.14))
		mesh = b.commit()
		mesh.surface_set_material(0, _mat_eyes)
		_cache[key] = mesh
	var body: Node3D = root.get_node_or_null("body")
	return _instance(body if body else root, mesh, "eyes")


static func _tiara_mesh() -> ArrayMesh:
	_materials()
	var mesh: ArrayMesh = _cache.get("tiara_small", null)
	if mesh == null:
		var b := Builder.new()
		b.prism(Vector3.ZERO, 0.17, 0.10, 0.20, Color.WHITE, 8, false, 1.15)
		b.prism(Vector3(0, 0.2, 0), 0.10, 0.03, 0.14, Color.WHITE, 8, true, 1.15)
		mesh = b.commit()
		mesh.surface_set_material(0, _mat_gold)
		_cache["tiara_small"] = mesh
	return mesh


# ================================================================ Profundos

static func deep_one(parent: Node, pos: Vector3, kind: String = "plain", seed_value: int = 0) -> Node3D:
	## Profundo (deep_procession), segundo o capítulo IV [C]: cinza-esverdeado, ventre branco,
	## dorso escamoso, cabeça de peixe, olhos saltados que não fecham, guelras, patas palmadas.
	## kind: plain | tiara | robed | leader (casaco preto corcunda, calça listrada, chapéu de feltro).
	_materials()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var tall := snappedf(rng.randf_range(1.55, 1.85), 0.05)
	var shade := snappedf(rng.randf(), 0.25)
	var key := "deep|%s|%.2f|%.2f" % [kind, tall, shade]
	var parts: Dictionary = _cache.get(key, {})
	if parts.is_empty():
		parts = _build_deep(kind, tall, shade)
		_cache[key] = parts
	var root := Node3D.new()
	root.position = pos
	parent.add_child(root)
	var body := Node3D.new()
	body.name = "body"
	root.add_child(body)
	var torso := _instance(body, parts["torso"], "torso")
	if kind == "robed":
		torso.name = "robe"
	var anim := FigureAnimator.new()
	anim.name = "anim"
	anim.root = root
	anim.body = body
	anim.arm_rest = 0.35
	anim.hop = 0.05 if rng.randf() < 0.4 else 0.0
	anim.gait = 0.7
	if parts.has("leg"):
		anim.legs.append(_limb(body, "leg_l", parts["hip_l"], parts["leg"]))
		anim.legs.append(_limb(body, "leg_r", parts["hip_r"], parts["leg"]))
	anim.arms.append(_limb(body, "arm_l", parts["sh_l"], parts["arm"]))
	anim.arms.append(_limb(body, "arm_r", parts["sh_r"], parts["arm"]))
	root.add_child(anim)
	root.set_meta("head", parts["head"])
	if kind == "tiara":
		var t := _instance(body, _tiara_mesh(), "tiara")
		t.position = parts["head"] + Vector3(0, 0.11, 0.02)
		t.scale = Vector3.ONE * 1.15
	return root


static func _build_deep(kind: String, t: float, shade: float) -> Dictionary:
	var skin := Color(0.40, 0.48, 0.40).lerp(Color(0.31, 0.42, 0.40), shade)
	var dark := skin.darkened(0.45)
	var belly := Color(0.80, 0.82, 0.74)
	var hip := t * 0.42
	var sh := t * 0.74
	var lean := -0.15
	var head := Vector3(0, sh + 0.1, lean - 0.07)
	var b := Builder.new()
	# Tronco curvado, ventre branco, guelras e nadadeiras dorsais.
	b.box(Vector3(0, (hip + sh) * 0.5, 0), Vector3(0.46, sh - hip, 0.36), skin, Vector2(1.25, 0.95), Vector3(0, 0, lean))
	b.box(Vector3(0, (hip + sh) * 0.5 - 0.02, lean * 0.5 - 0.17), Vector3(0.36, (sh - hip) * 0.86, 0.02), belly, Vector2(1.1, 1.0), Vector3(0, 0, lean * 0.1))
	for k in 4:
		var y := hip + 0.08 + k * (sh - hip - 0.06) / 4.0
		var z := 0.19 + lean * (y - hip) / (sh - hip)
		b.box(Vector3(0, y + 0.05, z + 0.03), Vector3(0.03, 0.1, 0.1), dark, Vector2(0.4, 0.3), Vector3(0, 0, 0.04))
	# Cabeça de peixe larga e chata, mandíbula clara, boca escura.
	b.ellipsoid(head, Vector3(0.19, 0.14, 0.24), skin, 8, 5, belly)
	b.box(head + Vector3(0, -0.035, -0.205), Vector3(0.26, 0.018, 0.05), Color(0.10, 0.06, 0.06))
	for sx: float in [-1.0, 1.0]:
		for k2 in 3:
			b.box(head + Vector3(sx * 0.2, -0.1 - k2 * 0.035, 0.07), Vector3(0.01, 0.018, 0.12), Color(0.36, 0.14, 0.14))
	if kind == "robed":
		b.box(Vector3(0, sh * 0.5, 0), Vector3(0.72, sh, 0.54), Color(0.12, 0.09, 0.08), Vector2(0.7, 0.66), Vector3(0, 0, lean))
	elif kind == "leader":
		# Casaco preto corcunda e chapéu de feltro [C].
		b.box(Vector3(0, (hip + sh) * 0.5 + 0.02, 0.01), Vector3(0.54, sh - hip + 0.18, 0.42), Color(0.04, 0.04, 0.045), Vector2(1.2, 1.0), Vector3(0, 0, lean))
		b.ellipsoid(Vector3(0, sh - 0.02, 0.12), Vector3(0.26, 0.16, 0.16), Color(0.04, 0.04, 0.045), 8, 4)
		b.prism(head + Vector3(0, 0.1, 0.02), 0.14, 0.13, 0.12, Color(0.08, 0.07, 0.06))
		b.prism(head + Vector3(0, 0.09, 0.02), 0.25, 0.25, 0.015, Color(0.08, 0.07, 0.06))
	var torso := b.commit()
	torso.surface_set_material(0, _mat_deep)
	# Olhos saltados, que não fecham — superfície própria, levemente luminosa ao luar.
	var eb := Builder.new()
	for sx2: float in [-0.13, 0.13]:
		eb.ellipsoid(head + Vector3(sx2, 0.065, -0.14), Vector3(0.062, 0.06, 0.055), Color(0.86, 0.84, 0.66), 6, 4)
		eb.box(head + Vector3(sx2 * 1.08, 0.065, -0.196), Vector3(0.025, 0.025, 0.006), Color(0.02, 0.02, 0.02))
	eb.commit(torso)
	torso.surface_set_material(1, _mat_eyes)
	var parts := {"torso": torso, "head": head}
	# Braços longos com mãos palmadas.
	var arm_len := t * 0.46
	var ab := Builder.new()
	var arm_col := Color(0.04, 0.04, 0.045) if kind == "leader" else (Color(0.12, 0.09, 0.08) if kind == "robed" else skin)
	ab.box(Vector3(0, -arm_len * 0.45, 0), Vector3(0.09, arm_len * 0.9, 0.1), arm_col)
	ab.box(Vector3(0, -arm_len * 0.98, -0.02), Vector3(0.2, arm_len * 0.18, 0.03), dark, Vector2(0.45, 1.0))
	var arm := ab.commit()
	arm.surface_set_material(0, _mat_deep)
	parts["arm"] = arm
	parts["sh_l"] = Vector3(-0.3, sh - 0.05, lean * 0.85)
	parts["sh_r"] = Vector3(0.3, sh - 0.05, lean * 0.85)
	if kind != "robed":
		var lb := Builder.new()
		var leg_col := skin
		if kind == "leader":
			leg_col = Color(0.30, 0.28, 0.26)
		lb.box(Vector3(0, -hip * 0.5, 0.02), Vector3(0.15, hip, 0.17), leg_col, Vector2(1.2, 1.2), Vector3(0, 0, -0.06))
		if kind == "leader":
			# Calça listrada [C]: listras verticais claras.
			for sx3: float in [-0.045, 0.0, 0.045]:
				lb.box(Vector3(sx3, -hip * 0.5, -0.07), Vector3(0.014, hip * 0.95, 0.01), Color(0.55, 0.53, 0.48))
		lb.box(Vector3(0, -hip + 0.02, -0.12), Vector3(0.2, 0.04, 0.36), dark, Vector2(0.6, 1.0))
		var leg := lb.commit()
		leg.surface_set_material(0, _mat_deep)
		parts["leg"] = leg
		parts["hip_l"] = Vector3(-0.13, hip, 0.02)
		parts["hip_r"] = Vector3(0.13, hip, 0.02)
	return parts
