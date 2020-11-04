# Minesweeper

The goal is to create the game minesweeper with Lua and Love2D.

The project takes inspiration from [a coding challenge](https://thecodingtrain.com/CodingChallenges/071-minesweeper.html) published on the [coding train website](https://thecodingtrain.com/). The challenge explains the game in the context of Processing.

In terms of UI, the idea is to replcate the style of the game Minesweeper built-in the android application "Google Play Games".

## Cell

The table `Cell` is responsible for rendering every possible version of a cell:

- by default, show a green rectangle, alternating between a light and dark variant to differentiate between successive tiles

- when a cell is revealed, show one of three possible variants

  - a mine if the cell has indeed a mine

  - a number detailing the number of surrounding mines

  - nothing if the number of surrounding mines in zero

_Update_: as the game allows to flag a cell with a marker, the cell renders the raster image behind `flag.png` above the default, green variant.

## Grid

The `Grid` table is responsible for most of the gameplay. It is initialized with `columns` and `rows`, and sets up a table of cells.

```lua
local cells = {}
for column = 1, def.columns do
  cells[column] = {}
  for row = 1, def.rows do
    local def = {
      ["column"] = column,
      ["row"] = row,
      ["isEven"] = (column + row) % 2 == 0
    }
    cells[column][row] = Cell:new(def)
  end
end
```

`isEven` is used to alternate between the color of successive cells.

From this structure, the `render` function renders every cell by looping through the 2D table.

```lua
function Grid:render()
  for i, column in ipairs(self.cells) do
    for j, cell in ipairs(column) do
      cell:render()
    end
  end
end
```

This takes care of the aesthetics, while additional functions consider the dynamics of a minesweeper game:

- `addMines` sets up a `while` loop to add the mines

  ```lua
  function Grid:addMines()
    local mines = 10
    while mines > 0 do
      -- add mines
      -- be sure to have mines reach 0
    end
  end
  ```

  The idea is to use `math.random` to detail a specific cell, and reduce the counter variable `mines` only if the cell doesn't already have a mine.

  ```lua
  local column = math.random(self.columns)
  local row = math.random(self.rows)
  local cell = self.cells[column][row]
  if not cell.hasMine then
    cell.hasMine = true
    mines = mines - 1
  end
  ```

- `addHints` loops through the grid to consider the number of mines in available neighboring cells.

  ```lua
  for i, column in ipairs(self.cells) do
      for j, cell in ipairs(column) do
    end
  end
  ```

  A number is only useful if the cell doesn't have a mine, so it necessary to add a fitting `if` statement.

  ```lua
  if not cell.hasMine then
  end
  ```

  To consider the neighbors in the grid, the idea is to then set up a loop from the previous to the next column, from the previous to the next row.

  ```lua
  local c1 = math.max(1, column - 1)
  local c2 = math.min(self.columns, column + 1)
  local r1 = math.max(1, row - 1)
  local r2 = math.min(self.rows, row + 1)
  ```

  `math.min` and `math.max` are useful to consider only the available columns and rows.

  Based on the four values, the for loop increments a counter variable if the cell in question has a mine.

  ```lua
  for c = c1, c2 do
    for r = r1, r2 do
      if self.cells[c][r].hasMine then
        neighborsWithMine = neighborsWithMine + 1
      end
    end
  end
  ```

  Finally, the counter variable is added to a field of the `cell` table, to have the value rendered as the cell is eventually revealed.

  ```lua
  cell.neighborsWithMine = neighborsWithMine
  ```

- `reveal` receives a column and row, in order to reveal the specific cell

  ```lua
  local cell = self.cells[column][row]
  ```

  The function is called when the player selects a cell that does not contain a mine, but it is still necessary to check the boolean. This because, in the moment the cell doesn't have neighboring mines, the `reveal` function calls itself to reveal the surrounding cells.

  ```lua
  if not cell.isRevealed and not cell.hasMine then

  end
  ```

  _Update_: consider also if the cell has been flagged. In this instance, the idea is to avoid accidental reveal.

  ```lua
  if not cell.isRevealed and not cell.hasMine and not cell.isFlagged then

  end
  ```

  Following this checkup, the idea is to immediately reveal the cell.

  ```lua
  cell.isRevealed = true
  ```

  If there are no mines surrounding the cell, the idea is to finally set up a loop, similar to the one introduced in the `addHints` function, and reveal the neighbors as well.

  ```lua
  for c = c1, c2 do
    for r = r1, r2 do
      self:reveal(c, r)
    end
  end
  ```

  The conditional checking that the cell is not revealed, doesn't have a mine and is not flagged ensures that only the desired neighbors are revealed.

- `revealAll` describes a much more simpler set of instructions. The idea is to here loop through the grid and reveal each cell.

  ```lua
  for i, column in ipairs(self.cells) do
    for j, cell in ipairs(column) do
      cell.isRevealed = true
    end
  end
  ```

  _Update_: as the game allows to flag a cell, it's also necessary to remove said flag to reveal the entire grid.

  ```lua
  cell.isFlagged = false
  cell.isRevealed = true
  ```

- `flag` receives a specific column and row, to flag the selected cell.

  ```lua
  cell.isFlagged = true
  ```

  Adding a flag is however possible only on cells that haven't been revealed yet.

  ```lua
  if not cell.isRevealed then
    cell.isFlagged = true
  end
  ```

  Moreover, adding a flag by assigning a `true` boolean preculdes the game from removing the flag. In light of this, I decided to have the function toggle the booelan.

  ```lua
  if not cell.isRevealed then
    cell.isFlagged = not cell.isFlagged
  end
  ```

  By selecting a flagged cell, the game removes the marker.

## main

The entry point of the application set up the game window and a grid.

```lua
function love.load()
  grid = Grid:new()
  grid:addMines()
  grid:addHints()
end
```

In terms of gameplay, the script considers player input in `love.mousepressed` function. `love.load` introduces additional booleans to manage the state of the game (`isPlaying`, `isGameOver`, `isAddingFlags`), but here I choose to focus on the interaction following a click in the grid.

The idea is to find the column and row of the selected cell. This is achieved with a `pointToCell` function.

```lua
local column, row = pointToCell(x, y)
```

The function is set up to return `false` if the mouse is pressed outside of the grid, and otherwise returns the two integers. Based on these two values, the idea is to check if the cell has a mine. If there is a mine, the grid is completely revealed.

```lua
if grid.cells[column][row].hasMine then
  grid:revealAll()
end
```

If the cell doesn't contain a mine, only the specific unit is revealed.

```lua
else
  grid:reveal(column, row)
end
```
