@tool
extends MeshInstance3D #DirectionalSpriteBase3D
## n-Directional Sprite
## It is recommended to not change the inherited class' parameters
#class_name DirectionalSprite3D

@export var directions: int = 1:
	set(value):
		directions = value
		if Engine.is_editor_hint():
			material.set_shader_parameter("directions", value)
		notify_property_list_changed ( )
@export var texture: Texture2D:
	set(value):
		texture = value
		if Engine.is_editor_hint():
		#if value != null:
			material.set_shader_parameter("views", value)
		notify_property_list_changed ( )

"""
Read
https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html#doc-accessing-data-or-logic-from-object
"""
"""
For now, just doing basic shader with no frames
If you want animations, use AnimatedDirectionalSprite3D
Can look into this after
"""
"""
@export_category("Animation")
@export var hframes: int = 1:
	set(value):
		hframes = value
		_update_frames()
		notify_property_list_changed ( )
		
@export var vframes: int = 1:
	set(value):
		vframes = value
		_update_frames()
		notify_property_list_changed ( )
		
@export var frame: int = 0:
	set(value):
		frame = value
		#frame_coords =
		notify_property_list_changed ( )
		
@export var frame_coords: Vector2i = Vector2i(0, 0):
	set(value):
		frame_coords = value
		#frame = 
		

func _update_frames():
	pass
"""

@onready var shader = preload("DirectionalSprite3DShader.gdshader")
@onready var material = ShaderMaterial.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh = QuadMesh.new()
	
	material.shader = shader
	set_surface_override_material(0, material)
	
	if texture != null:
		material.set_shader_parameter("views", texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Test code for building Texture2DArray that will be passed
# through the shader's sampler2DArray
func _build_shader_images() -> void:
	
	var t2da = Texture2DArray.new()
	#Texture2DArray inherits from ImageTextureLayered, which has create_from_images()
	#var error = t2da.create_from_images()
	
	#Maybe instead of using array, can do as single image
	# like in existing shader?
	# should investigate memory etc.
	
	#Each processed frame should contain the 8 directions
	# otherwise, need to make new dock...
	# also, many samples seem to be organized like that, including DOOM

"""
func _enter_tree() -> void:
	mesh = QuadMesh.new()
	
	#var material = mesh.surface_get_material(0)
	material.shader = shader
	
	set_surface_override_material(0, material)
	pass
"""
