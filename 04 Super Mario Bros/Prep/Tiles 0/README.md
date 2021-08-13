# Tiles 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

## Quads

The idea is to create a table, `tiles`, and populate said table with an integer, `1` or `2`. The integer is then matched to a specific quad.

```lua
tiles = {}
mapWidth = 20
mapHeight = 20

for y = 1, mapHeight do
  tiles[y] = {}
  for x = 1, mapWidth do
    local tile = {id = y < VIRTUAL_HEIGHT / 2 and 2 or 1}
    tiles[y][x] = tile
  end
end
```

The way the quads are setup, `1` coincides with the brick expressing the first 16 pixels of _tiles2.png_. `2` represents instead a transparent tile, effectively showing the background.

These values are set through constants, but the logic of the previous snippet remains valid.

```lua
TILE_GROUND = 1
TILE_SKY = 2
```

## Background

The demo displays a background with a random color. By pressing `r`, the script is also equipped to provide a new value for the `rgb` components.
