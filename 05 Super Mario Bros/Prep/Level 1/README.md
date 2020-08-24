Add variety in the form of pillars.

## Procedural generation

The idea is to loop through the level column by column and, depending on the value of a flag, include a specific set of tiles. For instance:

- generate a chasm by rendering empty tiles

- generate pillars by rendering more bricks than usual

A flag was already included to render the tiles' tops on the very first row.

```lua
local tile = {
  id = y < ROWS_SKY and TILE_SKY or TILE_GROUND,
  topper = y == ROWS_SKY
}
```

With this boolean, the code rendered the additional quad on top of the tile.

```lua
-- tile
love.graphics.draw(
  gTextures["tiles"],
  gFrames["tiles"][variety_tiles][tile.id],
  (x - 1) * TILE_SIZE,
  (y - 1) * TILE_SIZE
)
-- top if necessary
if tile.topper then
  love.graphics.draw(
    gTextures["tops"],
    gFrames["tops"][variety_tops][1],
    (x - 1) * TILE_SIZE,
    (y - 1) * TILE_SIZE
  )
end
```

The update extends this utility to provide more variety.

## GenerateLevel

The function creates a table of ids, repeating the logic previously included in `love.load`. Instead of creating the table in rows however, it flips the coordinates to slot the tiles in columns.

```lua
for x = 1, width do
  -- add column
  for y = 1, height do
    -- fill column
  end
end
```

This allows to render the world column by column.

```lua
for x = 1, width do
  for y = 1, height do
    local tile = tiles[x][y]
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][variety_tiles][tile.id],
      (x - 1) * TILE_SIZE,
      (y - 1) * TILE_SIZE
    )
  end
end
```

I've decided to loop through the table(s) using `tiles` and `ipairs`, but the point stands. `x` and `y` describe the position of the individual tiles.

```lua
for x, column in ipairs(tiles) do
  for y, tile in ipairs(column) do
    local tile = tiles[x][y]
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][variety_tiles][tile.id],
      (x - 1) * TILE_SIZE,
      (y - 1) * TILE_SIZE
    )
  end
end
```

Most importantly, however, `GenerateLevel` allows to modify the column directly in the generating loop.

```lua
for x = 1, width do
  -- add column

  -- change the y coordinate describing when to use TILE_SKY
  rows_sky = math.random(5) = math.random(5) == 1 and ROWS_SKY - 2 or ROWS_SKY
  for y = 1, height do
    -- fill column
  end
end
```

In this instance the height of the sky is reduced to make room for more ground tiles. By showing more bricks, the effect is to have a taller surface. There's no collision yet, so the character moves through the tiles.
