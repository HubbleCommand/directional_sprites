class_name DirectionalHelpers
#No static const? strange... could make const
const props : Array[String] = [
	"billboard", "transparent", "double_sided",
	"no_depth_test", "fixed_size", "alpha_scissor_threshold", 
	"alpha_hash_scale", "alpha_antialiasing_edge",
	"directions", "orientation"]
	

static func set_shader_param(material: Material, key: String, value: Variant) -> void:
	if material != null:
		#print("setting %s to %s" % [key, str(value)])
		material.set_shader_parameter(key, value)
		#_rebuild_frame()
		#if Engine.is_editor_hint():
		#	notify_property_list_changed ( )

## Cut the target frame out of the image
static func rebuild_animated_frame(material: Material, sprite_frames: SpriteFrames, animation: String, frame: int):
	
	if sprite_frames == null:
		return
	if material == null:
		return
	
	var texture = sprite_frames.get_frame_texture(animation, frame)
	
	if texture == null:
		return
		
	material.set_shader_parameter("views", texture)
