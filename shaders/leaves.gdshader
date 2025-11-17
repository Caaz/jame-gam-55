shader_type spatial;
//render_mode unshaded;
render_mode cull_disabled, depth_prepass_alpha;
uniform sampler2D canopy_mask:hint_default_black;
uniform vec3 color:source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = color;
	ALPHA = texture(canopy_mask, UV).r > .5? 1.0:0.0;
	NORMAL = VIEW;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
