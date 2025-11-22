shader_type spatial;
render_mode cull_disabled;
global uniform vec3 player_position;
uniform float radius = 20;
uniform vec4 albedo:source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 world_space = INV_VIEW_MATRIX * vec4(VERTEX, 1);
	float dist = distance(player_position, world_space.xyz);
	dist = clamp(dist, 0, radius) / radius;
	dist = 1.0 - dist;
	dist = clamp(pow(dist*1.1, 30), 0., 1.);
	ALPHA = dist * albedo.a;
	ALBEDO = albedo.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
