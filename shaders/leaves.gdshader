shader_type spatial;
render_mode cull_disabled, depth_prepass_alpha;
uniform sampler2D canopy_mask:hint_default_black;
uniform vec3 color:source_color;

void fragment() {
	ALBEDO = color;
	ALPHA = texture(canopy_mask, UV).r;
	NORMAL = VIEW;
}
