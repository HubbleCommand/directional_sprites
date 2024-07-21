## n-direction sprite that supports animations through SpriteFrames,
## like the AnimatedSprite2D node.

## Make sure all of your animations and frames have 
## the same orientation and number of directions.
@tool
extends AnimatedSprite2D
class_name AnimatedDirectionalSprite2D

@onready var shader = preload("DirectionalSprite2DShader.gdshader")

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

func _ready() -> void:
	# Create shader and attach
	material = ShaderMaterial.new()
	material.shader = shader
	
	# Connect signals to update Shader parameters
	animation_changed.connect(_rebuild_frame)
	animation_finished.connect(_rebuild_frame)
	animation_looped.connect(_rebuild_frame)
	frame_changed.connect(_rebuild_frame)
	sprite_frames_changed.connect(_rebuild_frame)
	
	DirectionalHelpers.set_shader_param(material, "orientation", orientation)
	DirectionalHelpers.set_shader_param(material, "directions", directions)
	_rebuild_frame()


## Cut the target frame out of the image
func _rebuild_frame():
	
	if sprite_frames == null:
		return
	if material == null:
		return
	
	var texture = sprite_frames.get_frame_texture(animation, frame)
	
	if texture == null:
		print("null texture")
		return
		
	material.set_shader_parameter("frame", texture)
