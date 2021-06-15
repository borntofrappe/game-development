# Breakout 4

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Quads

For the bricks, creating the quads is slightly easier than for the paddles, or the balls. Since the bricks are positioned in order and from the top left corner of `breakout.png`, it's enough to use `GenerateQuads` to split the entire image in (32x16) rectangles, and then return the first `n` quads.

```lua
function GenerateQuadsBricks(atlas)
  return table.slice(GenerateQuads(atlas, 32, 16), 1, 20)
end
```

There are technically 21 bricks one after the other, but I see the 21st as being connected to the brick described on the very right edge of the image, with a key.

## Bricks

Once you have access to the sprites, bricks are included in a two-step process:

- `LevelMaker.lua` creates a table of bricks with a varying `x` and `y` coordinate

- `Brick.lua` initializes and renders the appropriate brick

This layered approach allows to have a dedicated file in which to create the different levels. In a future update, the idea is to create a more challenging gameplay by modifying the structure of the level, but for the current update, all that the `LeverMaker` class does is return a table in which bricks are positioned in rows and columns.

The most tricky bit relates to how the bricks are centered in the viewport width.

```lua
for row = 1, rows do
  for col = 1, cols do
    brick = Brick(
      (col - 1) * 32 + (VIRTUAL_WIDTH - cols * 32) / 2,
      row * 16
    )
    table.insert(bricks, brick)
  end
end
```

In the play state, the table is initialized in the `:init` function, and it's then possible to render the bricks looping through the data structure.

```lua
function PlayState:init()
  -- paddle and ball
  self.bricks = LevelMaker.createMap()
end

function PlayState:render()
  for k, brick in pairs(self.bricks) do
    brick:render()
  end
  -- paddle and ball
end
```

## Collision

`Ball:collides()` is already equipped to detect a collision between the ball and the paddle. The function is however able to detect a collision with a brick as well. With any rectangular shape as a matter of fact.

```diff
-function Ball:collides(paddle)
+function Ball:collides(shape)
```

Once a collision is detected, the way bricks are removed is actually worth mentioning: use a boolean to literally hide the shape.

```lua
function love.update(dt)
  for k, brick in pairs(self.bricks) do
    if self.ball:collides(brick) and brick.inPlay then
      brick.inPlay = false
    end
  end
end
```

The brick class is appropriately updated.

```lua
function Brick:init(x, y)
  -- previous attributes
  self.inPlay = true
end

function Brick:render()
  if self.inPlay then
    love.graphics.draw(gTextures['breakout'], gFrames['bricks'][self.tier + 4 * (self.color - 1)], self.x, self.y)
  end
end
```

You can actually extrapolate the logic in a dedicated function.

```lua
function Brick:hit()
  self.inPlay = false
  gSounds['brick-hit-2']:play()
end
```

And then use the `hit()` function instead of directly modifying the boolean.

_Please note:_ a collision between the ball and a brick doesn't change the movement of the ball. This is covered in the update which follows.
