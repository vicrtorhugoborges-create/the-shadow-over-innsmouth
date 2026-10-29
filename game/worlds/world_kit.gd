class_name WorldKit
extends RefCounted
## Utilitários de geometria cinza (placeholders identificados, docs/18 §Claude Code).


static func box(parent: Node, center: Vector3, size: Vector3, mat: Material, collide: bool = true, rot_y: float = 0.0) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = size
	mi.mesh = bm
	mi.material_override = mat
	mi.position = center
	mi.rotation.y = rot_y
	parent.add_child(mi)
	if collide:
		var sb := StaticBody3D.new()
		sb.collision_layer = 1
		sb.collision_mask = 0
		var cs := CollisionShape3D.new()
		var bs := BoxShape3D.new()
		bs.size = size
		cs.shape = bs
		sb.add_child(cs)
		mi.add_child(sb)
	return mi


static func blocker(parent: Node, center: Vector3, size: Vector3) -> StaticBody3D:
	## Colisão invisível (janelas, bordas não jogáveis).
	## Camada 8: bloqueia o jogador, mas não a linha de visão dos grupos (raios usam a camada 1).
	var sb := StaticBody3D.new()
	sb.collision_layer = 8
	sb.collision_mask = 0
	var cs := CollisionShape3D.new()
	var bs := BoxShape3D.new()
	bs.size = size
	cs.shape = bs
	sb.add_child(cs)
	sb.position = center
	parent.add_child(sb)
	return sb


static func wall_z(parent: Node, x: float, z0: float, z1: float, y0: float, y1: float, mat: Material, openings: Array = [], t: float = 0.15) -> void:
	## Parede no plano x = const, de z0 a z1. Aberturas: Vector4(za, zb, ya, yb).
	_wall(parent, true, x, z0, z1, y0, y1, mat, openings, t)


static func wall_x(parent: Node, z: float, x0: float, x1: float, y0: float, y1: float, mat: Material, openings: Array = [], t: float = 0.15) -> void:
	## Parede no plano z = const, de x0 a x1. Aberturas: Vector4(xa, xb, ya, yb).
	_wall(parent, false, z, x0, x1, y0, y1, mat, openings, t)


static func _wall(parent: Node, along_z: bool, fixed: float, a0: float, a1: float, y0: float, y1: float, mat: Material, openings: Array, t: float) -> void:
	var ops: Array = openings.duplicate()
	ops.sort_custom(func(p: Vector4, q: Vector4) -> bool: return p.x < q.x)
	var cursor := a0
	for o: Vector4 in ops:
		if o.x > cursor:
			_seg(parent, along_z, fixed, cursor, o.x, y0, y1, mat, t)
		if o.z > y0:
			_seg(parent, along_z, fixed, o.x, o.y, y0, o.z, mat, t)
		if o.w < y1:
			_seg(parent, along_z, fixed, o.x, o.y, o.w, y1, mat, t)
		cursor = maxf(cursor, o.y)
	if cursor < a1:
		_seg(parent, along_z, fixed, cursor, a1, y0, y1, mat, t)


static func _seg(parent: Node, along_z: bool, fixed: float, a: float, b: float, y0: float, y1: float, mat: Material, t: float) -> void:
	if b - a < 0.01 or y1 - y0 < 0.01:
		return
	var c := (a + b) * 0.5
	var cy := (y0 + y1) * 0.5
	if along_z:
		box(parent, Vector3(fixed, cy, c), Vector3(t, y1 - y0, b - a), mat)
	else:
		box(parent, Vector3(c, cy, fixed), Vector3(b - a, y1 - y0, t), mat)


static func floor_with_holes(parent: Node, x0: float, x1: float, z0: float, z1: float, y_top: float, mat: Material, holes: Array = [], thick: float = 0.2) -> void:
	## Piso retangular com furos retangulares Rect2(x, z, w, d), por faixas em z.
	var cuts: Array[float] = [z0, z1]
	for h: Rect2 in holes:
		cuts.append(h.position.y)
		cuts.append(h.position.y + h.size.y)
	cuts.sort()
	for i in cuts.size() - 1:
		var za := cuts[i]
		var zb := cuts[i + 1]
		if zb - za < 0.01:
			continue
		var zm := (za + zb) * 0.5
		var xs: Array[float] = [x0]
		var xe: Array[float] = []
		for h: Rect2 in holes:
			if zm > h.position.y and zm < h.position.y + h.size.y:
				xe.append(h.position.x)
				xs.append(h.position.x + h.size.x)
		xe.append(x1)
		xs.sort()
		xe.sort()
		for k in xs.size():
			var xa := xs[k]
			var xb := xe[k]
			if xb - xa > 0.01:
				box(parent, Vector3((xa + xb) * 0.5, y_top - thick * 0.5, zm), Vector3(xb - xa, thick, zb - za), mat)


