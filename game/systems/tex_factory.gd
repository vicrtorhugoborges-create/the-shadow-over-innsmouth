class_name TexFactory
extends RefCounted
## Texturas e materiais PROVISÓRIOS gerados por código (64×64, filtragem nearest), docs/13.
## Mapeamento triplanar em espaço de mundo: geometria cinza sem UVs manuais.

static var _cache: Dictionary = {}


static func material(id: String, tile_m: float = 2.0) -> StandardMaterial3D:
	var key := "%s@%s" % [id, tile_m]
	if _cache.has(key):
		return _cache[key]
	var m := StandardMaterial3D.new()
	m.albedo_texture = _texture(id)
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	m.roughness = 1.0
	m.metallic_specular = 0.1
	m.uv1_triplanar = true
	m.uv1_world_triplanar = true
	m.uv1_scale = Vector3.ONE / tile_m
	_cache[key] = m
	return m


static func flat(color: Color, emissive: bool = false) -> StandardMaterial3D:
	var key := "flat:%s:%s" % [color.to_html(), emissive]
	if _cache.has(key):
		return _cache[key]
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 1.0
	if emissive:
		m.emission_enabled = true
		m.emission = color
		m.emission_energy_multiplier = 1.5
	_cache[key] = m
	return m


static func _texture(id: String) -> ImageTexture:
	var img := Image.create(64, 64, false, Image.FORMAT_RGB8)
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(id)
	match id:
		"wallpaper":
			_paint(img, rng, Color(0.36, 0.33, 0.24), 0.05)
			for x in 64:
				if x % 16 < 2:
					for y in 64:
						img.set_pixel(x, y, Color(0.27, 0.25, 0.18))
			for i in 24:
				var px := rng.randi_range(4, 59)
				var py := rng.randi_range(0, 63)
				img.set_pixel(px, py, Color(0.45, 0.40, 0.28))
			_stain(img, rng, 5, Color(0.22, 0.2, 0.14))
		"wood_floor":
			_paint(img, rng, Color(0.28, 0.19, 0.12), 0.06)
			for y in 64:
				if y % 8 == 0:
					for x in 64:
						img.set_pixel(x, y, Color(0.14, 0.09, 0.06))
		"wood_dark":
			_paint(img, rng, Color(0.20, 0.13, 0.08), 0.05)
			for x in 64:
				if x % 21 == 0:
					for y in 64:
						img.set_pixel(x, y, Color(0.12, 0.08, 0.05))
		"brick":
			_paint(img, rng, Color(0.38, 0.19, 0.13), 0.07)
			for y in 64:
				for x in 64:
					var row := y / 8
					var off := 8 if row % 2 == 1 else 0
					if y % 8 == 0 or (x + off) % 16 == 0:
						img.set_pixel(x, y, Color(0.30, 0.28, 0.24))
			_stain(img, rng, 6, Color(0.2, 0.18, 0.15))
		"slate":
			_paint(img, rng, Color(0.20, 0.21, 0.23), 0.05)
			for y in 64:
				for x in 64:
					var row := y / 10
					var off := 6 if row % 2 == 1 else 0
					if y % 10 == 0 or (x + off) % 12 == 0:
						img.set_pixel(x, y, Color(0.11, 0.11, 0.12))
		"plaster":
			_paint(img, rng, Color(0.46, 0.44, 0.38), 0.05)
			_stain(img, rng, 8, Color(0.33, 0.32, 0.25))
		"cobble":
			_paint(img, rng, Color(0.25, 0.25, 0.24), 0.06)
			for i in 40:
				var cx := rng.randi_range(0, 63)
				var cy := rng.randi_range(0, 63)
				for dy in range(-3, 4):
					for dx in range(-3, 4):
						if dx * dx + dy * dy <= 9:
							img.set_pixel(posmod(cx + dx, 64), posmod(cy + dy, 64), Color(0.31, 0.30, 0.28) * rng.randf_range(0.85, 1.1))
		"clapboard":
			_paint(img, rng, Color(0.36, 0.36, 0.33), 0.05)
			for y in 64:
				if y % 6 == 0:
					for x in 64:
						img.set_pixel(x, y, Color(0.2, 0.2, 0.19))
			_stain(img, rng, 6, Color(0.25, 0.26, 0.22))
		"velour":
			_paint(img, rng, Color(0.30, 0.06, 0.07), 0.04)
			for x in 64:
				if x % 6 < 2:
					for y in 64:
						img.set_pixel(x, y, Color(0.22, 0.04, 0.05))
		"dirt":
			_paint(img, rng, Color(0.20, 0.18, 0.13), 0.08)
		"stripes":
			_paint(img, rng, Color(0.30, 0.30, 0.30), 0.03)
			for x in 64:
				if x % 8 < 3:
					for y in 64:
						img.set_pixel(x, y, Color(0.08, 0.08, 0.09))
		"marsh":
			_paint(img, rng, Color(0.16, 0.18, 0.12), 0.07)
			for i in 90:
				var gx := rng.randi_range(0, 63)
				var gy := rng.randi_range(0, 60)
				for k in 4:
					img.set_pixel(gx, posmod(gy + k, 64), Color(0.24, 0.27, 0.15) * rng.randf_range(0.8, 1.15))
		"ballast":
			_paint(img, rng, Color(0.24, 0.23, 0.21), 0.09)
			for y in 64:
				if y % 16 < 4:
					for x in 64:
						img.set_pixel(x, y, Color(0.17, 0.12, 0.08) * rng.randf_range(0.85, 1.1))
		_:
			_paint(img, rng, Color(0.4, 0.4, 0.4), 0.05)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


static func _paint(img: Image, rng: RandomNumberGenerator, base: Color, noise: float) -> void:
	for y in 64:
		for x in 64:
			var n := rng.randf_range(-noise, noise)
			img.set_pixel(x, y, Color(base.r + n, base.g + n, base.b + n))


static func _stain(img: Image, rng: RandomNumberGenerator, count: int, color: Color) -> void:
	for i in count:
		var cx := rng.randi_range(0, 63)
		var cy := rng.randi_range(0, 63)
		var r := rng.randi_range(3, 9)
		for dy in range(-r, r + 1):
			for dx in range(-r, r + 1):
				if dx * dx + dy * dy <= r * r and rng.randf() < 0.6:
					var p := Vector2i((cx + dx + 64) % 64, (cy + dy + 64) % 64)
					img.set_pixelv(p, img.get_pixelv(p).lerp(color, 0.4))
