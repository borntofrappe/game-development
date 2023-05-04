# Tetris

Recreate Tetris inspired by the Game Boy version.

![Tetris in a few frames](https://github.com/borntofrappe/game-development/blob/main/Practice/Tetris/tetris.gif)

## Resources

The `res` folder includes the `push` library to scale the window while maintaining a pixelated look, the same font used in `00 Pong`, once again to establish a retro look, and `spritesheet.png`, to describe the appearance of the bricks. The first row describes 5 types of bricks, plus one for the gameover screen and one for the columns describing the border of the playing area. The second row details the color palette.

## Constants

`constants.lua` describes the dimensions of the game in terms of columns and rows. Ultimately, the idea is to use these values and `CELL_SIZE` to obtain the actual coordinates for the window.

```lua
VIRTUAL_WIDTH = CELL_SIZE * COLUMNS
VIRTUAL_HEIGHT = CELL_SIZE * ROWS
```

It is important to note a key difference between the two axis. The number of columns is obtained by tallying the number of columns devoted to different parts of the UI: the whitespace surrounding the elements, the border surrounding the grid, the grid itself, the section devoted to the game's data.

```lua
COLUMNS_WHITESPACE = 1
COLUMNS_BORDER = 1
COLUMNS_GRID = 10
COLUMNS_GAMEDATA = 6

COLUMNS = COLUMNS_WHITESPACE * 3 + COLUMNS_BORDER * 2 + COLUMNS_GRID + COLUMNS_GAMEDATA
```

The number of rows is instead fixed ahead of time, to match the rows of the grid.

```lua
ROWS_GRID = 18
ROWS = ROWS_GRID
```

Additional constants describe how to divide the vertical space for the game's data.

```lua
ROWS_WHITESPACE = 0.5
ROWS_NEXT_TETROMINO = 6
ROWS_DATA = ROWS_GRID - ROWS_NEXT_TETROMINO - ROWS_WHITESPACE * 3
```

In `Gamedata.lua`, the values are picked up to divide the area between the metrics — score, level, lines — and the upcoming tetromino. The approach is less than ideal, but

## Game data

Instead of commenting on the way the space is divided for the three key metrics and the tetrimino, I want to note the purpose of `Box.lua`. The class is defined to provide a container for the game's data, and its only job is to render a rectangle with slightly rounded corners and a small inner stroke.

## Bricks

The `Brick` class renders a single brick considering a specific column, row and frame.

```lua
function Brick:new(column, row, frame)
end
```

The frame is used to access a specific quad in the `gFrames` table, created from the spritesheet by dividing the image in 8\*8 rectangles.

```lua
function Brick:render()
  love.graphics.draw(
    gTexture,
    gFrames[self.frame],
    --...
    )
end
```

The column and row are multiplied by the size of the cell, but the values are decremented by `1`

```lua
function Brick:render()
  love.graphics.draw(
    -- ...,
    (self.column - 1) * CELL_SIZE,
    (self.row - 1) * CELL_SIZE
    )
end
```

This is because in the script I decided to keep the lua convention of enumerating variables starting from `1` instead of `0`. The grid, for instance, positions bricks in columns starting from `1` and ending at `10`, inclusive.

## Tetromino

The key variables are `CONFIGS`, `FRAMES` and, to a smaller extent, `OFFSET_CENTER`.

`CONFIGS` describes the seven possible types of tetrominos in all possible configurations. This means one table for each rotation.

```lua
{
  {-1, 0},
  {0, 0},
  {1, 0},
  {0, 1}
},
```

The idea is to ultimately spawn one brick for each set of coordinates and from a point of reference. In the snippet's example, the first set describe a bricks one column before, on the same row.

`FRAMES` describes how to assign a specific frame to the different tetrominos.

```lua
local FRAMES = {
  {1},
  {2},
  {3, 4},
  {5, 6},
  {7}
}
```

The idea is to here use the index to pick the specific quad, and use the one value in the matching table to pick a specific configuration.

`OFFSET_CENTER` finally describes how much to shift the column and row for the tetromino to centered in the section devoted to the game's data.

In terms of movement, the tetromino moves by shifting the column and row of every brick. On top of this, the class updates two additional values in `column` and `row`.

```lua
local this {
  ["column"] = columnStart,
  ["row"] = rowStart,
}
```

These values are helpful to consider a point of reference for the eventual rotation. In this instance, the idea is to include a new set of bricks starting from the specific coordinates.

```lua
local column = self.column + coords[1]
local row = self.row + coords[2]
```

## Grid

The grid defines two sets of bricks. The first set helps to draw the borders around the playing area, picking specifically from the last quad of the first row.

```lua
for k, brick in pairs(self.border) do
  brick:render()
end
```

The second set describes playing area itself, in columns and rows.

```lua
for k, column in pairs(self.bricks) do
  for l, brick in pairs(column) do
    brick:render()
  end
end
```

Unlike `border`, `bricks` is initially populated with nothing but `nil` values.

```lua
self.bricks[column][row] = nil
```

As the game progresses and the tetromino reach the bottom of the grid, or later collide with existing bricks, the idea is to update the table considering the tetromino's location and appearance.

```lua
for k, brick in pairs(tetromino.bricks) do
  local column = brick.column
  local row = brick.row
  local frame = brick.frame
  self.bricks[column][row] = Brick:new(column, row, frame)
end
```

I want to here highlight the `getClearedLines` and `updateClearedLines` functions. The idea is to first populate a table with the rows of the grid filled with bricks. Based on the value of the rows, the idea is to then empty the rows, and update the bricks of the rows above.

## locals

Tying everything together, `main.lua` defines an instance of the grid, tetromino and game's data.

```lua
local grid = Grid:new()
local tetromino = Tetromino:new()
local gamedata = Gamedata:new()
```

Using a `local` variable helps to make sure that the classes do not rely on global values. For instance and for the tetromino, this helps to ensure that the bricks rotate, move, collide relative to the grid received as input.

```lua
function Tetromino:rotate(grid)
end
```

## Update

To update the game, the idea is to move the tetromino at an interval, but have the interval also decrement as the level increases. Three constants are included for the feature.

```lua
local INTERVAL_START = 0.9
local INTERVAL_MIN = 0.5
local INTERVAL_DECREMENT = 0.1
```

`interval` is initialized to `INTERVAL_START` and every time the level changes, its value decreased by `INTERVAL_DECREMENT`. The decrement is finally limited to `INTERVAL_MIN`.

```lua
interval = math.max(INTERVAL_MIN, interval - INTERVAL_DECREMENT)
```

The game itself is managed by moving the tetromino, following user interaction in the form of arrow keys (or the space key), and automatically considering the interval.

## State

The idea is to manage the state with a string and three possibe values: playing, gameover, waiting.

```lua
local state = "playing"
```

The game starts in the playing state, where the tetrominos are introduced continuously above the grid. As a tetromino overlaps with a brick in the grid, the game moves to the gameover state.

```lua
if tetromino:overlaps(grid) then
  state = "gameover"
end
```

The interval is then used to move to the waiting state and fill the grid with the chosen brick (the sixth in the first row of the spritesheet).

```lua
grid:fillGameoverLines()
tetromino:hide()

state = "waiting"
```

The instance of the tetromino is also hidden to avoid showing the bricks above the complete grid.

## Translate

In `love.draw`, `love.graphics.translate` helps translate the elements to the right.

```lua
love.graphics.translate((COLUMNS_WHITESPACE + COLUMNS_BORDER) * CELL_SIZE, 0)

-- grid and tetromino
```

In this manner the grid and the game's data are able to position the different shapes without considering a starting, offset value.

The function also helps to convey how the translation affects every element which follows. Indeed and to translate the game's data, all that is necessary is to further translate the origin by the width of the grid, border and arbitrary whitespace.

```lua
-- previous translation

love.graphics.translate((COLUMNS_GRID + COLUMNS_BORDER + COLUMNS_WHITESPACE) * CELL_SIZE, 0)

-- game's data
```
