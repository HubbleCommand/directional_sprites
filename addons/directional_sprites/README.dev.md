# Developer README

## Origin
After some research, I stumbled upon [this](https://github.com/godotengine/godot-proposals/discussions/5082) proposal, which is continued by Calinou [here](https://github.com/Calinou/godot-demo-projects/blob/add-first-person-shooter/3d/first_person_shooter/enemy/enemy.gdshader).

However, the shader actually doesn't work correctly when rotating the camera up and done, and results in frame changes.

After much fenagling, I randomly stumbled upon [this reddit post](https://www.reddit.com/r/godot/comments/13fgdek/shader_only_8_directional_billboarding/)
which had a much better way to calculate rotations. While it still needed some work to finish, it was crucial in fixing the incorrent frame switching issue.

Some sample sprites:
- https://www.spriters-resource.com/fullview/27877/
- https://www.doomworld.com/forum/topic/73426-share-your-sprites/?page=75


For 2D: https://thebookofshaders.com/08/

Source of 2D light
https://docs.godotengine.org/en/stable/tutorials/2d/2d_lights_and_shadows.html

See the paragraph after [this](https://docs.godotengine.org/en/stable/tutorials/2d/2d_lights_and_shadows.html#id4) image.

## Icons
Icons were originally made with [Graphite](https://editor.graphite.rs/), but moved to Inkscape. Read [Creating Icons](https://docs.godotengine.org/en/latest/contributing/development/editor/creating_icons.html) for info on how to add icons to custom node types.

Foc custom node icons, used the existing icons:
- [Sprite3D](https://github.com/godotengine/godot/blob/master/editor/icons/Sprite3D.svg)
- [AnimatedSprite3D](https://github.com/godotengine/godot/blob/master/editor/icons/AnimatedSprite3D.svg)
- [Sprite2D](https://github.com/godotengine/godot/blob/master/editor/icons/Sprite2D.svg)
- [AnimatedSprite2D](https://github.com/godotengine/godot/blob/master/editor/icons/AnimatedSprite2D.svg)


Then added parts of [DirectionalLight3D](https://github.com/godotengine/godot/blob/master/editor/icons/DirectionalLight3D.svg).
