Render static tiles on the screen.

## Quads

The idea is to create a table, `tiles`, and populate said table with an integer `1` or `2`. This integer is then matched to a specific quad.

```lua
tiles = {}
mapWidth = 20
mapHeight = 20

for y = 1, mapHeight do
  tiles[y] = {}
  for x = 1, mapWidth do
    local tile = {id = y < 5 and 2 or 1}
    tiles[y][x] = tile
  end
end
```

The way the quads are setup, `1` coincides with the brick expressing the first 16 pixels of _tiles.png_. `2` represents instead a transparent tile, effectively showing the background.

These values are set through constants, but the logic of the previous snippet remains.

```lua
TILE_GROUND = 1
TILE_SKY = 2
```

### Update

Instead of using `y < 5`, I've also decided to consider how many tiles would fit vertically on the screen: `VIRTUAL_HEIGHT / TILE_SIZE`. With this value, it's possible to have a more reliable solution when deciding how much of the window to cover with bricks.

## Background

The demo displays a background with a random color. By pressing `r`, the script is also equipped to provide a new value for the _rgb_ components.
