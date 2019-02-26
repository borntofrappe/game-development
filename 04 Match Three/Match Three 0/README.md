# Match Three 0 - Board & Tile

**Time Based Events**, **Tween Between Values** and **Swap Tiles** provide the explanation and implementation of some essential features for the game. Once the swapping feature is implemented, it is however helpful to go back into the mindset used with Pong, Flappy Bird and Breakout, with incremental updates building up the game one feature at a time.

With update 0 I plan to set up the game, not only with `main.lua`, but also and more prominently with a `Board.lua` and `Tile.lua` files. These describe two classes, each responsible for one aspect of the game.

## Dependencies.lua

Include in the list of dependencies every `.lua` file, to have them available in `main.lua`. This holds true for every file described hereafter.

## Tile.lua

Starting with the smalles class between the two, the `Tile` class considers the coordinates, color and variety of a tile and renders said tile on the page.

Its scope is rather limited, as it includes only the `init()` and `render()` function, but the implications behind the class are more than relevant. Accepting a color and a variety means that the tiles need to be sorted according to exactly these variables. Already this implies a modification of the `GenerateQuads` function, or the inclusion of another quad-generating method to have a fitting data structure. Accepting color, variety as well as coordinate means that the file including an instance of the tile needs to require the necessary values. This speaks to the importance of describing and detailing a class.

Based on this:

- in the `init()` function describe the values required to draw the tile on the screen;

  ```lua
  function Tile:init(gridX, gridY, color, variety)
    self.gridX = gridX
    self.gridY = gridY
    self.x = (gridX - 1) * 32
    self.y = (gridY - 1) * 32

    self.color = color
    self.variety = variety
  end
  ```

- in the `render()` function make use of the necessary texture and quad table, alongside the defined variables, to draw the shape.

  ```lua
  function Tile:render()
    love.graphics.draw(gTextures['spritesheet'], gFrames['tiles'][self.color][self.variety], self.x, self.y)
  end
  ```

  This also means that there needs to be a global variable describing the specific texture and quad table.

### Update

Upon implementing the code I decided to maintain the overarching `GenerateQuads()` function and have the table of unsorted tiles rearranged in the `Tile` class.

This means the class receives the table of quads, as earlier, and then accommodates the color and variety based on the structure of the graphic itself. There exist 18 colors, each with 6 varieties. The `Tile:arrange()` function is created in light of this to loop through the table of quads and arrange them as wanted.

```lua
function Tile:arrange()
  -- overarching table
  local tiles = {}
  for color = 1, 18 do
    -- table for each different color
    table.insert(tiles, {})
    for variety = 1, 6 do
      -- tile of each variety and for the specified color
      table.insert(tiles[color], gFrames['tiles'][variety + (color - 1) * 6])
    end
  end

  -- return the table
  return tiles
end
```

The return value is stored in a field of the class, `self.tiles`, and then used when drawing the specific tile.

```lua
function Tile:render()
  love.graphics.draw(gTextures['spritesheet'], self.tiles[self.color][self.variety], self.x, self.y)
end
```

## Board.lua

The `Board` class is where most of the logic explained in the previous three folders resides. In here we take the quads from the `gFrames` global variable, create a table of `Tile` instances and render them in a grid layout, spanning 8 rows and 8 columns.

Since the class builds on top of the concepts explained in the three prep folder, I'll briefly describe the file's purpose.

- the `init()` function describes the variables required for the board. This means where the board ought to be positioned, through `offsetX` and `offsetY`, and the table of tiles, created through the `generateBoard()` function. The `init` function is also where the variables for the swap are included:

  - the highlighted tile, alongside a boolean describing whether this tile ought to be displayed;

  - the selected tile.

- the `update(dt)` function reacts to a key press on the arrow and enter keys, repeating the logic explained in the swap folder.

- the `render()` function makes use of the `drawBoard()` function, where the drawing of the tiles is centralized.

To complete these three main functions, `generateBoard()` and `drawBoard()` are defined each to solve a specific goal:

- `generateBoard()` creates a table of tiles. Since we now have a class for the tiles, in `Tile.lua`, the function creates a table of instances of said class, and not a table of tables. as introduced in the preparatory sub-folders.

- `drawBoard()` loops through the newly-created table to render the different tiles. Since we have instances of the `Tile` class, the tiles are drawn through the `Tile:render()` method.

## main.lua

The main file is considerably modified insofar the logic described in the preparatory folders is not distributed in `Board.lua` and `Tile.lua`.

To complete the mentioned files, `main.lua` is responsible for:

- setting up the global variables, referring to the fonts, images and otherwise assets used throughout the game;

- createing an instance of the `Board` class, passing the values necessary for its `init` function;

- introducing the background as the bottom layer of the entire application. A background which is updated in its horizontal coordinate to have the image constantly scroll to the left.

## constants.lua

This is where the constant of the game are included. Values which are not meant to be modified, such as the screen size, or the offset speed of the background image.

## Util.lua

Storing utility-type methods, this file currently describes the `GenerateQuads` function, to divvy up an image into quads.
