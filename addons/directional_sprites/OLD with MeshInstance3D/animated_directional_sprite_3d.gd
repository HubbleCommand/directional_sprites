"""
FORGET THIS !!??!?
Use script of AnimatedSprite3D
then should be much easier...
Shader will probably have to be changed a bit...

ALSO, for simplicity in the editor, just use
type-global orientation and directions,
not for each animation
otherwise, gets too messy
"""

@tool
extends MeshInstance3D #DirectionalSpriteBase3D
## n-Directional Animated Sprite
## It is recommended to not change the inherited class' parameters
#class_name AnimatedDirectionalSprite3D

"""
So, need to determine how to best store some of this info...

"""
"""
@export var orientation: Orientation = VERTICAL
#@export var animation_data: Array[AnimationData] = []

class AnimationData extends Resource:
	@export var orientation: Orientation = VERTICAL
	@export var directions: int = 1
@export var animation_data: Array[Resource]:
	set(value):
		print("Updating data")
		animation_data.resize(value.size())
		animation_data = value
		for i in animation_data.size():
			if not animation_data[i]:
				animation_data[i] = AnimationData.new()
		notify_property_list_changed ( )
"""


class AnimationData extends Resource:
	@export var orientation: Orientation = VERTICAL
	@export var directions: int = 1
class AnimationsData extends Resource:
	@export var animations: Array[AnimationData]
@export var animations_data: AnimationsData = AnimationsData.new()

#Below from AnimatedSprite
@export var sprite_frames: SpriteFrames:
	set(value):
		sprite_frames = value
		print("SpriteFrames updated")
@export var animation: StringName = &"default"
@export var frame: int = 0
@export var speed_scale: float = 1.0

@onready var shader = preload("AnimatedDirectionalSprite3DShader.gdshader")
@onready var material = ShaderMaterial.new()

#Signals from AnimatedSprite3D
signal animation_changed()
signal animation_finished()
signal animation_looped()
signal frame_changed()
signal sprite_frames_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh = QuadMesh.new()
	
	material.shader = shader
	set_surface_override_material(0, material)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enter_tree() -> void:
	mesh = QuadMesh.new()
	pass



# Create same methods as AnimatedSprite3D
func play(name: StringName = &"", custom_speed: float = 1.0, from_end: bool = false):
	pass
