shader_type spatial;
render_mode unshaded, cull_disabled;

// Views of the current frame
uniform sampler2D views : filter_nearest, source_color;
uniform float directions = 8;
//Same as Orientation enum, 0 / false is HORIZONTAL, 1 / true is VERTICAL
uniform bool orientation = false;

//Below are SpriteBase3D Flags that need to be handled here
//	other properties of SpriteBase3D, like Rect, Frame, and Centered, have built-in
//0 = Disabled, 1 = Enabled, 2 = Y-Billboard
uniform int billboard = 0;
uniform bool transparent = true;
//Shaded unsupported, is defined in the render_mode and cannot be modified
uniform bool double_sided = true; //TODO //Only works if no billboard mode
uniform bool no_depth_test = false; //TODO
uniform bool fixed_size = false; //TODO
//Alpha cut cannot find
uniform float alpha_scissor_threshold: hint_range(0.0, 1.0) = 0.5;
uniform float alpha_hash_scale: hint_range(0.0, 2.0) = 1.0;
//Antialiasing mode not found
uniform float alpha_antialiasing_edge: hint_range(0.0, 1.0) = 0.0;
//Texture filter not supported as uniform
//Render priority cannot find

varying vec3 look_dir;

void vertex() {
	if(billboard == 1) {
		//Rotate to identity matrix, removing rotation and aligning to the camera
		MODELVIEW_MATRIX[0].xyz = vec3(1.0, 0.0, 0.0);
        MODELVIEW_MATRIX[1].xyz = vec3(0.0, 1.0, 0.0);
        MODELVIEW_MATRIX[2].xyz = vec3(0.0, 0.0, 1.0);
	} else if (billboard == 2) {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	}

	if (orientation) {
		VERTEX.y *= 1.0 / directions;
	} else {
		VERTEX.x *= 1.0 / directions;
	}

	look_dir = MODELVIEW_NORMAL_MATRIX * NORMAL;
}


void fragment() {
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	ALPHA_HASH_SCALE = alpha_hash_scale;
	ALPHA_ANTIALIASING_EDGE = alpha_antialiasing_edge;

	if (billboard == 0 && !FRONT_FACING && double_sided) {
		NORMAL.z = -NORMAL.z; //Only need to flip Z normal if no billboarding (otherwise only shows half...ish)
	}

	vec3 ray_origin = CAMERA_POSITION_WORLD;
	// Instead of calculating object origin, uniform for mesh.global_position wold work better for x/y impostor billboard
	vec3 object_origin = (MODEL_MATRIX * vec4(0.0,0.0,0.0,1.0)).xyz;
	vec3 cam_dir = object_origin - ray_origin;
	cam_dir = normalize((VIEW_MATRIX * vec4(cam_dir, 0.0)).xyz);
	
	// Getting direction through dot product
	// Assumin that NPC looking at it's positive Z direction
	float angle = 180.0 + degrees(acos(dot(normalize(cam_dir.xz), normalize(look_dir.xz))));
	
	float side = -sign((look_dir.x * cam_dir.z) - (look_dir.z * cam_dir.x));
	
	//float current_view = side > 0.0 ? angle/360.0 : 360.0 - angle/360.0;
	//Why does dividing by 360 work here, and not by 180
	// but in the demo shader, dividing by 360 doesn't work, but by 180 does?
	// there's something I'm missing here, but it's working, so huzzah
	float current_view_angle = side > 0.0 ? angle/360.0 : 180.0 - angle/360.0;
	float direction = round(current_view_angle * directions);
	float axis = round(direction) / directions; // UV axial start for the view in the atlas

	float view_width = 1.0 / directions; // UV width of the view in the atlas
	vec4 tex;
	if (orientation) {
		tex = texture(views, vec2(UV.x, axis + view_width * UV.y));
	} else {
		tex = texture(views, vec2(axis + view_width * UV.x, UV.y));
	}
	
	ALBEDO = tex.rgb;
	ALBEDO *= COLOR.rgb;	//Add support for modulation, see documentation of SpriteBase3D modulate property

	if (transparent) {
		ALPHA = round(tex.a);
	}
}