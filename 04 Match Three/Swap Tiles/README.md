# Swap

Diving into the dynamics of the match 3 game, we begin by creating a grid of shapes which can be selected and swapped. The feature is developed in steps, from creating the grid out of the `match.png` graphic, to allow a swap to occur between selected shapes and finally to enable tweening in said transition.

## Swap 0 - grid.lua

Taking inspiration from the breakout project, the tiles for the grid are created through a function creating quads. This is found in `Util.lua`, and replicates the same logic documented in said game.

- include the image through `love.graphics.newImage()`;

  ```lua
  grid = love.graphics.newImage('graphics/match3.png')
  ```

- create a table of for the tiles, through the `GenerateQuads` function;

  ```lua
  tiles = GenerateQuads(grid, 32, 32)
  ```

- include the tiles through the `love.graphics.draw()` function, specifying in particular the:

  - image being used;

  - quad being targeted;

  - horizontal coordinate;

  - vertical coordinate.

  ```lua
  love.graphics.draw(grid, tiles[1], 0, 0)
  ```

This covers how to include the graphic and specifically the first quad from the graphic. Using the same logic however, it is possible to create a grid and populate it with random tiles, from the made up table.

The lecturer provides functions to achieve this feat. Intead of creating a table with all possible tiles however, the lecturer details a table itself of tables, to separate the tiles according to their color (9 rows of colors, over 2 columns leading up to 18 rows of tiles each 32px wide and tall).

### love.load()

- `tileSprite` holds a reference to the image;

- `tileQuads` holds a reference to the quads generated from the image;

- `board` stores a reference to the return value of the `generateBoard` function.

### generateBoard()

`generateBoard` creates an 8x8 grid of tiles. The grid is made up of a table for each row. Each row is then made up of additional tables actually describing the tiles. The tiles are described according to their coordinate (`x` and `y`) as well as integer to pick one of the quads from the table (`tile`).

```lua
function generateBoard()
  -- create a table storing the tables themselves storing the different tiles
  tiles = {}
  -- 8 rows (which change in their y coordinate)
  for y = 1, 8 do
    -- include a table
    table.insert(tiles, {})

    -- 8 columns (which change in their x coordinate)
    for x = 1, 8 do
      -- in the table created for the row include tables responsible for the tiles' coordinates and a random value for the tiles' shapes
      table.insert(tiles[y], {
        x = (x - 1) * 32, -- 32px wide, starting at 0, then incrementing by 32 for each successive tile
        y = (y - 1) * 32,

        -- random integer used to identify a random quad from the quad table
        tile = math.random(#tileQuads)
      })
    end
  end

  -- return the table of tiles
  return tiles
end
```

### love.draw()

In the virtualization set up with the `push` library, draw the grid using a `drawBoard` function.

### drawBoard()

This one takes as argument the coordinates of the grid and looping through the different tiles making up the board uses the `love.graphics.draw` function to draw one square for each cell.

```lua
-- function drawing one cell with the tables' values
function drawBoard(offsetX, offsetY)
  -- loop through the rows
  for y = 1, 8 do
    -- loop through the tiles
    for x = 1, 8 do
      -- retrieve the specific tile to avoid repeating it in the draw function
      local tile = board[y][x]

      -- draw the tile using the coordinate and index specified in the table
      -- add the offset to move the grid in the screen
      love.graphics.draw(tileSprite, tileQuads[tile.tile], tile.x + offsetX, tile.y + offsetY)
    end
  end

  -- return the table of tiles
  return tiles
end
```