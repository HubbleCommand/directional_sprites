## n-directional Sprite for 3D space
@tool
extends Sprite3D
class_name DirectionalSprite3D

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

"""
Listen for property updates to set shader params
https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-private-method-set
https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-private-method-get-property-list
"""
func _set(property: StringName, value: Variant) -> bool:
	if property in DirectionalHelpers.props:
		DirectionalHelpers.set_shader_param(material, property, value)

	return false

@onready var shader = preload("DirectionalSprite3DShader.gdshader")
@onready var material = ShaderMaterial.new()

func _texture_changed():
	DirectionalHelpers.set_shader_param(material, "views", texture)

func _ready() -> void:
	material.shader = shader
	material_override = material
	
	#frame_changed signal handled by node & region info
	texture_changed.connect(_texture_changed)

	#Set shader params on ready for immediate effect when node starts
	DirectionalHelpers.set_shader_param(material, "views", texture)
	
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
