Draw tiles in a 8x8 grid.

## Quads

The project considers the image provided in _match3.png_, and creates a table in which each tile is represented by a quad. There are 18 sets of colors, each with 6 varieties, and each with a 32x32 size.

Instead of adding the quads in a single table, the script goes one step further to structure the table according to color and variety.

```pseudo
quads = {
  color = {
    { variety },
    { variety },
    { variety },
    { variety },
    { variety },
    { variety }
  },
  color = --
}
```

The idea is to ultimately access a specific tile with the following syntax.

```lua
tiles[color][variety]
```

This is achieved by nesting two for loops, and modifying the `x` and `y` coordinate with two conditionals. These conditionals are necessary to cope with the structure of the image:

- the tiles are side by side

- the colors are row by row

- the colors are divided in two groups, and positioned side by side

Refer to `GenerateQuadsTiles` for the actual implementation. With this function, the quads are included in `love.load` similarly to how quads were included in _Breakout_.

```lua
gTextures = {
  ["match3"] = love.graphics.newImage("res/graphics/match3.png")
}

gFrames = {
  ["tiles"] = GenerateQuadsTiles(gTextures["match3"])
}
```

To render an individual tile then, use `love.graphics.draw`.

```lua
love.graphics.draw(gTextures["match3"],gFrames["tiles"][1][1],0,0)
```

## Board

The 8x8 grid is created with two nested for loops.

```lua
for y = 1, 8 do
  table.insert(tiles, {})
  for x = 1, 8 do
    table.insert(
      tiles[y],
      {
        -- tile
      }
    )
  end
end
```

Each tile describes four values:

- `x` and `y`, for the coordinates

- `color` and `variety`, for the specific sprite in the quads table

Using a nested for loop is efficient to rapidly target one cell. For instance, to target the first row, fourth column, you' consider the cell `board[1][4]`.

Once created, the grid is finally drawn once more with two nested for loop. The video uses a hard-coded set similarly to the one introduced in the previous snippet, but it's possible to also use `ipairs`. In this manner you loop through the rows, then through the cells of the rows, and draw the tile using the four fields.

```lua
for k, row in ipairs(board) do
  for key, tile in ipairs(row) do
    tile =
      love.graphics.draw(
      gTextures["match3"],
      gFrames["tiles"][tile.color][tile.variety],
      tile.x,
      tile.y
    )
  end
end
```

In the code, the function accepts two arguments to move the entire grid, but this only changes the `x` and `y` coordinate in the drawing function.
