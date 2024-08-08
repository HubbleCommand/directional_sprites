shader_type canvas_item;

uniform sampler2D frame : filter_nearest, source_color;
uniform float directions = 8;
uniform bool orientation = true;

varying float rotation;

void vertex() {
	//Resize to size of one frame direction
	if (orientation) {	//Vertical
		VERTEX.y *= 1.0 / directions;} 
	else {				//Horizontal
		VERTEX.x *= 1.0 / directions;}
	
	vec4 world_position = MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0);
	vec4 local_position = inverse(CANVAS_MATRIX) * world_position;

	mat2 rotation_matrix = mat2(MODEL_MATRIX[0].xy, MODEL_MATRIX[1].xy);
	float rads = atan(rotation_matrix[0].y, rotation_matrix[0].x);
	
	mat2 c_rotation_matrix = mat2(CANVAS_MATRIX[0].xy, CANVAS_MATRIX[1].xy);
	float c_rads = atan(c_rotation_matrix[0].y, c_rotation_matrix[0].x);
	
	rads = - c_rads - rads;
	rotation = rads;
	
	float x = VERTEX.x;
	float y = VERTEX.y;
	vec2 rotated = vec2(
		cos(rads) * x - sin(rads) * y,
		sin(rads) * x + cos(rads) * y	
	);
	VERTEX = rotated;
}


void fragment() {
	float inv_directions = 1.0 / directions;
	float direction_angle = TAU / directions;

	float rads = rotation;
	if (rads < 0.0) {
		rads += TAU;	//Convert to positive equivalent
	}
	//Fixes when rad is between last dir∠ to 360deg
	//Still minor issues here, but works for now
	if (!(rads > direction_angle * (directions - 1.0))) {	
		rads += direction_angle / 2.0;
	} else {
		rads = 0.0;
	}

	float frame_number = floor((rads / direction_angle));
	float offset = frame_number / directions;	// frame_number * inv_directions

	//Get transformed UV
	vec2 region_uv;
	if (orientation) {
		region_uv = UV * vec2(1.0, inv_directions) + vec2(0.0, offset);
	} else {
		region_uv = UV * vec2(inv_directions, 1.0) + vec2(offset, 0.0);
	}

	vec4 tex_color = texture(frame, region_uv);
	COLOR = tex_color;
	NORMAL = texture(NORMAL_TEXTURE, UV).rgb;
}
