# Game of Life

The goal of this demo is to set up a grid in which to recreate a version of [_Conway's Game of life_](https://en.wikipedia.org/wiki/Game_of_life).

## Preface

On CodePen, I already experimented with the simulation [using the React framework](https://codepen.io/borntofrappe/pen/xxbKgMQ). The pen is also responsible for the UI of this Love2D demo.

In detail, the project is more of an experiment than a game, but it does provide a modicum of interaction, by pressing buttons or again a cell in the grid.

The project is also simple enough to experiment with how Love2D sets up the gaming window. The goal is to consider the entirety of the window's width and height, and scale the grid/buttons accordingly.

## Step

The essence of the simulation is detailed in the `step()` function. Here, the idea is to loop through the grid twice, to:

1. count the number of alive neighbors

   To this end, the script sets up a loop similar to that introduced in the game `Minesweeper`, from one column, from one row before the current one to one column, one row past the same reference.

   ```lua
   local c1 = math.max(1, column - 1)
   local c2 = math.min(self.columns, column + 1)
   local r1 = math.max(1, row - 1)
   local r2 = math.min(self.rows, row + 1)
    for c = c1, c2 do
        for r = r1, r2 do
            -- count neighbors
        end
    end
   ```

   `math.min` and `math.max` allow to consider an existing row and column. Notice that this means that the edges are considered as hard boundaries, and a cell on the first column doesn't consider a neighbor in the last column.

2. modify the grid on the basis of the rules behind the game of live itself

The rules specifically dictate that:

- a cell dies if there are less than two or more than three neighbors

  ```lua
  if isAlive and (aliveNeighbors < 2 or aliveNeighbors > 3) then
      self.cells[column][row].isAlive = false
  end
  ```

- a cell is born if there are exactly three neighbors

  ```lua
  if not isAlive and aliveNeighbors == 3 then
      self.cells[column][row].isAlive = true
  end
  ```

## Fullscreen

_Please note_: this is a first attempt at considering a window of varying dimensions. It is therefore primed for improvements.

To have the game stretch fullscreen, the docs suggest using [`love.graphics.setMode`](https://love2d.org/wiki/love.window.setMode) with a value of `0` for the width or height.

```lua
function love.load()
    love.window.setMode(0, 0)
end
```

[`love.graphics.getDimensions`](https://love2d.org/wiki/love.graphics.getDimensions) allows to then find the value for both dimensions.

```lua
function love.load()
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
end
```

Based on this setup, the idea is to then scale the game's element, from the size of the font to the size of the grid, buttons.

For the font size for instance, this one considers the minimum between width and height, scaled by an arbitrary value.

```lua
local fontSize = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 40)
```

For the dimensions of the grid, the logic is a tad more complex. The goal is to consider the width and height of the window.

```lua
local gridWidth = math.floor(WINDOW_WIDTH / 1.5)
local gridHeight = math.floor(WINDOW_HEIGHT / 1.5)
```

However, the greater between the two values is scaled to guarantee that the grid is composed by squared cells.

```lua
if gridWidth > gridHeight then
  gridWidth = gridHeight * COLUMNS / ROWS
else
  gridHeight = gridWidth * ROWS / COLUMNS
end
```

This ensures that the grid fits in the window, and again that the cells are represented by squares.

For the buttons, finally, the script uses `font:getHeight()` and `font:getWidth(text)` so that the text is safely nested in a rounded rectangle. The rectangle's height is proportional to the font size.

```lua
local buttonHeight = font:getHeight() * 2.5
```

The width is however proportional to the width occupied by the longest string. This explains the loop iterating through the text of the different options.

```lua
local buttonWidth = 0

for i, action in ipairs(actions) do
  local width = font:getWidth(action.text) * 1.25
  if width > buttonWidth then
    buttonWidth = width
  end
end
```

This is a stylistic choice to have the buttons aligned one above the other.

## Layout

Similarly to the dimensions, the layout changes according to the available width and height. Here, the idea is to have the grid and the buttons positioned side by side, but only when the width is the greater of the two measures. If the height exceeds the width, the idea is to instead position the grid above the buttons.

These choices are implemented by modifying the `x` and `y` coordinate of the grid and buttons. For isntance and for the grid, `offsetGrid` has the grid end at half the width, and vertically centered.

```lua
local offsetGrid = {
    ["x"] = WINDOW_WIDTH / 2 - gridWidth,
    ["y"] = WINDOW_HEIGHT / 2 - gridHeight / 2
}
```

The width and height of the grid are necessary to consider the coordinate system of love2D, whereby the grid is drawn from the top left corner.

If the height exceeds the width then, the values are modified to have the grid horizontally centered, and ending at half the available height.

```lua
if WINDOW_HEIGHT > WINDOW_WIDTH then
  offsetGrid.x = WINDOW_WIDTH / 2 - gridWidth / 2
  offsetGrid.y = WINDOW_HEIGHT / 2 - gridHeight
end
```

## GUI

Picking up from the concept first introduced in `08 Pokemon`, the script uses a `Button` and `Panel` class. The idea is to have the panel render the outline of a rectangle, and have the button render a string of text above a panel.

The two are styled differently depending on whether or not the mouse hovers on the elements, but here I want to higlight the `callback` field. The goal is to have the buttons receive a function; for instance and for the button toggling the animation.

```lua
["callback"] = function()
  isAnimating = not isAnimating
end
```

In this manner, when a button is later selected, it is no longer necessary to consider which button is selected. All that is necessary is that the button executes the code described by the callback function.

```lua
if pressed then
    button.callback()
    break
end
```

_Please note_: to check if a button is pressed, the game actually evaluates the coordinates of the mouse against the coordinates of the button.
