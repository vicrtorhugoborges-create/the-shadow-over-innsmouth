shader_type canvas_item;
// Pós-processamento retrô do mundo (sys_retro_render, docs/13): pontilhado Bayer 4×4,
// redução de cor e grão leve, aplicados na resolução interna. A UI não passa por aqui.
// `strength` escala pontilhado e grão (docs/16 §5: "Retrô suave" e "Limpo");
// `gamma` é o brilho calibrável e vale mesmo com os efeitos desligados.

uniform bool enabled = true;
uniform float strength : hint_range(0.0, 1.0) = 1.0;
uniform float gamma : hint_range(0.6, 1.6) = 1.0;
uniform float levels = 28.0;
uniform float grain = 0.018;
uniform float seed = 0.0;
uniform float vignette = 0.28;

const float BAYER[16] = float[16](
	0.0, 8.0, 2.0, 10.0,
	12.0, 4.0, 14.0, 6.0,
	3.0, 11.0, 1.0, 9.0,
	15.0, 7.0, 13.0, 5.0
);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233)) + seed) * 43758.5453);
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	c.rgb = pow(max(c.rgb, vec3(0.0)), vec3(1.0 / gamma));
	if (enabled && strength > 0.01) {
		ivec2 p = ivec2(floor(UV / TEXTURE_PIXEL_SIZE));
		int idx = (p.x % 4) + (p.y % 4) * 4;
		// Menos intensidade = mais níveis de cor e pontilhado mais fraco.
		float lv = mix(96.0, levels, strength);
		float d = (BAYER[idx] / 16.0 - 0.5) / lv;
		c.rgb = floor((c.rgb + d) * lv + 0.5) / lv;
		c.rgb += (hash(vec2(p)) - 0.5) * grain * strength;
	}
	vec2 v = UV - 0.5;
	c.rgb *= 1.0 - dot(v, v) * vignette * 2.0;
	COLOR = vec4(c.rgb, 1.0);
}
