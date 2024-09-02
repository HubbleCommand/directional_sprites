# directional_sprites
n-directional sprites in 2D and 3D, for Godot 4.x

![3d demo](https://github.com/HubbleCommand/directional_sprites/blob/main/media/demo3d.gif)

Make sure all of your animations and frames have the same orientation and number of directions.


## Scripts
Some helper python scripts for making sprite sheets.

`build_sprite_sheet.py` generates a single image with sprite sheet frames.

`convert_col.py` converts one color to another in a batch operation. Useful for making backgrounds transparent.

## 3D : (Animated) Directional Sprite 3D

In all cases, make sure you have enabled Shadows on your light nodes.

## Directional Sprite 3D

## Animated Directional Sprite 3D

## 2D : (Animated) Directional Sprite 2D
While directional sprites are mostly known in the 3D world from games like [DOOM](https://en.wikipedia.org/wiki/Doom_(1993_video_game)) and [Wolfenstein 3D](https://en.wikipedia.org/wiki/Wolfenstein_3D), directional sprites are also prevailant in 2D games like [RimWorld](https://rimworldgame.com/).

As with 3D, two new 2D nodes are added: DirectionalSprite2D and AnimatedDirectionalSprite2D.

2D lighting requires a LightOccluder2D nodes, the Sprites won't generate shadow on their own. In all cases, make sure you have enabled Shadows on your light nodes.

Configuration is simpler, with only the Directions and Orientation properties. The Sprite requires a Texture, while the AnimatedSprite requires a SpriteSheet.

### Directional Sprite 2D

### Animated Directional Sprite 2D

### Lighting and Shadows
While the [official documentation](https://docs.godotengine.org/en/stable/tutorials/2d/2d_lights_and_shadows.html) is a good start, it doesn't provide a complete solution.

In the case of shadows and occluders with sprites, we usually don't want the shadows to self-cast on the sprite itself.
To this end, follow the solution [detailed here](https://github.com/godotengine/godot/issues/74265#issuecomment-1755039506).
Use two `PointLight2D`s, each on a different light layer (the `Item Cull Mask` on `Range` and/or `Shadow`).
One layer should be for the occluders and shadow casting, while the other should just be to light up the sprites.
Check the 2D demo to see it in action.
Note that having the same `PointLight2D` on different `Range` `Item Cull Mask` layers won't work.

Note that in the future (4.4+), Godot may [use z-index for shadow casting](https://github.com/godotengine/godot/pull/93881).
