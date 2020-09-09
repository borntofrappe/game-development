Consider tile collision.

## pointToTile

The `pointToTile()` function works to take the `(x, y)` coordinates on the screen, and provide the tile at the specific point.

```lua
function pointToTile(x, y)
  column = math.floor(x / TILE_SIZE)
  row = math.floor(y / TILE_SIZE) + 1
  return self.tiles[row][column]
end
```

To be safe, the function is pre-emptively terminated if the coordinates describe a point outside of the game window.

```lua
if x < 0 or x > MAP_WIDTH * TILE_SIZE or y < 0 or y > WINDOW_HEIGHT then
  return nil
end
```

## PlayState

By looking at the tiles on the right and left side respectively, the idea is to move the player only when the tiles allow for such a movement. In detail, only when the tiles have an id matching the tile representing the sky.
