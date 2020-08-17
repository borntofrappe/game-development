Consider the [assignment for Match 3](https://cs50.harvard.edu/games/2019/spring/assignments/3/).

- [x] Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match

- [x] Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), with later levels generating the blocks with patterns on them (like the triangle, cross, etc.)

  - [x] These should be worth more points, at your discretion

- [x] Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row

- [ ] Only allow swapping when it results in a match

- [ ] (Optional) Implement matching using the mouse

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
