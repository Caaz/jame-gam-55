shader_type canvas_item;
uniform float percent:hint_range(0,1);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float fill = 1.0-step(percent, UV.x);
	vec4 fill_color = mix(vec4(1., .3, .1, 1), vec4(.2, 0., 0., 1.), UV.y);
	vec4 bg_color = vec4(0,0,0, UV.y);
	fill_color = mix(bg_color, fill_color, fill);
	COLOR = mix(COLOR, fill_color, step(.2, COLOR.r));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
