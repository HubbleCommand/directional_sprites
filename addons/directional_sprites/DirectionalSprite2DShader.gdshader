shader_type canvas_item;

uniform sampler2D frame : filter_nearest, source_color;
uniform float directions = 8;
uniform bool orientation = true;

varying mat4 matrix;
varying mat4 c_matrix;

//The issue with the following approach is that all transforms are ignored...
// (animation and region still works)
void vertex() {
	matrix = MODEL_MATRIX;
	c_matrix = CANVAS_MATRIX;
	
	//Resize to size of one frame direction
	if (orientation) {	//Vertical
		VERTEX.y *= 1.0 / directions;} 
	else {				//Horizontal
		VERTEX.x *= 1.0 / directions;}

	// Extract the normalized rotation part of the MODELVIEW_MATRIX
	vec2 rotation_x = normalize(c_matrix[0].xy);
	vec2 rotation_y = normalize(c_matrix[1].xy);
	mat2 rotation_matrix = mat2(rotation_x, rotation_y);

	// Calculate the inverse of the rotation matrix
	mat2 inv_rotation_matrix = inverse(rotation_matrix);

	// Apply the inverse rotation to the vertex to counteract node rotation
	VERTEX = inv_rotation_matrix * VERTEX;
}

void fragment() {
	float inv_directions = 1.0 / directions;
	float direction_angle = (2.0 * PI) / directions;
	
	mat2 rotation_matrix = mat2(matrix[0].xy, matrix[1].xy);
	float rads = atan(rotation_matrix[0].y, rotation_matrix[0].x);
	
	mat2 c_rotation_matrix = mat2(c_matrix[0].xy, c_matrix[1].xy);
	float c_rads = atan(c_rotation_matrix[0].y, c_rotation_matrix[0].x);
	
	rads = c_rads - rads;

	if (rads < 0.0) {
		rads += 2.0 * PI;	//Convert to positive equivalent
	}
	//Fixes when rad is between last dir∠ to 360deg
	//Still minor issues here, but works for now
	if (!(rads >= direction_angle * (directions - 1.0))) {	
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
	
	//vec4 tex_color = texture(TEXTURE, region_uv);
	vec4 tex_color = texture(frame, region_uv);
	COLOR = tex_color;
	NORMAL = texture(NORMAL_TEXTURE, UV).rgb;
}
