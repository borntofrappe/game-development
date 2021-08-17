# Minesweeper

[The Coding Train](https://youtu.be/LFU5ZlrR21E) explains the game's logic of the game Minesweeper with the p5.js library. Here I try to take the lessons learned in the video and implement the game with Lua, Love2D, touch controls, and the UI of Minesweeper from the android application _Google Play Games_.

![Minesweeper in a few frames](https://github.com/borntofrappe/game-development/blob/master/Practice/Minesweeper/minesweeper.gif)

## Dimensions

Starting from the number of columns, rows and an arbitrary measure for the size of the individual cell, `constants.lua` defines the size of the actual window.

```lua
COLUMNS = 7
ROWS = 11

CELL_SIZE = 50
```

Additional, arbitrary values are defined for the padding around the grid and the height of the menu.

```lua
PADDING_X = 28
PADDING_Y = 24

MENU_HEIGHT = 52
```

## Cell

The appearance of a cell depends both on the style chosen for the project — the alternating color palette — and the state of the game — whether the cell is revealed, has a mine, has neighboring mines, and whether is it flagged as well. In light of this, `Cell:render()` includes several conditional, ensuring that:

- a non-revealed cell is rendered with a green rectangle,light or dark depending on the pattern in the grid

- a non-revealed, flagged cell adds a flag

- a revealed cell with a mine displays a red rectangle with a dark, centered circle

- a revealed cell without a mine shows a beige rectangle, once more in a light or dark variant

- a revealed, mineless cell with neighboring mines hihglights the number of affected neighbors as well

The `:render` function is rather convoluted, but it is at the core of the cell class. The game indeed handles the functionality around the cell from `Grid.lua`.

## Grid

### Initialization

The grid class populates a two dimensional table with a series of cells. To alternate between light and dark versions, the nested loop considers whether the sum of column and row is even.

```lua
["isDark"] = (column + row) % 2 == 0,
```

To determine if the cell has a mine, the same loop considers whether a different table has a key matching the specific coordinates.

```lua
["hasMine"] = minesCoords["c" .. column .. "r" .. row]
```

`mineCoords` helps to create a table with unique columns and rows. The idea is to continuously pick coordinates at random, populate the table and decrement a counting variable.

```lua
local column = math.random(COLUMNS)
local row = math.random(ROWS)

if not minesCoords["c" .. column .. "r" .. row] then
  minesCoords["c" .. column .. "r" .. row] = true
  mines = mines - 1
end
```

The `reapeat ... until` loop helps to ensure that operation is repeated until the table describes ten keys.

```lua
repeat
  -- pick column and row
until mines == 0
```

Past the nested loop, the table describes a series of instances of the `Cell` class. It is here necessary to add the hints for the number of neighboring mines with an additional loop. The idea is to modify the `neighboringMines` field for the cell that do not have a mine.

```lua
if not cells[column][row].hasMine then
  -- consider neighbors
end
```

To consider the neighbors, four variables help to describe the preceding and following column and row.

```lua
local c1 = math.max(1, column - 1)
local c2 = math.min(COLUMNS, column + 1)
local r1 = math.max(1, row - 1)
local r2 = math.min(ROWS, row + 1)
```

`math.min` and `math.max` help to constrain the cells to the existing columns and rows.

`neighboringMines` is initialized at `0` and incremented for each neighbor with a mine.

### reveal

`Grid:reveal` is defined to receive a specific column and row and reveal the corresponding cell. That being said, is is necessary to consider the state of the cell.

Here's the flow of the function:

- check that cell has not already been revealed or has been flagged

- reveal the individual cell

- if the cell has a mine, call a function to clear the entire grid

  ```lua
  if self.cells[column][row].hasMine then
    self:revealAll()
  else
    -- ...
  end
  ```

  The function loops through the grid and updates the boolean of every single cell.

  Past this function I've also decided to return `true`, as a signal for the invoking function that the game should be over.

  ```lua
  self:revealAll()

  return true
  ```

- if the cell doesn't have neighboring mines, loop through the neighbors and reveal the cells. With a recursive call to `Grid:reveal`, the neighbors are updated until the cell is found to have adjacent mines

  The function is prevented from running indefinitely thanks to the first `if` statement, checking whether the called cell has been revealed, or whether the same entity has been flagged.

  ```lua
  if not self.cells[column][row].isRevealed and not self.cells[column][row].isFlagged then

  end
  ```

### toggleFlag

The single purpose of `Grid:toggleFlag` is to toggle the boolean describing if the chosen cell has been flagged.

```lua
function Grid:toggleFlag(column, row)
  self.cells[column][row].isFlagged = not self.cells[column][row].isFlagged
end
```

A cell that has been revealed has no point in being flagged. This is why the toggle operation is precluded with an `if` statement.

```lua
if not self.cells[column][row].isRevealed then
  -- flag
end
```

## main

With the cell and grid class, the entry point of the application `main.js` needs to consider a click and the coordinates of the mouse cursor. This is achieved in the body of the `love.mousepressed` function.

```lua
function love.mousepressed(x, y, button)
end
```

After checking that the `x` and `y` coordinates fall inside of the grid, it is possible to compute the column and row considering the cell size.

```lua
local column = math.floor((x - PADDING_X) / CELL_SIZE) + 1
local row = math.floor((y - PADDING_Y - MENU_HEIGHT) / CELL_SIZE) + 1
```

`PADDING_X`,`PADDING_Y`, and `MENU_HEIGHT` describe the area around the grid.

Knowing the two values, then, it is possible to reveal the dedicated cell, leaning on the `:reveal` function detailed in the previous section.

```lua
grid:reveal(column, row)
```

### State

State is managed with a string, holding one of two possible values in `playing` and `gameover`.

```lua
local state = "playing"
```

The variable is assigned an initial value of `playing`, and the idea is to move to `gameover` immediately after revealing a mine. The `:reveal` function as documented in the previous section returns `true` for this instance.

```lua
local hasMine = grid:reveal(column, row)
if hasMine then
  state = "gameover"
end
```

When a click is then registered, at all, the script moves back to the `playing` value.

```lua
if state == "playing" then
  -- column, row
elseif state == "gameover" then
  state = "playing"
end
```

The grid is also re-initialized, spawning a new series of cells.

```lua
grid = Grid:new()
```

## Menu

The cell and grid class are all that is necessary for a functional minesweeper demo. With the menu, the idea is to provide two additional features:

1. a way to keep track of time as the grid is being cleared

2. a way to flag cells

For the first feature the menu updates a counter variable and displays the value as an integer through the string library. Consider for this the utility function in `Utils.lua`

```lua
string.format("%03d", time)(0) -- 000
```

For the second feature, the same class initializes a boolean variable to decide whether a click in the grid should add a flag or reveal a cell.

```lua
["isFlagSelected"] = false,
```

The value is updated from `main.lua`, but already in `Menu.lua` it is used to highlight the flag icon. Notice that in main, I decided to toggle the flagging feature when the click is registered on the menu, regardless of the horizontal coordinate.

```lua
if y < MENU_HEIGHT then
  menu.isFlagSelected = not menu.isFlagSelected
end
```

A more refined approach would consider the actual position and dimensions of the icon describing the flag.

```lua
if menu.isFlagSelected then
  grid:toggleFlag(column, row)
else
 grid:reveal(column, row)
end
```

Thankfully, having a controlling variable from the instance of the menu class is enough to control the functionality in the `mousepressed` function. The grid and cell class are already equipped to add a flag and make sure that flagged cells are not revealed — not on click, not when recursively clearing the grid.
