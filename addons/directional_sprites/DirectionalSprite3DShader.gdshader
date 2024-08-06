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


varying mat4 matrix;
varying mat4 c_matrix;

void vertex() {
	matrix = MODEL_MATRIX;
	c_matrix = VIEW_MATRIX;
	
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
	
	//NORMAL = vec3(255.0);
}


void fragment() {
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	ALPHA_HASH_SCALE = alpha_hash_scale;
	ALPHA_ANTIALIASING_EDGE = alpha_antialiasing_edge;

	if (billboard == 0 && !FRONT_FACING && double_sided) {
		NORMAL.z = -NORMAL.z; //Only need to flip Z normal if no billboarding (otherwise only shows half...ish)
	}
	
	//TODO do like in 2d, calc rot
	//mat4 matrix = MODEL_MATRIX;
	//mat4 c_matrix = VIEW_MATRIX;
	
	//mat4 diff_matrix = MODEL_MATRIX - VIEW_MATRIX;
	//mat4 diff_matrix = MODEL_MATRIX;
	mat4 diff_matrix = matrix;
	//Can just use atan instead of atan2... atan(2/1) = atan2(2, 1)
	//https://forum.godotengine.org/t/missing-atan2-function/47410/2
	float y = atan(-diff_matrix[0][0], diff_matrix[2][0]);
	float p = asin(diff_matrix[1][0]);
	float r = atan(-diff_matrix[1][2] / diff_matrix[1][1]);
	
	
	vec3 local_direction = vec3(0.0, 0.0, -1.0);
    
    // Transform the local direction to world space using the node's transformation matrix
    mat4 node_transform = MODEL_MATRIX;
    vec3 node_direction_world = (node_transform * vec4(local_direction, 0.0)).xyz;
    
    // Normalize the direction vector to ensure it has a length of 1
    node_direction_world = normalize(node_direction_world);
	
	/*
	vec3 diff_direction = node_direction_world - CAMERA_DIRECTION_WORLD;
	diff_direction.z = 0.0;
	diff_direction.x = 0.0;
	ALBEDO = diff_direction ;//* 0.5 + 0.5;
	*/
	
	vec3 modelWorldForward = MODEL_MATRIX[2].xyz;
	float modelWordHeading = atan(modelWorldForward.x / modelWorldForward.z);	//may need to inverse due to difference in coordinate system handedness
	vec3 modelWorldPos = MODEL_MATRIX[3].xyz;
	vec3 modelToCam = CAMERA_POSITION_WORLD.xyz - modelWorldPos;
	float modelToCamAngle = atan(modelToCam.x / modelToCam.z);
	float angleDiff = modelToCamAngle - modelWordHeading;
	
	if (angleDiff < PI) {
		ALBEDO = vec3(1, 0, 0);
	}
	//ALBEDO = vec3(angleDiff, 1, 1);
	
	//_WorldSpaceCameraPos	float3	World space position of the camera.
	
	/*
	 // object's forward vector (local +Z direction)
    float3 objWorldForward = unity_ObjectToWorld._m02_m12_m22;	//MODEL_MATRIX
    //get objects current Y rotation from its rotation matrix in radians
    float objWorldHeading = atan2(objWorldForward.z, objWorldForward.x);

    // object's world position
    float3 objWorldPos = unity_ObjectToWorld._m03_m13_m23;
    // get angle between object and camera in radians
    float3 objToCam = _WorldSpaceCameraPos.xyz - objWorldPos;
    float objToCamAngle = atan2(objToCam.z, objToCam.x);

    // get angle difference between heading and camera relative position
    float angleDiff = objToCamAngle - objWorldHeading;

    // get current tilesheet frame and feed it to UV also subtracts objects Y rotation frames from the current index
    float index = round(angleDiff / SINGLEFRAMEANGLE);

    o.uv = float2(v.texcoord.x * UVOFFSETX + UVOFFSETX * index, v.texcoord.y);

    o.pos = mul(UNITY_MATRIX_P,
        mul(UNITY_MATRIX_V, float4(objWorldPos, 1.0))
        + float4(v.vertex.x, v.vertex.y, 0.0, 0.0));

    return o;*/
	
	
    
    // Now you can use node_direction_world for your shader logic
    // For example, output the direction as color (for debugging purposes)
    
	//ALBEDO = vec3(y, p, r);
	
	//ALBEDO = NORMAL;
	//ALBEDO = vec3(NORMAL.z, 1.0 / NORMAL.z, 1.0 - NORMAL.z);
	//ALBEDO = vec3(TANGENT.z);
	//ALBEDO = vec3(MODEL_MATRIX[0].rgb);
	//ALBEDO = vec3(MODEL_NORMAL_MATRIX[0]);	//THIS CAUSES SOME MASSIVE CRASHES
	//ALBEDO = vec3(FRONT_FACING ? 1.0 : 0.0);
	
	float inv_directions = 1.0 / directions;
	float direction_angle = TAU / directions;
	
	
	float d = dot(NORMAL.zx, vec2(-1, 0));
	float angle = -acos(NORMAL.z) + TAU/2.0;
	//float angle = -acos(NORMAL.z) + PI;
	//float frame_number = NORMAL.x > 0.0 ? angle/TAU : 1.0 - angle/TAU;
	float frame_number = floor(angleDiff / direction_angle);
	float axis = 0.0; // UV horizontal start for the view in the atlas
	axis = round(frame_number * directions) / directions;

	float view_width = 1.0 / directions; // UV width of the view in the atlas
	vec4 tex;
	if (orientation) {
		tex = texture(views, vec2(UV.x, axis + view_width * UV.y));
	} else {
		tex = texture(views, vec2(axis + view_width * UV.x, UV.y));
	}
	/*ALBEDO = tex.rgb;
	ALBEDO *= COLOR.rgb;	//Add support for modulation, see documentation of SpriteBase3D modulate property

	if (transparent) {
		ALPHA = round(tex.a);
	}*/
}