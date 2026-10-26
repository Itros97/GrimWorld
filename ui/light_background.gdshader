shader_type canvas_item;
// Room background: base colour with flame flicker on its brightness and animated film grain on top.

uniform vec4 base_color : source_color = vec4(0.02, 0.02, 0.02, 1.0);
uniform float grain = 0.0;
uniform float flicker = 0.0;

// Pseudo-random value in [0, 1) for a pixel.
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	// Sines with unrelated frequencies never line up, so the flame does not pulse regularly.
	float wave = sin(TIME * 7.3) * 0.5 + sin(TIME * 13.1 + 1.7) * 0.3 + sin(TIME * 23.7 + 4.1) * 0.2;
	vec3 color = base_color.rgb * (1.0 + flicker * wave);
	float noise = hash(floor(FRAGCOORD.xy) + fract(TIME * 0.731) * 917.0) - 0.5;
	COLOR = vec4(color + noise * grain, 1.0);
}
