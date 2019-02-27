# Match Three 3 - Update the Board

Once the tiles are set to `nil`, it becomes necessary to update the board, to have the tiles above the matches fall into place. The idea, as mentioned in the previous update, is to loop one column at a time, from the bottom and upwards, shifting tiles when encountering a `nil` value.

## updateBoard()

Walking through the function, the code begins by looping through the different columns and setting up a flag and an initial value for the space. These will be presumably used to find where the space is located in the column.

The code also includes a variable to update the reference to the vertical coordinate in the column.

```lua
-- for every column
for x = 1, 8 do
  -- variables to identify a space and its position in the grid
  local space = false
  local spaceY = 0
  -- variable to consider each tile in the column, starting from the bottom
  local y = 8

  -- CONTINUE HERE

end
```

From these local variables, the lecturer introduces a new type of loop, in a **while** loop. The idea is to continuously run the logic nested in the loop as long as the condition holds true, and the syntax doesn't differ wildly from JavaScript.

```lua
-- until y describes the first row
while y >= 1 do
  -- CONTINUE HERE

  y = y - 1
end
```

Just remember to update the variable to have the condition always and eventually be false. Here loop through the tiles, from the last row (8) until the first (1), one tile at a time.

In the loop, retrieve the tile identified by `x` and `y`, and check the boolean set up in `space`.

```lua
-- identify the current tile
local tile = self.tiles[y][x]

-- check if a space has been found, **before** the current tile
if space then
  -- CONTINUE HERE

end
```

The idea seems to use `space` as a flag, describing whether or not a space has been found. It is set to true when the current tile is equal to `nil`, and switched back to false when a different value, meaning an instance of the `Tile` class is identified.

```lua
-- if a space has been identified consider the current tile
if space then
  -- if the tile is not nil set space to false
  -- a tile has been found
  if tile then
    space = false
  end

-- if the tile is nil set space to false
-- a space has been found
elseif tile == nil then
  space = true
end
```

Considering each conditional more carefully:

- when `space` is set to true, consider if the current tile has been found. This to guarantee that only tiles are moved downwards. Nothing should happen when spaces follow one another.

  ```lua
  -- if space is true

  -- if tile is true
  if tile then
    -- set the tile identifying the space to refer to the instance of the tile class, found with the if statement
    -- spaceY keeps track of the vertical position of the space
    self.tiles[spaceY][x] = tile
    -- update the vertical position of the tile to match the coordinate identified for the space, to have the tile effectively moved in the grid
    tile.gridY = spaceY

    -- set the current tile, which previously described the instance of the class tile, to nil
    -- this because the tile is moved downwards creating a space
    self.tiles[y][x] = nil
    -- modify the vertical coordinate to visually have the tile move downwards
    tile.y = (tile.gridY - 1) * 32 + self.offsetY

    -- set space to false, as a tile has been found
    space = false
    -- update the vertical coordinate to start from where the space has been found
    y = spaceY

    -- reset spaceY back to 0
    -- this identifies the coordinate of a space, and is updated when a space is indeed found
    spaceY = 0

  -- if space is not true
  -- CONTINUE HERE
  end
  ```

  This might help understanding the conditonal: if `space` is true it **does not** mean that the current tile is a space. It means that a space has been found, **before** the current tile.

  In light of this we start to see how the feature is implemented. The idea is to update the position of the newfound tile, in the grid and visually on the screen. This is done much similarly to how the tiles are moved in the sub-folder describing the swap feature, with the only major difference being `spaceY`. The scope of this variable is not clear, but because we have not yet considered the second occurrence in the conditional.

- when `space` is false, consider if the current tile is equal to `nil`.

  ```lua
  -- if space is not true, check if the current tile is nil (meaning a space)
  elseif tile == nil then
    -- set space to true
    -- a space has been found
    space = true

    -- assign the current vertical coordinate to spaceY
    -- ! only if spaceY has not been already initialized
    -- this to have spaceY refer to the first space found on the way up
    if spaceY == 0 then
      spaceY = y
    end

  end
  ```

  In light of this second condition, `spaceY` can be better understood as the vertical position of the **first** space. By default, it is set to `0`. There cannot be a tile with a `y` value of 0, so this default value is used to determine whether a space has been already identified (if 0, no space is found, otherwise it is found and it is described by the value of `spaceY`). After it is set, it is not overwritten by successive spaces. This to guarantee that, were a tile to be found, this tile would be moved downwards and to the location of the first space.

  Based on this, it is clear why in the first conditional statement `y` is assigned the value of `spaceY` and `spaceY` is set back to the default `0`. We want to consider the column from where the first space has been found (a space currently populated by a tile), and start afresh without any existing space.

This covers the logic which allows to update the board. Personally, I chose to call the `updateBoard` function in the function removing the matches, as to update the appearance only when a match is found. Just like with **update 2**, the game will crush after the first match is found, removed and updated, because the table of tile has `nil` values. With the following update the table will be populated once more to fill the table with new tiles, but the current update already shows how to react to the removal of tiles when considering the tiles above a match.
