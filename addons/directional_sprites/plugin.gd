@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("DirectionalSprite3D", "Sprite3D", preload("directional_sprite_3d.gd"), preload("./icons/DirectionalSprite3D.svg"))
	add_custom_type("AnimatedDirectionalSprite3D", "AnimatedSprite3D", preload("animated_directional_sprite_3d.gd"), preload("./icons/AnimatedDirectionalSprite3D.svg"))
	add_custom_type("DirectionalSprite2D", "Sprite2D", preload("directional_sprite_2d.gd"), preload("./icons/DirectionalSprite2D.svg"))
	add_custom_type("AnimatedDirectionalSprite2D", "AnimatedSprite2D", preload("animated_directional_sprite_2d.gd"), preload("./icons/AnimatedDirectionalSprite2D.svg"))


func _exit_tree() -> void:
	remove_custom_type("DirectionalSprite3D")
	remove_custom_type("AnimatedDirectionalSprite3D")
	remove_custom_type("DirectionalSprite2D")
	remove_custom_type("AnimatedDirectionalSprite2D")
