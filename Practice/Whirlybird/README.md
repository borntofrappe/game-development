# Whirlybird

Recreate the pixelated game available in the "Play Games" application developed by Google.

![Whirlybird in a few frames](https://github.com/borntofrappe/game-development/blob/main/Practice/Whirlybird/whirlybird.gif)

## Resources

The `res` folder includes the font and audio files initialized in `love.load`. In the `graphics` sub-folder you also find the spritesheet used to generate the game assets. `Utils.lua` provides the function necessary to section the images and produce the necessary quads.

There are actually two images, as I later developed the game over screen to include a sprite-based animation and additional visuals.

## Input

The game supports both keyboard and mouse input. With a keyboard it is possible to move between states by pressing either the <i>enter</i> or <i>escape</i> key, to move the player with the right and left arrow keys. With touch the game moves forward by pressing the areas dedicated to the start button and replay buttons, while the player slides left or right by pressing the left or right half of the screen.

## Frames

Many of the game assets cycle through a series of frames, from the falling or flying player to the different platforms, to even the particles. The naive approach is to have a `timer` variable keep track of the passing of time and through delta time.

```lua
self.timer = self.timer + dt
```

When the value crosses an arbitrary threshold, the counter variable keeping track of the current frame is incremented.

## Player

The player has three possible types, or states, depending on the actual gameplay. `Player:change` is defined to receive a state and update the visual accordingly. Notice that in the different states the visual describing the player changes in width or even height. To make sure the graphic doesn't stutter, the `x` and `y` coordinates are updated to ensure that the player is centered.

The different height is particularly relevant when moving between the play and falling state. In this instance, when considering the lower threshold, it is helpful to refer to the height of the player.

```lua
self.scrollY = LOWER_THRESHOLD - self.player.y - self.player.height
```

Considering a hard-coded measure would have the player shift abruptly downwards. It is a matter of a couple of pixels, but enough to be noticeable.

## Interactables

`Interactables` populates a table to ensure a certain number of objects, and specifically ensure that every other object is picked from the `INTERACTABLE_SAFE` table. In this manner, it should be possible to avoid a situation in which the player cannot feasibly continue.

The interactables themselves include a series of conditional to animate the visual in a loop, animate the graphic following interaction with the player, or again move horizontally. I am not particularly proud of this approach, and a future update will hopefully address this convoluted structure, perhaps considering dedicated classes which inherit from a base class.
