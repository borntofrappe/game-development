Consider the [assignment for Match 3](https://cs50.harvard.edu/games/2019/spring/assignments/3/).

- [x] Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match

- [x] Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), with later levels generating the blocks with patterns on them (like the triangle, cross, etc.)

  - [x] These should be worth more points, at your discretion

- [x] Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row

- [x] Only allow swapping when it results in a match

- [x] (Optional) Implement matching using the mouse

## Time addition

Adding a second for each tile is already covered in `PlayState:removeMatches()`.

```lua
function PlayState:removeMatches()
  for k, match in pairs(self.board.matches) do
    self.timer = self.timer + #match
    -- consider tiles
  end
end
```

Using the length of the individual matches' tables means the timer is incremented with each tile.

## Flat blocks

Instead of assigning the color and variety solely based on a random value, the `Tile` class is updated to consider the current `level`.

```lua
function Tile:init(x, y, level)
  self.x = x
  self.y = y
  self.level = level
end
```

The color still uses a random value among the available ones.

```lua
self.color = math.random(#gFrames["tiles"])
```

The variety considers instead a random value, dependant on the current level

```lua
self.variety = math.random(math.min(self.level, #gFrames["tiles"][1]))
```

`math.min` is to ensure a valid integer, even when the level surpasses the number of available varieties. At most, `math.random` will consider the length of the table, hence all possible varietis.

In terms of points, the variety is already accounted for:

```lua
self.score = self.score + 100 * tile.variety
```

## Shiny

The shiny variant is created by overlapping a rhombus in the top right corner of a tile.

```lua
function Tile:init(x, y, level)
  self.isShiny = math.random(18) == 1
end

function Tile:render()
  -- draw tile

  if self.isShiny then
    love.graphics.setColor(0.9, 0.8, 0.2, 1)
    love.graphics.polygon(
      "fill",
      (self.x - 1) * TILE_WIDTH + TILE_WIDTH * 3 / 4,
      (self.y - 1) * TILE_HEIGHT + TILE_HEIGHT / 4 - 4,
      (self.x - 1) * TILE_WIDTH + TILE_WIDTH * 3 / 4 + 4,
      (self.y - 1) * TILE_HEIGHT + TILE_HEIGHT / 4,
      (self.x - 1) * TILE_WIDTH + TILE_WIDTH * 3 / 4,
      (self.y - 1) * TILE_HEIGHT + TILE_HEIGHT / 4 + 4,
      (self.x - 1) * TILE_WIDTH + TILE_WIDTH * 3 / 4 - 4,
      (self.y - 1) * TILE_HEIGHT + TILE_HEIGHT / 4
    )
  end
end
```

## Clear row

To clear a row, the logic differs depending on whether the match is horizontal or vertical.

### Horizontal match

The idea is to:

- identify a shiny variant inside of the loop adding the individual tiles to a `match` table.

  This is achieved with a boolean, initialized with a `false` value

  ```lua
  if colorMatches >= 3 then
    local hasShiny = false
    -- consider tiles
  end
  ```

- exit the loop if one of the tiles proves to be shiny

  ```lua
  if colorMatches >= 3 then
    local hasShiny = false
    local match = {}
    for x2 = x - 1, x - colorMatches, -1 do
      local tile = self.board.tiles[y][x2]
      if tile.isShiny then
        hasShiny = true
        break
      end

      table.insert(match, tile)
    end
  end
  ```

  If the tile is not shiny, the program continues adding the tiles to the `match` table.

- outside of the loop, consider the boolean `hasShiny`. This is where the logic clearing the entire row is actually implemented.

Conditional to a tile being shiny:

- add to the table `match` every tile in the current row

  ```lua
  if hasShiny then
    match = {}
    for x3 = 1, COLUMNS do
      table.insert(match, self.board.tiles[y][x3])
    end
    table.insert(matches, match)
  end
  ```

  By adding `match` to `matches` you end up considering every tile in the row.

- move to the next row. To achieve this, use a `goto` statement, moving the code at the beginning of the wrapping for loop

  ```lua
  y = y + 1
  goto row
  ```

  The label is specified between two `::` colon characters, at the very beginning of the loop iterating through the rows.

  ```lua
  for y = 1, ROWS do
    ::row::
    -- consider tiles
  end
  ```

  This works, but there's a chance that the match is identified in the last row. In this situation, continuing to the next row would result in an error, and it's safer to just exit the loop altogether.

  ```lua
  if y == ROWS then
    break
  else
    y = y + 1
    goto row
  end
  ```

Once you include the row in the table, the `removeMatches` function takes care of removing the associated tiles.

This takes care of matches found up to, but not including, the last column. In this instance, the logic is repeated, but without the need to move to the row which follows.

### Vertical match

The logic is here simpler than the one described in the previous section. Once you find a shiny variant inside of a match, loop through the row of the specific tile, adding every tile to `match`.

```lua
for y2 = y - 1, y - colorMatches, -1 do
  local tile = self.board.tiles[y2][x]
  if tile.isShiny then
    for x2 = 1, COLUMNS do
      table.insert(match, self.board.tiles[y2][x2])
    end
  end

  table.insert(match, tile)
end
```

This is enough to have `match`, and then `matches`, contemplate the vertical match, as well as the tiles in the row of the shiny variant.

## Valid swap

To swap only when the swap creates a match:

