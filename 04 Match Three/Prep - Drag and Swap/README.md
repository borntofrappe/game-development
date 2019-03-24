# Drag and Swap - A Feature Study

In the _Prep_ folder labeled _Drag and Swap_, you find an application displaying a grid of 9 tiles, centered in a fixed-width container. The goal of this smaller application is straigthforward:

- click on a tile to select it;

- drag from the tile to an adjacent one to have the two effectively swapped.

<!-- Easier said than done -->

Here's how the feature is achieved.

## Select Tile

- just like in Flappy Bird, store the mouse coordinates in a table.

  ```lua
  cursor = {
    x = 0,
    y = 0
  }
  ```

- in addition to the table, include a variable to describe whether the cursor is down on the screen.

  ```lua
  cursorDown = false
  ```

- in `love.update(dt)` update the mouse coordinates through the `getX` and `getY` functions, and most importantly conditional to the `cursorDown` boolean being true.

  ```lua
  function love.update(dt)
    if cursorDown then
        cursor.x = love.mouse.getX()
        cursor.y = love.mouse.getY()
    end
  end
  ```

  With the current setup the coordinates are never updated, so the next step is toggling the `cursorDown` boolean between true and false.

- following the `mousepressed()` method, switch the boolean to true when the primary button is registered on the screen.

  ```lua
  function love.mousepressed(x, y, button)
    if button == 1 then
      cursorDown = true
    end
  end
  ```

- following the `mousereleased()` method, switch the boolean back to false.

  ```lua
  function love.mousereleased(x, y, button)
    cursorDown = false
  end
  ```

This allows to have the mouse coordinates updated as long as the cursor is down on the screen. It is important to highglith how the values are retained following `mousereleased`, they maintain the last updated value. This is relevant in the context of using the coordinates to determine the tile currently being selected (in other words: make sure to un-select the tiles when the cursor is no longer down on the screen).

With this setup, the table stores a reference to values updated as long as the cursor is down. Move the cursor and the values are changed to match the new position.

In the `Tile` class, the updated values can be used to detect a collision, an overlap between the cursor and the tiles. When such an overlap occurs, an overlay is displayed atop the tile through a boolean.

```lua
-- initialization
Tile = {
  x = 0,
  y = 0,
  size = TILE_SIZE,
  color = {
    r = 1,
    g = 1,
    b = 1
  },
  -- boolean describing whether the tile has been selected
  isSelected = false -- new
}

-- Tile:update(dt)
-- detect collision
-- in the update function check if the cursor overlaps with the tile
function Tile:update(dt)

  -- if not already sleected
  if not self.isSelected then
    -- overlap
    if cursor.x > self.x and cursor.x < self.x + self.size then
      if cursor.y > self.y and cursor.y < self.y + self.size then
      -- switch to true
        self.isSelected = true
      end -- cursor.y end
    end -- cursor.x end
  end -- not isSelected end

end -- Tile:update() end

-- Tile:render()
-- show the tile through a square
function Tile:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)

  -- overlay if the tile is selected
  if self.isSelected then -- new
    love.graphics.setLineWidth(10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', self.x + 5, self.y + 5, self.size -10, self.size -10)
  end
end
```

This allows to have the overlay fittingly describe the selected tile. However, two major issues stand in the way of completing the feature:

- tiles are never un-selected;

- no swap occurs.

To achieve both features I worked in `Main.lua`, leaving the `Tile.lua` unaffected.

### Unselect Tile

Immediately, the `isSelected` flag is switched to `false` following the `mousereleased()` function.

```lua
for k, row in pairs(tiles) do
  for t, tile in pairs(row) do
    tile.isSelected = false
  end
end
```

In `love.update(dt)`, the flag is also switched to false when the cursor moves from one tile to another, to make sure that there is only 1 selected tile at a time. The logic is actually married to the swapping feature, explained immediately.

## Swap Tiles

To swap the tiles, I decide to include another variable in `love.load`, in `selectedTile`.

```lua
selectedTile = nil
```

By default, it is set to `nil`, but the idea is to have the variable refer to the tile selected through the cursor.

In `love.update(dt)`, and if the variable is still set to `nil`, include in the variable any tile with the flag of `isSelected` set to `true`.

```lua
if cursorDown then
  cursor.x = love.mouse.getX()
  cursor.y = love.mouse.getY()

  -- update the tiles
  for k, row in pairs(tiles) do
    for t, tile in pairs(row) do
      tile:update(dt)

      if tile.isSelected then
        if not selectedTile then
          selectedTile = tile
        end

      end -- tile.isSelected end
    end -- tile for loop end
  end -- row for loop end
end -- cursorDown end
```

Notice how the logic is wrapped in the conditional checking the `cursorDown` boolean.

On its own this seems like an excessive detour, but the variable and the setup makes sense in light of another conditional, comparing the tile with the flag of `isSelected` and the tile described in `selectedTile`. If the two differ, it means the cursor has moved to another tile, and it is time to swap the two.

```lua
if cursorDown then
  cursor.x = love.mouse.getX()
  cursor.y = love.mouse.getY()

  -- update the tiles
  for k, row in pairs(tiles) do
    for t, tile in pairs(row) do
      tile:update(dt)

      if tile.isSelected then
        if not selectedTile then
          selectedTile = tile

        -- compare the selected tiles
        elseif selectedTile ~= tile then
          -- SWAP HERE
          tile.isSelected = false
        end -- evaluating selectedTile end

      end -- tile.isSelected end
    end -- tile for loop end
  end -- row for loop end
end -- cursorDown end
```

Notice the use of the `~` tilde character, to check for inequality through the `~=` operator. Notice also how the tile evaluated to have the `isSelected` to true changes the boolean's value. This, as mentioned in the earlier paragraph, is to ensure that only 1 tile is selected at a time. Which tile is unselected though? Following the swap, it is actually the tile described by `selectedTile`, which achieves the expected result of unselecting the older selection between the two.

For the actual swap, I decided to create a separate function, in `swapTiles()`. This accepts the tiles being swapped, such that the `love.update()` function is completed as follows.

```lua
-- update the coordinates as long as the mouse is down on the screen
if cursorDown then
  cursor.x = love.mouse.getX()
  cursor.y = love.mouse.getY()

  -- update the tiles
  for k, row in pairs(tiles) do
    for t, tile in pairs(row) do
      tile:update(dt)

      if tile.isSelected then
        if not selectedTile then
          selectedTile = tile

        elseif selectedTile ~= tile then
          swapTiles(selectedTile, tile) -- function call
          tile.isSelected = false

        end -- evaluating selectedTile end
      end -- tile.isSelected end
    end -- tile for loop end
  end -- row for loop end
end -- cursorDown end
```

The function swaps the tiles it receives as argument both in the grid and both in terms of their `x` and `y` coordinates.

```lua
-- function swapping two tiles
function swapTiles(tile1, tile2)
  tile1, tile2 = tile2, tile1
  tile1.x, tile2.x = tile2.x, tile1.x
  tile1.y, tile2.y = tile2.y, tile1.y
end
```

Which completes the feature study. Click to select, drag to swap.
