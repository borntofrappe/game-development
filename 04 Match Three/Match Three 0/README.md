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