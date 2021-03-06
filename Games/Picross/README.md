# Picross

Develop the basics of the game picross, a puzzle game in which the player fills a grid based on the instructions given on the side of each row and column. The goal is to ultimately draw a stylized picture based on the pixelated structure.

In the process, I plan to implement the following features:

- keyboard and mouse controls, similarly to _Match Three_

- levels based on data, similarly to _Angry Birds_. The idea is to have a file dedicated to the design of the levels, and have the game develop the grid starting from this design

## Levels

The levels are designed with `x`s and `o`s, using Lua's format for long strings. See `Levels.lua` for a reference.

```lua
[[
  ooxoo
  ooxoo
  xxxxx
  oxxxo
  oxoxo
]]
```

The only issue with this solution comes from the length of the string. You can attest this in the [live environment](https://www.lua.org/cgi-bin/demo) by running the following script:

```lua
level = [[
  ooxoo
  ooxoo
  xxxxx
  oxxxo
  oxoxo
]]

print(level:len()) -- 40
```

The length considers the whitespace and new line characters. This is problematic in the moment you eventually want to compute the number of rows and columns. One fix I found is to use `string.gsub`, and replace every character that is not one of the two accepted literals with an empty string.

```lua
level = [[
  ooxoo
  ooxoo
  xxxxx
  oxxxo
  oxoxo
]]
level = string.gsub(level, "[^xo]", "")
print(level:len()) -- 25
```

The sequence `[xo]` matches the two characters, and the circumflex `^` describes the complement set, meaning anything **but** the two characters.

_Nifty_: you can achieve a similar result using different [patterns](https://www.lua.org/pil/20.2.html). The following are equivalent in this particular context:

- anything that is not a letter

  ```lua
  level = string.gsub(level, "%A", "")
  ```

- space characters

  ```lua
  level = string.gsub(level, "%s", "")
  ```

## Level

The class builds the grid starting from the string introduced in the previous section. From this starting point, the `buildGrid` function populates a table detailing the grid structure.

```lua
function Level:init(n)
  self.grid = {}
  self:buildGrid()
end
```

The grid is built looping through the string, and considering for each index the respective column and row.

```lua
function Level:buildGrid()
  for i = 0, self.levelStringLength - 1 do
    local column = (i % self.gridSide) + 1
    local row = math.floor(i / self.gridSide) + 1
  end
end
```

I use the square root of the length since the levels describe a square matrices of `x`s and `o`s. I use `math.floor` to ensure integer values.

_Please note_: the for loop doesn't follow the Lua convention of starting at `1`, because I found zero-based indexing to be move convenient when using integer division and the modulo operator.

## Cell

The class works as a utility to draw a shape based on its column, row and ultimately value and size.

```lua
local cell = Cell(column, row, size, value)
```

In `Cell:render` then, the class draws a white rectangle at the specified coordinates. (this is subject to change as the game is designed to accept user input)

```lua
function Cell:render()
  love.graphics.setColor(1, 1, 1)
  if self.value == "o" then
    love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
  end
end
```

The rectangle's position is based solely on its column and row. I decided to have `Level:render` translate the entire structure using `love.graphics.translate`.

_Please note_: the point detailed by the translation represents the top left corner of the grid. This is important as the hints are then drawn away from the grid itself.

## Hints

The idea is to built two separate tables, describing the hints for the columns and rows.

```lua
function Level:init(n)
  -- previous attributes

  self.hints = {
    ["columns"] = {},
    ["rows"] = {}
  }
end
```

The tables are populated in `Level:buildGrid`, considering the value of the cells and the concept that the hints should describe the number of contiguous `o`s in the respective row or column.

Taking for instance the logic applied to the hints' columns.

- keep a counter variable

  ```lua
  if not self.hints.columns[column] then
    self.hints.columns[column] = {0}
  end
  ```

- increment the counter if the value describes the desired `o`

  ```lua
  if value == "o" then
    self.hints.columns[column][#self.hints.columns[column]] =
      self.hints.columns[column][#self.hints.columns[column]] + 1
  end
  ```

  Notice that the value incremented is the last item in `self.hints.columns[column]`

- else, add another counter variable. This only if the last digit is not already a counter with a `0` value, to avoid adding multiple `0`s.

  ```lua
  if self.hints.columns[column][#self.hints.columns[column]] ~= 0 then
    self.hints.columns[column][#self.hints.columns[column] + 1] = 0
  end
  ```

This works to create a table of hints, with one considerable issue: the table retains the counter variable `0` if added as a last item. The UI should however display `0` only if there are no squares, no `o`s in the entire column. Outside of the for loop, the idea is to therefore remove the last item if necessary.

```lua
for i, hintColumn in ipairs(self.hints.columns) do
  if #hintColumn > 1 and hintColumn[#hintColumn] == 0 then
    table.remove(hintColumn)
  end
end
```

_Please note_: as mentioned, the logic is repeated for the rows, but considering `self.hints.rows`.

### print and printf

Once the `hints` tables are populated, `Level:render` draws the digits using the `print` and `printf` functions. This last one is necessary to have the hints for the columns centered in the matching cell.

## States

The game is programmed to have four states:

- `StartState`: show the name of the game above a single button, with the string 'Levels'

- `SelectState`: show the levels side by side, and allow to select a particular one

- `PlayState`: play the selected level, starting with an empty grid and the accompanying hints

- `VictoryState`: show the completed level, before moving back to the selection screen

## Input

The game considers both keyboard and mouse input. In `love.load`, the script maintains a reference to a boolean to also describe whether or not the player uses mouse input — see `gMouseInput`.

```lua
function love.load()
  gMouseInput = false
end

function love.mousepressed(x, y, button)
  gMouseInput = true
end
```

This boolean is used to include helper graphics to signal, highlight how the game can be updated — see the `x` allowing to move back to the previous state, in the top left corner.

```lua
function SelectState:render()
  if gMouseInput then

  end
end
```

_Please note_: the purpose of the boolean is purely aesthetic. The `update` function always consider mouse-based input, and the graphics signal, stress the existing features.
