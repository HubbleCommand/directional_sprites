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

## The orientation the directions are in the Frames
## 1 is vertical, 0 is horizontal
@export var orientation: Orientation = HORIZONTAL:
	set(value):
		orientation = value
		var send = false if value == HORIZONTAL else true
		material.set_shader_parameter("orientation", send)
		if Engine.is_editor_hint():
			notify_property_list_changed ( )

func _set(property: StringName, value: Variant) -> bool:
	#Animation-related props require rebuilding frames
	# NOT REQUIRED, already handled...
	#if property == "hframes" || property == "vframes" || property == "frame" || property == "frame_coords":
	if property in DirectionalHelpers.props:
		DirectionalHelpers.set_shader_param(material, property, value)
		
	return false

@onready var shader = preload("DirectionalSprite2DShader.gdshader")
@onready var shadermaterial = ShaderMaterial.new()


func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = shader
	
	DirectionalHelpers.set_shader_param(material, "frame", texture)
	DirectionalHelpers.set_shader_param(material, "orientation", orientation)
	DirectionalHelpers.set_shader_param(material, "directions", directions)


#deprecated
var _frames: Texture2DArray
func _build_frames() -> void:
	var image : Image = texture.get_image().duplicate()
	
	# Cannot do following operations if image is compressed
	if image.is_compressed():
		image.decompress()
	
	#Um, the next line should at least show a warning...
	#var frames_array = Array[Image]
	var frames_array : Array[Image] = []
	
	var axis_size : int = image.get_height() if orientation else image.get_width()
	var axis_size_single: int = axis_size / directions
	for n in range(directions):
		var region: Rect2i
		
		if orientation:	#Vertical
			region = Rect2i(0, axis_size_single * n, image.get_width(), axis_size_single)
		else:	# Horizontal
			region = Rect2i(axis_size_single * n, 0, axis_size_single, image.get_height())
		frames_array.append(image.get_region(region))
	
	_frames = Texture2DArray.new()
	_frames.create_from_images(frames_array)
	DirectionalHelpers.set_shader_param(material, "frames", _frames)
