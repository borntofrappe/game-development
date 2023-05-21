# Breakout 3

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Quads

The instructions to create the quads mirror those included for the paddle, but are repeated to rehearse the topic.

In `main.lua`, the goal is to populate the `gFrames` table with tables of quads.

```lua
gFrames = {
  ['paddles'] = GenerateQuadsPaddles(gTextures['breakout'])
}
```

For the paddles, but also balls — and later for bricks.

```lua
gFrames = {
  ['paddles'] = GenerateQuadsPaddles(gTextures['breakout']),
  ['balls'] = GenerateQuadsBalls(gTextures['breakout'])
}
```

This function is created in `Utils.lua`, similarly to the previous `GenerateQuadsPaddles`:

- look at `breakout.png`

- populate a table with as many rectangles as necessary

For the balls, the idea is to consider two rows of (8x8) squares, starting at the point (96, 48) and considering four columns each.

```lua
function GenerateQuadsBalls(atlas)
  x = 96
  y = 48

  local counter = 1
  local quads = {}

  for i = 0, 1 do
    for j = 0, 3 do
      quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
      counter = counter + 1
      x = x + 8
    end
    x = 96
    y = y + 8
  end
end
```

From this structure however, it is necessary to skip the last item.

```lua
function GenerateQuadsBalls(atlas)
  -- rows

  return table.slice(quads, 1, #quads - 1)
end
```

This is because the second row has actually three balls instead of four.

With this setup, the `render` function for the ball can use whichever color by accessing the matching table.

```lua
function Ball:render()
  love.graphics.draw(gTextures['breakout'], gFrames['balls'][self.color], self.x, self.y)
end
```

## Movement

The ball is made to move in both the `x` and `y` dimensions, similarly to the puck in the game Pong.

When checking for a collision, remember a couple of things:

1. modify the coordinate of the ball to ensure that the condition doesn't return `true` twice in a row

   Instead of just flipping the `dx` variable, for instance

   ```lua
   if self.x <= 0 then
     self.dx = self.dx * -1
   end
   ```

   Set `x` to make sure that in the iteration which follows the ball cannot touch the same threshold.

   ```lua
   if self.x <= 0 then
     self.x = 0
     self.dx = self.dx * -1
   end
   ```

2. when checking for a collision with the paddle, perform an AABB test evaluating when the ball _cannot_ overlap with the paddle.

   Perform the test considering the coordinates and dimensions of the ball against the same values for the paddle.

It is also necessary to modify the data passed to and from the pause state, to ensure that the game remembers not only where the paddle was, but the ball as well.
