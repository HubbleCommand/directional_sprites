## n-direction sprite that supports animations through SpriteFrames
@tool
extends AnimatedSprite3D
class_name AnimatedDirectionalSprite3D

func _set(property: StringName, value: Variant) -> bool:
	if property in DirectionalHelpers.props:
		DirectionalHelpers.set_shader_param(material, property, value)
		
	return false

## The number of directions each frame contains (in left-to-right direction)
@export var directions: int = 1:
	set(value):
		directions = value
		DirectionalHelpers.set_shader_param(material, "directions", value)
		if Engine.is_editor_hint():
			notify_property_list_changed ( )

## The orientation the directions are in the Frames
## 1 is vertical, 0 is horizontal
@export var orientation: Orientation = HORIZONTAL:
	set(value):
		orientation = value
		var send = false if value == HORIZONTAL else true
		DirectionalHelpers.set_shader_param(material, "orientation", send)
		if Engine.is_editor_hint():
			notify_property_list_changed ( )


@onready var shader = preload("DirectionalSprite3DShader.gdshader")
@onready var material = ShaderMaterial.new()

func _ready() -> void:
	# Create shader and attach
	material.shader = shader
	material_override = material
	
	# Connect signals to update Shader parameters
	"""
	animation_changed.connect(_f_animation_changed)
	animation_finished.connect(_f_animation_finished)
	animation_looped.connect(_f_animation_looped)
	frame_changed.connect(_f_frame_changed)
	sprite_frames_changed.connect(_f_sprite_frames_changed)
	"""
	animation_changed.connect(_rebuild_frame)
	animation_finished.connect(_rebuild_frame)
	animation_looped.connect(_rebuild_frame)
	frame_changed.connect(_rebuild_frame)
	sprite_frames_changed.connect(_rebuild_frame)
	
	_rebuild_frame()
	
	#Set initial values in shader
	DirectionalHelpers.set_shader_param(material, "orientation", orientation)
	DirectionalHelpers.set_shader_param(material, "directions", directions)
	
	DirectionalHelpers.set_shader_param(material, "billboard", billboard)
	DirectionalHelpers.set_shader_param(material, "transparent", transparent)
	DirectionalHelpers.set_shader_param(material, "double_sided", double_sided)
	DirectionalHelpers.set_shader_param(material, "no_depth_test", no_depth_test)
	DirectionalHelpers.set_shader_param(material, "fixed_size", fixed_size)
	DirectionalHelpers.set_shader_param(material, "alpha_scissor_threshold", alpha_scissor_threshold)
	DirectionalHelpers.set_shader_param(material, "alpha_hash_scale", alpha_hash_scale)
	DirectionalHelpers.set_shader_param(material, "alpha_antialiasing_edge", alpha_antialiasing_edge)

"""
func _f_animation_changed():
	print("animation changed")
	_rebuild_frame()

func _f_animation_finished():
	print("animation finished")
	_rebuild_frame()

func _f_animation_looped():
	print("animation looped")
	_rebuild_frame()

func _f_frame_changed():
	print("frame changed")
	_rebuild_frame()

func _f_sprite_frames_changed():
	print("sprite frames changed")
	_rebuild_frame()
"""


## Cut the target frame out of the image
func _rebuild_frame():
	
	if sprite_frames == null:
		return
	if material == null:
		return
	
	var texture = sprite_frames.get_frame_texture(animation, frame)
	
	if texture == null:
		return
		
	material.set_shader_parameter("views", texture)
	
	#var image = texture.get_image()
	#print("Got image from texture")
	#var size = image.get_size()
	#x, y, width, height
	#var frame = image.get_region(Rect2i())
	#material.set_shader_parameter("views", frame)