static func ramp(parent: Node, from: Vector3, to: Vector3, width: float, mat: Material) -> void:
	## Escada como rampa de colisão + degraus visuais.
	var d := to - from
	var horiz := Vector2(d.x, d.z)
	var length := Vector3(d.x, d.y, d.z).length()
	var sb := StaticBody3D.new()
	sb.collision_layer = 1
	var cs := CollisionShape3D.new()
	var bs := BoxShape3D.new()
	bs.size = Vector3(width, 0.1, length)
	cs.shape = bs
	sb.add_child(cs)
	parent.add_child(sb)
	sb.position = (from + to) * 0.5
	sb.look_at_from_position((from + to) * 0.5, to, Vector3.UP)
	var steps := maxi(2, int(absf(d.y) / 0.19))
	for i in steps:
		var k := (i + 0.5) / steps
		var p := from + d * k
		var step_len := horiz.length() / steps
		var yaw := atan2(d.x, d.z)
		box(parent, Vector3(p.x, p.y - 0.09, p.z), Vector3(width, 0.18, step_len + 0.02), mat, false, yaw)


static func slope(parent: Node, center: Vector3, size: Vector3, pitch: float, mat: Material) -> MeshInstance3D:
	## Telhado inclinado em torno do eixo X.
	var mi := box(parent, center, size, mat)
	mi.rotation.x = pitch
	return mi


static func omni(parent: Node, pos: Vector3, color: Color, energy: float, radius: float, shadow: bool = false) -> OmniLight3D:
	var l := OmniLight3D.new()
	l.position = pos
	l.light_color = color
	l.light_energy = energy
	l.omni_range = radius
	l.omni_attenuation = 1.4
	l.shadow_enabled = shadow
	parent.add_child(l)
	return l


static func deep_one(parent: Node, pos: Vector3, kind: String = "plain", seed_value: int = 0) -> Node3D:
	## Profundo da procissão (malha procedural em `FigureKit`). kind: plain | tiara | robed | leader.
	return FigureKit.deep_one(parent, pos, kind, seed_value)


static func tiara(parent: Node, pos: Vector3, s: float = 1.0) -> Node3D:
	## A tiara [C, cap. I]: alta na frente, periferia elíptica e irregular, relevos marinhos e
	## geométricos, ouro de brilho esbranquiçado. Malha provisória de segmentos.
	var root := Node3D.new()
	root.position = pos
	parent.add_child(root)
	var gold := StandardMaterial3D.new()
	gold.albedo_color = Color(0.82, 0.78, 0.60)
	gold.metallic = 0.75
	gold.roughness = 0.28
	gold.emission_enabled = true
	gold.emission = Color(0.80, 0.76, 0.58)
	gold.emission_energy_multiplier = 0.2
	var relief := StandardMaterial3D.new()
	relief.albedo_color = Color(0.45, 0.42, 0.30)
	relief.metallic = 0.6
	var n := 18
	for i in n:
		var a := TAU * i / n
		var front := pow(maxf(0.0, -cos(a)), 1.5)
		var h := (0.06 + 0.16 * front) * s
		var p := Vector3(sin(a) * 0.11 * s, h * 0.5, cos(a) * 0.16 * s)
		var seg := box(root, p, Vector3(0.045 * s, h, 0.012 * s), gold, false)
		seg.rotation.y = a + PI / 2
		if i % 2 == 0:
			var r := box(root, p + Vector3(0, h * 0.15, 0) - Vector3(sin(a), 0, cos(a)) * 0.006 * s, Vector3(0.022 * s, 0.028 * s, 0.008 * s), relief, false)
			r.rotation.y = a + PI / 2
	return root


static func merge_static(root: Node3D) -> int:
	## Funde as caixas estáticas de `root` numa malha por material (reduz chamadas de desenho).
	## As colisões continuam nos nós originais, que só deixam de ser desenhados.
	## Ficam de fora as caixas que mudam depois: dentro de portas, móveis, interativos e luzes, ou
	## marcadas com a meta "dynamic" (nelas ou num ancestral).
	var groups: Dictionary = {}
	for n: Node in root.find_children("*", "MeshInstance3D", true, false):
		var mi := n as MeshInstance3D
		if not mi.is_visible_in_tree() or not (mi.mesh is BoxMesh) or mi.material_override == null:
			continue
		if _is_dynamic(mi, root):
			continue
		if not groups.has(mi.material_override):
			groups[mi.material_override] = []
		groups[mi.material_override].append(mi)
	var inv := root.global_transform.affine_inverse()
	var merged := 0
	for mat: Material in groups.keys():
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		for mi: MeshInstance3D in groups[mat]:
			st.append_from(mi.mesh, 0, inv * mi.global_transform)
			mi.visible = false
			merged += 1
		var out := MeshInstance3D.new()
		out.mesh = st.commit()
		out.material_override = mat
		root.add_child(out)
	return merged


static func _is_dynamic(n: Node, root: Node) -> bool:
	var p := n
	while p != null and p != root:
		if p.has_meta("dynamic") or p is Light3D or p is Door or p is Pushable or p is Interactable:
			return true
		p = p.get_parent()
	return false


static func flat(c: Color, emissive: bool = false) -> StandardMaterial3D:
	return TexFactory.flat(c, emissive)


static func figure(parent: Node, pos: Vector3, tall: float = 1.75, robed: bool = false, tiara: bool = false, style: String = "") -> Node3D:
	## Habitante, funcionário ou perseguidor (malha procedural em `FigureKit`).
	return FigureKit.human(parent, pos, tall, robed, tiara, style)
