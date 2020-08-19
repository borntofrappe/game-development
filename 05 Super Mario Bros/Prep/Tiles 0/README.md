Render static tiles on the screen.

## Quads

The demo considers much of the logic already explored in _Breakout_ and _Match Three_. The only difference is that the `GenerateQuads` function is included directly in _main.lua_.

The idea is to create a table, `tiles`, and populate said table with an integer `1` or `2`. This integer is then matched to a specific quad.

```lua
tiles = {}
mapWidth = 20
mapHeight = 20

for y = 1, mapHeight do
  tiles[y] = {}
  for x = 1, mapWidth do
    local tile = {id = y < 5 and TILE_SKY or TILE_GROUND}
    tiles[y][x] = tile
  end
end
```

The way the quads are setup, `1` coincides with the brick expressing the first 16 pixels of _tiles.png_. `2` represents instead a transparent tile, effectively showing the background instead.

```lua
TILE_GROUND = 1
TILE_SKY = 2
```
