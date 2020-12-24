Update the board to move the tiles in the empty spaces.

## updateBoard

The goal is to chain a function after `removeMatches`, to have the remaining tiles fall in the spaces created by the matches, removed from view with the previous update.

Loop through the columns, and for each column loop through the rows in reverse order. By keeping a reference to the position of the first empty space, the idea is to then swap the first available tile in said position.

The logic is slightly complicated by the fact that a tile might not exist at all, but stepping through the code one line at a time, it should be clear how the code functions.

- start by looping through the columns, to consider one column at a time

  ```lua
  for x = 1, self.columns do

  end
  ```

- initialize a variable to keep track of the position of `nil` values

  ```lua
  for x = 1, self.columns do
    local yNil = nil
  end
  ```

- set up a `while` loop to go from the last to the first row

  ```lua
  local y = self.rows
  while y > 0 do

  end
  ```

  The `while` loop is necessary to have the `y` coordinate change as the board is updated. Once you move the tile to the empty space, you need to move down the column from the swapped position.

Within the `while` loop, the logic changes depending on the value of `yNil`:

- if `yNil` returns true, this is a coordinate. Consider the current tile, and if such a tile exist, move it to the place described by `yNil`

  ```lua
  if yNil then
    if self.tiles[y][x] then
      -- move self.tiles[y][x] to (yNil, x)
    end
  end
  ```

  Remember to update both the coordinate `y` and the table `self.tiles`, so that the structure of the table matches the new order.

  ```lua
  self.tiles[yNil][x].y = yNil
  self.tiles[yNil][x] = self.tiles[y][x]
  self.tiles[y][x] = nil
  ```

  Past this modification, update `y` to loop from `yNil`, the new position of the tile, and `yNil` to make sure that the loop looks for another empty space.

  ```lua
  y = yNil
  yNil = nil
  ```

- if `yNil` returns false — which in lua happens with `nil` or `false` values — there is not a coordinate yet. Consider the current tile, and if the tile is `nil`, update `yNil` with the empty tile's coordinate

  ```lua
  if yNil then
    -- previous code
  else
    if not self.tiles[y][x] then
      yNil = y
    end
  end
  ```

## tween

To animate the movement of the tiles, use `Timer.tween` instead of immediately updating the `y` coordinate.

```lua
-- self.tiles[yNil][x].y = yNil
Timer.tween(
  0.2,
  {
    [self.tiles[yNil][x]] = {y = yNil}
  }
)
```
