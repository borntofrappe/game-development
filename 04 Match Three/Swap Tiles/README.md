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

## Swap 1 - swap.lua

`generateBoard` and `drawBoard` allow to respectively create and draw a grid of 64 tiles. It is however necessary to implement the swapping feature, to change the position of the tiles two at a time.

Following keyboard input:

- use the arrow keys to select a specific tile;

- press enter to highlight a tile. Press again enter to have the tile swapped with the highlighted one.

The approach of the lecturer is slightly different from mine, but here's how to implement the described feature,

### gridX && gridY

A nifty addition to the codebase is made in the definition of the tiles. On top of having the `x` and `y` fields refer to the position on the screen the lecturer introduces `gridX` and `gridY`, to describe the position of the tiles in the grid. This is incredibly helpful as it allows to reason with the tile in terms of columns and rows, and in the [1-8] range of the 8x8 grid.

```lua
table.insert(tiles[y], {
  -- x and y describe the value on the screen, given the 32px size of the tile
  x = (x - 1) * 32,
  y = (y - 1) * 32,
  -- gridX and gridY describe the position in the grid, in terms of rows and columns
  gridX = x,
  gridY = y,

  -- tile describes the different quads in the quads table
  tile = math.random(#tileQuads)
})
```

### selectedTile

`selectedTile` is instantiated in the `load` function as a copy of one of the tiles in the board.

```lua
selectedTile = board[math.random(8)][math.random(8)]
```

This allows to have an immediate reference to a table equipped with the necessary coordinates. The random integer is used to have the selector start at a random tile in the grid.

In the `drawBoard` function, the selected tile is used to draw the outline of a rectangle, at the coordinates specified by `selectedTile.x` and `selectedTile.y`.

```lua
love.graphics.rectangle('line', selectedTile.x + offsetX, selectedTile.y + offsetY, 32, 32, 4)
```

In `love.update(dt)`, `selectedTile` is finally updated following user input. Since the tile refers to an actual tile in the 8x8 grid, it is possible to change its position by changing the reference to the tile in said grid. Instead of directly modifying the coordinate, in other words, we change the tile to which `selectedTile` is referring.

```lua
if love.keyboard.wasPressed('up') then
  selectedTile = board[math.max(1, selectedTile.gridY - 1)][selectedTile.gridX]
end
```

The update is here described for the `up` key, but the same reasoning, although with different math, holds true for the other three keys. Notice how the reference of the tile changes on the basis of the `gridX` and `gridY` values describing the position in the 8x8 grid. Notice how the value is "clamped" through the `math.max` function, as to make sure that the selection cannot exceed the boundaries of the 8x8 grid,.

### highlightedTile

In the course the highlighted tile is described directly through coordinates, in `highlightedX` and `highlightedY`. The same reasoning used with `selectedTile` can be however replicated to maintain a consistent reasoning.

The only differences between the two relate to the fact that:

- the higlighted tile is shown only when pressing the `enter` key. In light of this, there needs to be a boolean toggling its appearance;

  ```lua
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    if highlighted then
      highlighted = false

    else
      highlighted = true
    end
  end
  ```

- the tile is shown through a semi-transparent, filled rectangle, in the position described by the selected tile.

  ```lua
  -- in love.update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    if highlighted then
      highlighted = false

    else
      highlightedTile = board[selectedTile.y][selectedTile.x]
      highlighted = true
    end
  end

  -- in drawBoard()
  if highlighted then
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.rectangle('fill', highlightedTile.x + offsetX, highlightedTile.y + offsetY, 32, 32, 4)
    -- reset the opacity
    love.graphics.setColor(1, 1, 1, 1)
  end
  ```

The tile is used as reference for the actual swap, which is implemented when pressing enter **and** when a tile is already highlighted. The feature requires a bit more understanding, so it's highlighted in a separate section.

### Swapping Tiles

When pressing enter, the game updates the interface dependant on `highlighted`, and specifically whether the boolean is set to true or false.

If `false`, <!-- the easy, already described occurrence --> update `highlightedTile` to include the semi-transparent filled rectangle in the position specified by `selectedTile`.

```lua
if highlighted then
  -- ACTUAL SWAP
  highlighted = false

else
  highlightedTile = board[selectedTile.y][selectedTile.x]
  highlighted = true
end
```

If `true`, retrieve the selected and highlighted tile. On the basis of their values and position update the interface as well as the grid, to have the two tiles effectively swapped in the `board` table.

The swap is a bit tricky, as it involves modifying the appearance of the board **and** modifying the structure of the same board. It is not just a matter of modifying the coordinates of the tiles.

Here's how it's implemented:

- store a reference to the selected and highlighted tile in two variables.

  ```lua
  local tile1 = selectedTile
  local tile2 = highlightedTile
  ```

  This allows to more concisely update the interface and the grid.

- create temporary variables for one of the tile's own coordinates. This is necessary to implement the swap: as one tile is then updated we don't lose the values of the overwritten tile.

  ```lua
  local tempX, tempY = tile2.x, tile2.y
  local tempgridX, tempgridY = tile2.gridX, tile2.gridY
  local tempTile = tile1
  ```

  Introducing the variables two at a time is a matter of convenience.

- swap the tiles in the grid, to have the 8x8 grid effectively updated.

  ```lua
  board[tile1.gridY][tile1.gridX] = tile2
  board[tile2.gridY][tile2.gridX] = tempTile
  ```

  The first tile refers to the second one, while the second one refers to the first, through the temporary variable.

- update the coordinates of the tiles. This to have the interface match the change in the grid, as the tiles are swapped, but retain their previous `x`, `y`, `gridX` and `gridY`. They also retain their `tile`, but this value needs to persist through the change.

  ```lua
  tile2.x = tile1.x
  tile2.y = tile1.y
  tile2.gridX = tile1.gridX
  tile2.gridY = tile1.gridY

  tile1.x = tempX
  tile1.y = tempY
  tile1.gridX = tempgridX
  tile1.gridY = tempgridY
  ```

  Again, one of the tiles uses the other's values. The other uses the temporary variables.

This allows to effectively swap the tiles. That being said, two more additions are included in the code, beyond the scope of the swap.

- the selected tile is updated to refer to the second tile. This is purely a design choice.

  ```lua
  selectedTile = tile2
  ```

- the entire swap is made conditional to the highlighted and selected tiles being adjacent. Top, right, bottom, left. This condition is checked by considering the position of the tiles in the grid.

  ```lua
  if math.abs((tile1.gridX - tile2.gridX) + (tile1.gridY - tile2.gridY)) == 1 then
    -- SWAP AWAY
  end
  ```
