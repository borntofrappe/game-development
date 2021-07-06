# Swap 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

Render a static grid of tiles.

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

## generateBoard

The grid is created with two nested for loops. Instead of using hard-coded values however, I decided to update the code to create a grid with a variable structure.

```lua
function generateBoard(rows, columns)

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

For each tile, the nested table describes the values for the tile's color and variety. It does not add the `x` and `y` coordinate since I plan to use the index of the tables instead.

```lua
table.insert(
  tiles[y],
  {
    color = math.random(#gFrames['tiles']),
    variety = math.random(#gFrames['tiles'][1])
  }
)
```

With a nested for loop, it's possible to rapidly target one cell. For instance, to target the first row, fourth column, you' consider the cell `board[1][4]`.

## drawBoard

The function receives as argument the board to-be-rendered, and then loops through the table(s) to draw the specific tile.

Once created, the grid is finally drawn in `love.draw`, once again using nested loops. Once again, the video uses hard-coded values for the rows and columns, but using `ipairs` you loop through the table in order, and taking stock of the structure of the input board.

```lua
function drawBoard(board)
  for y, row in ipairs(board) do
    for x, tile in ipairs(row) do
      love.graphics.draw(gTextures["match3"], gFrames["tiles"][tile.color][tile.variety], (x - 1) * 32, (y - 1) * 32)
    end
  end
end
```

I use the index value to draw the tiles side by side.
