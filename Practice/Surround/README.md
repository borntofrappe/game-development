# Surround

A game for two players and in split screen. Each side fills the white background with a distinct color and the game ends as one of the two sides collides with a trail or exits the world.

![Surround in a few frames](https://github.com/borntofrappe/game-development/blob/master/Practice/Surround/surround.gif)

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

### Dynamic

The demo shows how it is possible to show the same entity from the perspective of two different players, each focused on half of the existing window.

In the code, the idea is to immediately initializes a cell, somewhere in the window.

```lua
function Cell:new()
  local this = {
    ["x"] = love.math.random(WINDOW_WIDTH),
    ["y"] = love.math.random(WINDOW_HEIGHT),
  }
  -- oop
end
```

When creating the two canvases, then, the idea is to have each canvas half as wide as the window, and translate the second object to the right portion.

```lua
for i, canvas in ipairs(canvases) do
  -- canvas, x
  love.graphics.draw(canvas, (i - 1) * CANVAS_WIDTH)
end
```

The `getCanvases` function is defined to produce the necessary objects. It receives as argument the cell to-be-rendered and a table describing the translations.

```lua
function getCanvases(cell, translations)
end
```

These translations are meant to make sure that the rectangle appears in one of the two frames.

```lua
local translations = {
  {["x"] = 0, ["y"] = 0},
  {["x"] = -CANVAS_WIDTH, ["y"] = 0}
}
```

For each translation, `getCanvases` proceeds to create and set a canvas.

```lua
local canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
love.graphics.setCanvas(canvas)

-- draw here

love.graphics.setCanvas()
```

Before drawing the cell, then, the function translates the perspective considering the input offset values. Notice the `push` and `pop` function, to make sure that the translation does not persist past the canvas.

```lua
love.graphics.push()

love.graphics.translate(translation.x, translation.y)
cell:render()

love.graphics.pop()
```

This setup works, but is ultimately static, and doesn't demonstrate how the two halves are effectively rendering each their own version of the world. To highlight this feat, the `translation` table is updated through the arrow or `wasd` keys, each affecting a separate half. Every time the table is updated, finally, the canvases reconsider the changing environment.

```lua
cell = Cell:new()
canvases = getCanvases(cell, translations)
```

The same holds true every time you update the cell. It is here necessary to create a new version of the canvas.
