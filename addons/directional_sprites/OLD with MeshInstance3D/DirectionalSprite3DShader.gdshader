shader_type spatial;
render_mode unshaded;


uniform sampler2D views : filter_nearest, source_color;
uniform float directions = 8;
uniform float grow = 0.0;


void vertex() {
	// billboard mode from the default material
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	VERTEX += grow * NORMAL;
}


void fragment() {
	float d = dot(NORMAL.zx, vec2(-1, 0));
	float angle = -acos(NORMAL.z) + TAU/2.0;
	float current_view = NORMAL.x > 0.0 ? angle/TAU : 1.0 - angle/TAU;
	float x = 0.0; // UV horizontal start for the view in the atlas
	x = round(current_view * directions) / directions;
	
	float view_width = 1.0 / directions; // UV width of the view in the atlas
	vec4 tex = texture(views, vec2(x + view_width * UV.x, UV.y));
	ALBEDO = tex.rgb;
	ALPHA = round(tex.a);
}