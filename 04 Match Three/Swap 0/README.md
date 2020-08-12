With this static update, render a grid of tiles.

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

Refer to `GenerateQuadsTiles` for the actual implementation.

Once the function provides the desired structure, the quads are included in `love.load`.

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

The grid is created with two nested for loops. Instead of using hard-coded values however, I decided to update the code to create a grid with a variable structure.

```lua
function generateGrid(rows, columns)

end
```

With the extra arguments, the function builds the grid with a 2d table.

```lua
for y = 1, rows do
  table.insert(tiles, {})
  for x = 1, columns do
    table.insert(
      tiles[y],
      {
        -- tile
      }
    )
  end
end
```

For each tile, the nested table describes four values:

- `x` and `y`, for the coordinates

- `color` and `variety`, for the specific sprite in the quads table

Using a nested for loop is efficient to rapidly target one cell. For instance, to target the first row, fourth column, you' consider the cell `board[1][4]`.

Once created, the grid is finally drawn in `love.draw`, once again using nested loops. Once again, the video uses hard-coded values for the rows and columns, but using `ipairs` you loop through the table in order, and taking stock of the structure of the input board.

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
