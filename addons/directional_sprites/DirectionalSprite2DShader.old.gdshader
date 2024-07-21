shader_type canvas_item;

// Views of the current frame
uniform sampler2D views : filter_nearest, source_color;
uniform float directions = 8;
//Same as Orientation enum, 0 / false is HORIZONTAL, 1 / true is VERTICAL
uniform bool orientation = false;

varying vec2 rotated_uv;
varying mat4 matrix;

void vertex() {
	//TODO there is a LOT more to do here
	// I can't think of an appropriate way to do this...
	// Node rotation is a place to start...
	// Need to use MODEL_MATRIX and CANVAS_MATRIX
	
	
	// Ok... going to be a bit of a pain, but I think I've figured this out...
	// use rotation as before
	// but split from SCRIPT the sprite, and pass individual frames to shader
	// then, switch which frame is used...
	// because doing anti-rotation stuff with everything else
	// directly in the shader causes leaking between frames...
	
	matrix = MODEL_MATRIX;
	
	
	//Reverse rotation
	// this doesn't work that well...
	mat2 rotation_matrix = mat2(MODEL_MATRIX[0].xy, MODEL_MATRIX[1].xy);
	//mat2 inverse_rotation = transpose(rotation_matrix);
	float angle_radians = atan(rotation_matrix[0].y, rotation_matrix[0].x);
    
    // Counteract rotation to keep texture vertical
    mat2 inverse_rotation = mat2(vec2(cos(-angle_radians), -sin(-angle_radians)),
                                 vec2(sin(-angle_radians), cos(-angle_radians)));
	rotated_uv = inverse_rotation * (UV - vec2(0.5)) + vec2(0.5);
	
	if (orientation) {
		VERTEX.y *= 1.0 / directions;
	} else {
		VERTEX.x *= 1.0 / directions;
	}
	//First part of
	//https://docs.godotengine.org/en/4.1/tutorials/shaders/
	//	shader_reference/canvas_item_shader.html#vertex-built-ins
	//VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	//vec2 region_uv = UV * vec2(0.125, 1.0) + vec2(0.125, 0.0);
	vec2 region_uv;
	if (orientation) {
		region_uv = rotated_uv * vec2(1, 1.0/directions);
	} else {
		region_uv = rotated_uv * vec2(1.0/directions, 1);
	}
	
	vec4 tex_color = texture(TEXTURE, region_uv);
	COLOR = tex_color;
	
	
	mat2 rotation_matrix = mat2(matrix[0].xy, matrix[1].xy);
	float rads = atan(rotation_matrix[0].y, rotation_matrix[0].x);
	//rotation = degrees(angle_radians);
	//Rotation varies between 0 and 2π
	
	float radlimmi = (360.0 - mod(rads, 360.0)) / 360.0;
	COLOR.r = radlimmi;
}
