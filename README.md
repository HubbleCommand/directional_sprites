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
