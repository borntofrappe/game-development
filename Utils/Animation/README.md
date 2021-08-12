# Animation

[CS50's Intro to Game Development](https://www.youtube.com/playlist?list=PLWKjhJtqVAbluXJKKbCIb4xd7fcRkpzoz) introduces a small library to manage frame by frame animation. The goal of this folder is to try and replicate the library with my own code.

## Notes

The library is created by the lecturer and it consists of a class with three methods:

- `init` initializes a series of variables to keep track of the passing of time. It also considers an input table, `def`, to detail the frames being looped through and the interval at which to change the individual frame

- `update` considers `dt` to rapidly loop through the table of frames

- `getCurrentFrame` works more as a utility function, to provide the frame currently in use

To use the library, you need to:

1. define the animation(s)

   ```lua
   idleAnimation =
    Animation(
    {
      frames = {1},
      interval = 1
    }
   )

   movingAnimation =
    Animation(
    {
      frames = {10, 11},
      interval = 0.2
    }
   )
   ```

   The class `Animation` allows to rapidly loop through the frames described in the table bearing the same name.

   In the demo, an additional variable `currentAnimation` allows to keep track of one of the two. By default this refers to the idle animation, but when pressing the arrow keys, it's updated with the moving alternative.

2. update the animation

   ```lua
   currentAnimation:update(dt)
   ```

With these two steps, the animation keeps looping through `self.frames`, and updates `self.currentFrame` to match. Through `getCurrentFrame` you can finally retrieve this value and use it to render the appropriate sprite.

```lua
gFrames["character"][currentAnimation:getCurrentFrame()],
```

## Demo

`main.lua` demos the library consider two basic animations. `spritesheet.png` provides the images divvied up in quads.
