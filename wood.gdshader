shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);

void vertex() {

}

void fragment() {
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
