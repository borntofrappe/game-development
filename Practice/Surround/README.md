# Surround

A game for two players, where each player fills the white background with a distinct color, and the game ends as one of the two sides collides with a trail or exits the world.

## Canvas

[LOVE2D](https://love2d.org/wiki/Canvas) introduces the canvas as a way to render elements which do not change frequently, with the idea of reducing the number of drawing operations. In the final game, this is not actually why the canvas is used, but to get started, it is useful to create a demo showcasing the more "static" usefulness.

### Static

The demo illustrates how to initialize, set up and ultimately draw a canvas with a checkered pattern. To a smaller degree, the project is also useful to demonstrate how transparency values are affected by the blend mode set through `love.graphics.setBlendMode`.

`main.lua` populates a table with a series of cells. `Cell.lua` is defined to receive the coordinates, dimensions and color for a given cell, and render a square through the `love.graphics.rectangle` function.

Past this this setup phase, the idea is to include a canvas in the variable created locally.

```lua

```

In `love.load`:

- initialize a canvas with `love.graphics.newCanvas`

  ```lua
  canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
  ```

- set up the current canvas with `love.graphics.setCanvas`, passing as input the newly initialized object

  ```lua
  love.graphics.setCanvas(canvas)
  ```

- describe what to draw in the canvas

  ```lua
  for k, cell in pairs(cells) do
    cell:render()
  end
  ```

- stop the scope of the current canvas calling again `love.graphics.setCanvas`, this time without arguments

  ```lua
  love.graphics.setCanvas()
  ```

The instructions in `love.load` are enough to create a canvas with the checkered pattern. To actually draw the canvas, it is finally possible to use the `love.graphics.draw` function in `love.draw`.

```lua
function love.draw()
  love.graphics.draw(canvas)
end
```

Notice that the demo actually draws two instance of the canvas, side by side. This should also explain why the constant for the width of the canvas is computed as half the width of the window. The two instances highlight the purpose of the blend mode.

```lua
love.graphics.setBlendMode("alpha", "premultiplied")
-- canvas

love.graphics.setBlendMode("alpha")
-- canvas
```

In `love.draw` also notice how the first line resets the color.

```lua
love.graphics.setColor(1, 1, 1, 1)
```

Without this instruction it seems that the demo shows more washed out, transparent, colors.
