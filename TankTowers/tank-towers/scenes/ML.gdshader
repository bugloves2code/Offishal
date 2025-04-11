shader_type canvas_item;
uniform float onOff = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 input_color = texture(TEXTURE, UV);
	
	if(onOff == 0.0) {
		COLOR = input_color;
	}
	
	if(onOff == 1.0) {
		COLOR = vec4(input_color.r, input_color.g, 1.0, input_color.a);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
