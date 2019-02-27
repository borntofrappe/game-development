# Match Three 4 - Retiling

The previous two updates allowed to respectively remove matches and update the position of the remaining tiles. This update is responsible for fixing an outstanding issue with both features: having a table with `nil` values.

The code can be included in the `:updateBoard()` function, as updating the board relates to both moving the tiles and adding new ones.

The approach is as follows:

- loop through the table one column at a time.

- loop through each row starting from the bottom of the board.

- upon finding a `nil` value, create a new tile.

- add the tile to the board and draw it on the screen at the precise coordinates.

```lua
-- once every existing tile has been moved to account for gravity include new tiles
-- loop through each column
for x = 1, 8 do
  -- starting from the last row and until the first one
  for y = 8, 1, -1 do
    -- consider the tile found at the precise coordinates
    local tile = self.tiles[y][x]
    -- if nil, it represents a space
    if tile == nil then
      -- create a new tile, much alike when making up the board in the first place
      local tile = Tile(x, y, self.offsetX, self.offsetY, math.random(18), math.random(6))
      -- position the tile to its rightful place, but starting 32px above, to give the impression of a falling tile
      tile.y = -32
      -- include the tile in the table of tile
      self.tiles[y][x] = tile
      -- ! transition the tile with the tween function with the same delay applied in the first for loop
      Timer.after(0.2, function()
        Timer.tween(0.2, {
          [tile] = { y = (tile.gridY - 1) * 32 + self.offsetY}
        })
      end)

    end
  end
end
```

The code also includes a rather neat transition, to have every tile fall down to its respective place, but the logic is sound. Just remember to always specify how the tile is include on the screen **and** in the table of tiles. This to have the table of tiles always match the grid on the screen.