- swap the tiles in the table

  ```lua
  self.board.tiles[tile1.y][tile1.x], self.board.tiles[tile2.y][tile2.x] = self.board.tiles[tile2.y][tile2.x], self.board.tiles[tile1.y][tile1.x]
  ```

- check if there is a match

  ```lua
  if self:updateMatches() then
  ```

  If there is a match, the game continues to update the visuals

  ```lua
  if self:updateMatches() then
    Timer.tween(
      --
  ```

  If there is no match however, the game swaps the tiles back

  ```lua
  gSounds["error"]:play()
  self.board.tiles[tile1.y][tile1.x], self.board.tiles[tile2.y][tile2.x] = self.board.tiles[tile2.y][tile2.x], self.board.tiles[tile1.y][tile1.x]
  ```

The tricky part is always ensuring that a match is available, one swap away.

## hasMatch

The idea is to loop through the table, swap each tile with its neighbors, and check if that swap creates a match. As soon as one is detected, return `true`. At the end of the loop, return `false`. It is a lengthy process, but by skipping duplicates, it should be possible to find whether or not there are possible matches.

Start by looping through the board, excluding the last column and row.

```lua
function PlayState:hasMatch()
  for y = 1, ROWS - 1 do
    for x = 1, COLUMNS - 1 do
    end
  end
end
```

For each tile then, consider the neighbor to the right and to the bottom.

```lua
function PlayState:hasMatch()
  for y = 1, ROWS - 1 do
    for x = 1, COLUMNS - 1 do
      local tile = self.board.tiles[y][x]
      local neighbor1 = self.board.tiles[y][x + 1]
      local neighbor2 = self.board.tiles[y + 1][x]
    end
  end
end
```

For each neighbor finally, swap the tiles, check for a match.

```lua
self.board.tiles[tile.y][tile.x], self.board.tiles[neighbor1.y][neighbor1.x] =
  self.board.tiles[neighbor1.y][neighbor1.x],
  self.board.tiles[tile.y][tile.x]
if self:updateMatches() then

end
```

Regardless of the outcome, be sure to swap the tiles back, by repeating the first line. If there is a match, exit the function by returning `true`. This means there is a match and the game can continue its normal function.

```lua
-- swap
if self:updateMatches() then
  -- swap back
  return true
end
```

Since the `return` statement is the last line of the function, swap the tiles before it.

If there is no match, swap the tiles back. In this situation the loop continues with the tiles which follow.

```lua
if self:updateMatches() then
  -- swap back
  return true
else
  -- swap back
end
```

### Testing

To test the feature, I decided to:

- reduce the size of the board, to five columns and rows

  ```lua
  ROWS = 5
  COLUMNS = 5
  ```

- use every color in the spritesheet

  ```lua
  function Tile:init(x, y, level)
    self.color = math.random(#gFrames["tiles"])
  end
  ```

- in the while loop, change the appearance of the very first tile to use the last color and variety

  ```lua
  while not self:hasMatch() do
    self.board = Board(self.level, VIRTUAL_WIDTH / 2 + 100, VIRTUAL_HEIGHT / 2)
    self.board.tiles[1][1].color = 18
    self.board.tiles[1][1].variety = 6
  end
  ```

In this manner, by launching the game enough times it's possible to see the while loop in action. The tile in the top left corner will be grey and with a star.

## Mouse

The assignment asks to implement a swap using mouse controls, but I decided update the title screen and gameover state to have the game completely playable with a cursor instead of a keyboard.

The logic depends on the following information:

- is the cursor down

- is the cursor released

To detect if the mouse is down, love2d provides the `love.mouse.isDown()` function.

```lua
function PlayState:update(dt)
  if love.mouse.isDown(1) then
  end
end
```

To detect a mouse release however, it's necessary to use `love.mousereleased` from the main script.

```lua
function love.load()
  love.mouse.isReleased = false
end

function love.mousereleased()
  love.mouse.isReleased = true
end

function love.update(dt)
  love.mouse.isReleased = false
end
```

The `love.mouse` object is modified to provide the additional, necesasry boolean.

### Play

Consider the mouse coordinates following the `love.mouse.isDown` function.

```lua
if love.mouse.isDown(1) then
  x, y = push:toGame(love.mouse.getPosition())
  end
end
```

From this starting point:

- check if the coordinates fall in the area describing the board

- determine the `x` and `y` values of the tile being pressed

- change the selected tile to describe the tile being pressed

- if a tile is not highlighted, use the same tile for the highlighted variant

Once a tile is highlighted, it is then when the mouse is released that the code tries to swap the two tiles. The code repeats here much of the logic following a key press on the enter key, trying to swap the selected and highlighted tiles.

Just be sure to reset highlighted tile, and regardless of whether the swap occurs. This ensures that, as the mouse is pressed again, the game considers the selected/highlighted variants anew.

### Title screen

Similarly to the play state, the `update` function considers the coordinates of the cursor in the scope of `isDown()`.

Based on this information, however, the logic is different:

- check if the coordinates fall in the rectangle describing the menu

- if the coordinate describes the top half, change the option to 'start', else to 'quit game'

Once the cursor is released finally, move to the start state, or quit the game. Using the same logic which follows a press on the enter key.

### Gameover

The state requires the smallest change. Move to the title state when the `isReleased` boolean highlights that the cursor has been released.

```lua
if love.mouse.isReleased then
  gStateMachine:change("title")
end
```

The change is not triggered by a mouse press, since this would interfere with the mouse press on the title screen.

```lua

```
