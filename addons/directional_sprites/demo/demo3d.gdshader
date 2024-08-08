shader_type spatial;
//unshaded isn't necessary, but without a proper normal_map sprite shading is kinda ugly
//render_mode unshaded, depth_prepass_alpha, depth_draw_opaque; 
render_mode unshaded, cull_disabled; 

// rows - directions, column - animation frames
// First (0) row - front
// Last row - back
// Rows inbetween - consecutive rotations
// this shader flipping left/right, but doing unique directions is trivial

uniform sampler2D sprite_sheet: filter_nearest, source_color;//filter_nearest_mipmap;

// Total rows and columns
uniform int n_rows = 5;
uniform int n_columns = 4;
uniform bool play = true;

varying vec3 look_dir;

void vertex() {
	// Y-Billboarding
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	// We use pre-billboard quad's NORMAL as monster look_direction
	look_dir = MODELVIEW_NORMAL_MATRIX * NORMAL;
	//What's the purpose of this?
	//MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	VERTEX.y *= 1.0 / float(n_rows);
	VERTEX.x *= 1.0 / float(n_columns);
}

//For testing
const vec3[] direction_colors = {
	vec3(0, 0, 0),	//Black		//front
	vec3(1, 0, 0),	//Red
	vec3(0, 1, 0),	//Green
	vec3(0, 0, 1),	//Blue
	vec3(1, 1, 0),	//Yellow	//back
	vec3(1, 1, 1),	//White
	vec3(0, 1, 1),	//Cyan
	vec3(1, 0, 1)	//Pink
};

void fragment() {
	float f_ncolumns = float(n_columns);
	// Simple frame looping
	// Animation frames should be controlled by script/uniform
	float current_frame = play ? trunc(mod(TIME * 5.0, f_ncolumns)) : 0.0;
	
	// cam_dir = CAMERA_DIRECTION_WORLD; is sufficient for orthogonal camera
	vec3 ray_origin = CAMERA_POSITION_WORLD;
	// Instead of calculating object origin, uniform for mesh.global_position wold work better for x/y impostor billboard
	vec3 object_origin = (MODEL_MATRIX * vec4(0.0,0.0,0.0,1.0)).xyz;
	vec3 cam_dir = object_origin - ray_origin;
	cam_dir = normalize((VIEW_MATRIX * vec4(cam_dir, 0.0)).xyz);
	
	// Getting direction through dot product
	// Assumin that NPC looking at it's positive Z direction
	float angle = 180.0 + degrees(acos(dot(normalize(cam_dir.xz), normalize(look_dir.xz))));
	
	//float side = sign((look_dir.x * cam_dir.z) - (look_dir.z * cam_dir.x));
	float side = -sign((look_dir.x * cam_dir.z) - (look_dir.z * cam_dir.x));
	
	//float current_view = side > 0.0 ? angle/360.0 : 360.0 - angle/360.0;
	float current_view = side > 0.0 ? angle/180.0 : 360.0 - angle/180.0;
	float _direction = round(current_view * f_ncolumns);
	//float _direction = round(angle/180.0 * f_ncolumns);
	
	ALBEDO = direction_colors[int(_direction)];
	
	// Flipping left/right animations based on cross product
	float flip = sign((look_dir.x * cam_dir.z) - (look_dir.z * cam_dir.x));
	// Here we ignore flipping for "back" and "front" frames
	// actually DOES matter, dipshit...
	//flip = mix(flip, 1.0, max(step(_direction, 0.0), step(f_ncolumns, _direction)));
	
	// Getting correct frame
	//TODO still need to get orientation to work here
	vec2 frame = vec2(current_frame, _direction);
	vec2 frame_size = vec2(f_ncolumns, float(n_rows));
	vec4 tex = texture(sprite_sheet, (UV + frame) / frame_size);
	
	ALBEDO = tex.rgb;
	ALPHA =  tex.a;
}