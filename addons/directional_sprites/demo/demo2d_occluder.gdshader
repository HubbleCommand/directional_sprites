shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	/*if (sign(VERTEX.y) > 0.0) {
		VERTEX += vec2(cos(TIME) * 10.0, cos(TIME + 7.0) * 10.0);
	}*/
	//This, sadly, doesn't do anything...
	// this only changes some things while in the editor,
	// but does not affect the vertices of the OccluderPolygon2D
	//VERTEX += vec2(cos(TIME) * 10.0, cos(TIME + 7.0) * 10.0);
	float rads = 45.0;
	float x = VERTEX.x;
	float y = VERTEX.y;
	vec2 rotated = vec2(
		cos(rads) * x - sin(rads) * y,
		sin(rads) * x + cos(rads) * y	
	);
	VERTEX = rotated;
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(1,0,0,1);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
