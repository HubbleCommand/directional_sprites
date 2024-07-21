shader_type spatial;
render_mode unshaded, cull_disabled;
//cull_disabled REQUIRED FOR BOTH SIDES TO SHOW... still need to fix some other shiz
// Doesn't seem like I can change render_mode based on uniform...
// but there is https://www.reddit.com/r/godot/comments/15cefln/this_is_how_you_configure_the_render_modes_in_a/

// Animation support by passing entire animation data (dunno abt this...)
//TODO use this instead I think
//uniform sampler2DArray animation_frames : filter_nearest, source_color;
//uniform int frame: hint_range(0, 100, 1) = 0;

// Views of the current frame
uniform sampler2D views : filter_nearest, source_color;
uniform float directions = 8;
//Same as Orientation enum, 0 / false is HORIZONTAL, 1 / true is VERTICAL
uniform bool orientation = false;

//Other properties of SpriteBase3D, like Rect, Frame, and Centered, are already supported

//SpriteBase3D Flags that need to be handled here
//0 = Disabled, 1 = Enabled, 2 = Y-Billboard
uniform int billboard = 0;
uniform bool transparent = true;
//Shaded unsupported
uniform bool double_sided = true; //TODO //Only works if no billboard mode
uniform bool no_depth_test = false; //TODO
uniform bool fixed_size = false; //TODO
//Alpha cut cannot find
uniform float alpha_scissor_threshold: hint_range(0.0, 1.0) = 0.5; //TODO
uniform float alpha_hash_scale: hint_range(0.0, 2.0) = 1.0; //TODO
//Antialiasing mode not found
uniform float alpha_antialiasing_edge: hint_range(0.0, 1.0) = 0.0; //TODO
//Texture filter not supported as uniform
//Render priority cannot find

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
}


void fragment() {
	if (billboard == 0 && !FRONT_FACING && double_sided) {
		NORMAL.z = -NORMAL.z; //Only need to flip Z normal if no billboarding (otherwise only shows half...ish)
    }

	//THis stuff needs to change based on orientation as well...
	float d = dot(NORMAL.zx, vec2(-1, 0));
	float angle = -acos(NORMAL.z) + TAU/2.0;
	float current_view = NORMAL.x > 0.0 ? angle/TAU : 1.0 - angle/TAU;
	//float x = 0.0; // UV horizontal start for the view in the atlas
	//x = round(current_view * directions) / directions;
	float axis = 0.0; // UV horizontal start for the view in the atlas
	axis = round(current_view * directions) / directions;

	float view_width = 1.0 / directions; // UV width of the view in the atlas
	//vec4 tex = texture(views, vec2(x + view_width * UV.x, UV.y));
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