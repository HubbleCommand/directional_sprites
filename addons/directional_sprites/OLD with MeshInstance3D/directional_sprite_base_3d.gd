@tool
@icon("res://addons/directionalsprites3d/icons/Node.svg")
class_name DirectionalSpriteBase3D
extends MeshInstance3D

#Directional equivalent of SpriteBase3D
# nothing is currently hooked up

@export var centered: bool = true
@export var offset: Vector2 = Vector2(0, 0)
@export var flip_h: bool = false
@export var flip_v: bool = false
@export var modulate: Color = Color(1, 1, 1, 1)
@export var pixel_size: float = 0.01
#Vector3 has AXIS_X, AXIS_Y, and AXIS_Z constants
#in SpriteBase3D is Vector3.Axis, but that doesn't exist
#@export_enum(Ve) var axis: Ax
enum Vector3Axis {AXIS_X, AXIS_Y, AXIS_Z}
@export var axis: Vector3Axis = 2

@export_category("Flags")
@export var billboard: BaseMaterial3D.BillboardMode = 0
@export var transparent: bool = true
@export var shaded: bool = false
@export var double_sided: bool = true
@export var no_depth_test: bool = false
@export var fixed_size: bool = false
@export var alpha_cut_mode: SpriteBase3D.AlphaCutMode = 0
@export var alpha_scissor_threshold: float = 0.5
@export var alpha_hash_scale: float = 1.0
@export var alpha_antialiasing_mode: BaseMaterial3D.AlphaAntiAliasing = 0
@export var alpha_antialiasing_edge: float = 0.0
@export var texture_filter: BaseMaterial3D.TextureFilter = BaseMaterial3D.TextureFilter.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
@export var render_priority: int = 0
