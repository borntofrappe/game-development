# [Picross](https://github.com/borntofrappe/game-development/projects/2)

Create a demo developing the concept of picross, a puzzle game in which the player fills a grid based on the instructions given on the side of each row and column, and in order to draw a stylized picture.

## Topics

- keyboard and touch input, similarly to _Match Three_

- levels based on data, similarly to _Angry Birds_. The idea is to have a table collect the design of the levels through `x`s and `o`s, and have the script create the associated grid at startup

## Development

### Levels

As mentioned, the levels are designed with `x`s and `o`s. `Levels.lua` describes these structure using Lua's format for long strings.

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

The length considers the whitespace and new line characters. This is problematic in the moment you eventually want to build the grid in which the `x`s and `o`s are slotted in rows and columns. One fix I found is to use `string.gsub`, and replace every character that is not one of the two accepted literals with an empty string.

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

### Level

The class builds the grid starting from the string introduced in the previous section.

```lua
function Level:init(n)
  self.name = LEVELS[n].name
  self.level = LEVELS[n].level
  self.levelString = string.gsub(
end
```

From this starting point, the `buildGrid` function populates a table detailing the grid structure.

```lua
function Level:init(n)
  self.grid = {}
  self:buildGrid()
end
```

---

_Update_: in the `init()` function I decided to immediately specify the length of the string, as well as the length of the grid's side and the size of the individual length. These values can be computed in `buildGrid`, but they are useful to position the hints as well.

```lua
function Level:init(n)
  -- previous attributes
  self.levelStringLength = #self.levelString
  self.gridSide = math.floor(math.sqrt(self.levelStringLength))
  self.cellSize = math.floor(GRID_SIZE / self.gridSide)
end
```

---

The grid is built looping through the string, and considering for each index the matching column and row.

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

#### Update

The init function is modified to receive a table, and to hide the hints if a flag is explicitly specified.

```lua
function Level:init(def)
  local def =
    def or
    {
      number = math.random(#LEVELS)
    }
end
```

Based on this input value:

- `self.number` collects the number of the level, picking up the default random value

  ```lua
  self.number = def.number
  ```

- `self.hideHints` considers the flag. By default, this is set to `nil` as the `def` table doesn't add a matching field

  ```lua
  self.hideHints = def.hideHints
  ```

The flag is then used to conditionally show the hints in the `render` function. It is not however used in the build function. In this manner the hints are still computed, just not shown.

### Cell

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

```lua
love.graphics.translate(WINDOW_WIDTH - GRID_PADDING - GRID_SIZE, WINDOW_HEIGHT - GRID_PADDING - GRID_SIZE)
```

_Please note_: the point detailed by the translation represents the top left corner of the grid. This is important as the hints are then drawn away from the grid itself.

### Hints

The idea is to built two separate tables, sporting the hints for the columns and rows.

```lua
function Level:init(n)
  -- previous attributes

  self.hints = {
    ["columns"] = {},
    ["rows"] = {}
  }
end
```

The tables are populated in `Level:buildGrid`, considering the value of the cells and the concept that the hint should describe the number of contiguous `o`s in the respective row or column.

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

This works to create a table of hints. With one considerable issue: the table retains the `0` if added as a last item. The UI should however display `0` only if there are no squares, no `o`s in the entire column. Outside of the for loop, the idea is to therefore remove the last item if necessary.

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

## Design

In its first version, the game is scheduled to have three states:

- `StartState`: show the name of the game above a single button, with the string 'Levels'

- `SelectState`: show the levels in a grid.

  Currently, the number is low enough to have them readily available in one screen, but in a more complex demo you might add pagination, with the idea of showing `x` levels per page.

  For each level, show a question mark using the instructions behind `LEVELS[0]`. The idea is to then have a flag for completed levels, and show the completed structure instead of this default.

- `PlayState`: display an empty grid, accompanied only by the hints.

  This is where the bulk of the game happens.

### StartState

The button moving the game to the select state is animated with the `timer` library. The idea is to have the animation on the button being focused, but since there's only one, there is no need to further introduce a variable to keep track of the current option. This might change in a future update.

The animation itself involves the opacity of the fill describing the button's background. It plays immediately, and then at an interval. To have the alpha value recede back to its original value, the `tween` animation takes half the duration of the interval. The interval, however, is further specified to last a bit more. 25 percent more.

```lua
self.interval =
  Timer.every(
  self.animationDuration * 1.25,
  function()
    -- tween animation
  end
  )
end
```
