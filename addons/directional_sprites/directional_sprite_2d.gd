## n-directional Sprite for 2D space
@tool
extends Sprite2D
class_name DirectionalSprite2D


## The number of directions each frame contains (in left-to-right direction)
@export var directions: int = 1:
	set(value):
		directions = value
		DirectionalHelpers.set_shader_param(material, "directions", value)
		if Engine.is_editor_hint():
			notify_property_list_changed ( )
		item_rect_changed.emit()

## The orientation the directions are in the Frames
## 1 is vertical, 0 is horizontal
@export var orientation: Orientation = HORIZONTAL:
	set(value):
		orientation = value
		var send = false if value == HORIZONTAL else true
		material.set_shader_parameter("orientation", send)
		if Engine.is_editor_hint():
			notify_property_list_changed ( )
		item_rect_changed.emit()


func _set(property: StringName, value: Variant) -> bool:
	print("var set")
	#Animation-related props require rebuilding frames
	# NOT REQUIRED, already handled...
	#if property == "hframes" || property == "vframes" || property == "frame" || property == "frame_coords":
	if property in DirectionalHelpers.props:
		DirectionalHelpers.set_shader_param(material, property, value)
		item_rect_changed.emit()
	return false

@onready var shader = preload("DirectionalSprite2DShader.gdshader")
@onready var shadermaterial = ShaderMaterial.new()


func _texture_changed():
	DirectionalHelpers.set_shader_param(material, "frame", texture)
	item_rect_changed.emit()

func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = shader
	
	texture_changed.connect(_texture_changed)
	
	DirectionalHelpers.set_shader_param(material, "frame", texture)
	DirectionalHelpers.set_shader_param(material, "orientation", orientation)
	DirectionalHelpers.set_shader_param(material, "directions", directions)

##Rect is not modified by the node's transform (rotation, global position, scale)
## Note that Region is not supported, as it is not supported by the shaders
func get_rect() -> Rect2:
	var rect = super()
	if not texture:
		return Rect2(Vector2.ZERO, Vector2.ONE)
	
	if orientation == Orientation.HORIZONTAL:
		rect.size.x /= directions
		rect.position.x /= directions
	else:
		rect.size.y /= directions
		rect.position.y /= directions

	return rect
	
