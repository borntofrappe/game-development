# Character 3

## Spritesheet

From `character.png`, the idea is to use the tenth and eleventh sprites in rapid succession. The two sprites allow to animate the character as it moves rightwards, but through the additional arguments of `love.graphics.draw` it's possible to flip the visual to also consider the opposite direction.

## Animation

The lecturer introduces `Animation.lua` as a small library to loop through a series of input frames.

`Animation` is defined with three methods:

- `init` initializes a series of variables to keep track of the passing of time. It also considers an input table, `def`, to detail the frames being looped through and the interval at which to change the individual frame

- `update` considers `dt` to rapidly loop through the table of frames

- `getCurrentFrame` returns the current frame

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

## Scale

As mentioned in the opening section, to animate the sprite in the opposite direction use the additional arguments provided by `love.graphics.draw`

```lua
love.graphics.draw(
  image,
  quad,
  x,
  y,
  rotation,
  scaleX
)
```

This works, but the flip occurs from the top left corner. In light of this, it's necessary to modify the `x` coordinate and to offset the sprite by the character's width. This explains the purpose of the variable `direction`.

```lua
love.graphics.draw(
  image,
  quad,
  -- x
  direction == "right" and math.floor(characterX) or math.floor(characterX + CHARACTER_WIDTH),
  y,
  rotation,
  -- scale
  direction == "right" and 1 or -1,
)
```