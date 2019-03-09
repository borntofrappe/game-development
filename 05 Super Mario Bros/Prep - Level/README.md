# Procedural Level Generation

Levels are generated by including conditions and flags when populating the world with different tiles. This is similar to the Match 3 game, or even Breakout, when certain conditions are put into place. Instead of having tiles of the same color or bricks of different colors and tiers however, here we want to include different _types_ of tiles.

Think of a condition including a chasm, by skipping tiles making up the ground for an entire column.

- using `tiles.png` and `tile_tops.png`

- positioning the top exactly where the sky ends;

- looping through the tiles and updating the tiles being used when typing r.

## Update 0 - Flat Levels

In the first update the appearance of the world is altered whenever pressing `r`. To achieve this feat, **tiles.png** and **tile_tops.png** are introduced to style the ground and the first layer of ground tiles respectively.

I decided to update `Util.lua` as to extract the precise information for both use cases. With the commented functions, it is possible to create a reference to a table aptly describing every type of tile and every type of top. The lecturer actually puts more thought into the these tables, with nested levels for different colors and types. I might consider this at a later stage, but for the time being I am satisfied with the simpler approach of having two giant tables, one of which refers to every squared tile, one of which refers to every straight top.

The lecturer also separates the logic making up the world in a dedicated function, `generateLevel`. This is similarly to the level maker introduced in Breakout, and it might be helpful especially when the generation of levels starts to get more complicated. Think pillars, chasms.

In this function a table of tiles is created, as previously done in `love.load`:

```lua
-- function describing the levels through specific id(s) and flags
function generateLevel()
  -- initialize an empty table
  local tiles = {}
  -- populate the table with as many items as there are cells
  for y = 1, MAP_HEIGHT do
    -- one table for each column
    table.insert(tiles, {})
    for x = 1, MAP_WIDTH * 2 do
      -- one table for each cell
      -- ! detailing the actual values required for the rendering of different tiles
      table.insert(tiles[y], {
        id = y < MAP_SKY and TILE_SKY or tileGround,
        -- include a boolean describing the top of the tiles after the sky's own tiles
        topper = y == MAP_SKY and true or false
      })

    end
  end
  -- return the overarching table
  return tiles
end
```

Notice the inclusion of a flag in `topper`. This is introduced to later have the `love.draw` function draw a tile when the boolean is true, again moving the logic inside of the `generateFunction` instead of specifying the value where the world is being drawn. Put it simply: with the previous approach the top of the tile was introduced in `love.draw`.

```lua
if y == MAP_SKY then
  love.graphics.draw(
    gTextures['topsheet'],
    gFrames['tops'][tileTop],
    (x - 1) * TILE_SIZE,
    (y - 1) * TILE_SIZE
  )
end
```

With the new approach the top of the tile is introduced through the boolean.

```lua
if tile.topper then
  love.graphics.draw(
    gTextures['topsheet'],
    gFrames['tops'][tileTop],
    (x - 1) * TILE_SIZE,
    (y - 1) * TILE_SIZE
  )
end
```

It may not seem like a substantial difference, but there's an underlying shift in the way the world is generated and then rendered. There is a separation of concerns, if you want to speak in terms of web development. This separation of concerns allows to further the cause of the `generateLevel` function, which is itself and solely responsible for the appearance of the world.

With the aforementioned function, two additional variables are included in `tileGround` and `tileTop`. These refer to a random index in the table of tiles and tops respectively, to have the world be rendered through different shapes and colors. The main feature of the update, pressing `r` to alter the world's appearance, is implemented by modifying these values and updating the tiles making up the ground.

## Update 1 - Pillars

To make the levels 'less flat' we start by introducing pillars.

Pillars, like chasms, are introduced on a column by column basis. To achieve this feat, the lecturer updates the `generateLevel()` function as follows:

- populate the tiles table with sky tiles only;

- once the table is set up, proceed to conditionally include the ground tiles, at varying heights for the pillars, by considering the tiles column after column.

My solution varies slightly from the lecturer's one, but for once I do believe my approach is rather cleaner. Instead of conditionally setting the tiles for the pillars and below those the tiles for the ground, I decided to have a single declaration describing the two together.

Essentially, I included a variable describing where ground tiles should begin and I modified this pending a certain flag resolving to true.

```lua
-- loop through the table one column at a time
for x = 1, MAP_WIDTH do
  -- initialize a variable referring to the ground level (by default equal to the constant in MAP_SKY)
  local groundLevel = MAP_SKY
  -- boolean describing whether or not to add a pillar
  local isPillar = math.random(5) == 1
  -- if the flag resolves to true, decrement groundLevel to show a taller ground column
  if isPillar then
    -- include a pillar between 1 and 3 tiles tall
    groundLevel = groundLevel - math.random(3)
  end

  -- starting from the tile identifying the ground level, and ending at the bottom of the screen
  for y = groundLevel, MAP_HEIGHT do
  -- include the ground tile and the topper flag only if the level matches the groundlevel
    tiles[y][x] = {
      id = tileGround,
      topper = y == groundLevel and true or false
    }
  end
end
```

Important note: so far I've included `MAP_WIDTH * 2` to have the level exceeds the horizontal boundary of the screen. With the current update I decided to have the loop refer only to `MAP_WIDTH` and to change the constant value as needed.

I also included `math.randomseed(os.time())`, an essential part of `love.load`. This allows to have the `math.random()` functions actually use random values.

## Update 2 - Chasms

Beside pillars, the levels ought to include chasms, in the form of columns without any ground tile.

Immediately I can think of implementing this feat by including ground tiles conditional to a flag being true, or false:

```lua
local isChasm = math.random(8) == 1
if not isChasm then
  -- include ground tiles and pillars
end
```

Without specific update to the grid, the column would be filled entirely with sky tiles.

The lecturer actually uses `goto`, to have the loop skip one column. As explained, lua doesn't have a concept of `continue`, so the skip feature is implemented as follows:

- describe where the program should go through the `goto` keyword.

  ```lua
  goto continue
  ```

- specify the destination wrapping the chosen word in between two sets of `:` colons.

  ```lua
  ::continue::
  ```

`continue` is just by convention, but the destination can be described by any arbitrary string.