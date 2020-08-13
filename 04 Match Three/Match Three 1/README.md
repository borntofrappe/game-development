Detect a match of three or more shapes.

## updateMatches

The idea is to loop through the board, consider the color of adjacent tiles and detect a match if a counter variable describes a value greater than the pre-established `3`.

The logic is implemented in the current update and in the `Board:updateMatches()` function:

- initialize a table in which to store the matches, plural

  ```lua
  local matches = {}
  ```

- loop through the rows

  ```lua
  for y = 1, self.rows do

  end
  ```

- initialize a counter variable, as well as a variable to keep track of the color of the previous cell

  ```lua
  local color = self.tiles[y][1].color
  local colorMatches = 1
  ```

- loop through the remaining cells in the row and check for a possible match

  ```lua
  for x = 2, self.columns do
    if color == self.tiles[y][x].color then
    else
    end
  end
  ```

  Depending on the condition:

  - if there is a match increase the counter variable

    ```lua
    if color == self.tiles[y][x].color then
      colorMatches = colorMatches + 1
    end
    ```

  - if the two don't match, reset the controlling values

    ```lua
    else
      color = self.tiles[y][x].color
      colorMatches = 1
    end
    ```

    Before restting the values, however, check if the number of matches exceeds the desired three. In this case, add to `matches` a table describing the adjacent tiles.

    ```lua
    if colorMatches >= 3 then
      local match = {}
      for x2 = x - 1, x - colorMatches, -1 do
        table.insert(match, self.tiles[y][x2])
      end
      table.insert(matches, match)
    end
    ```

    When a color is different in the last two columns, a match of three is no longer possible. This means you can optimize the code by pre-emptively exit the loop.

    ```lua
    if y > self.rows - 2 then
      break
    end
    ```

- the loop works to consider a match, but not if the match ends on the very last column.

  In this situation `colorMatches` describe a value greater than or equal to three, but there is no chance to register the tiles.

  To fix this, add a conditional to check for matches out of the loop.

  ```lua
  if colorMatches >= 3 then

  end
  ```

This is a rather lenghtly process, but repeated for the columns, it allows to have `matches` describe a series of tables with the available matches.

## render

This is ultimately not included in the game, but to test the functionality of the `updateMatches` function, `Board:render` includes a nested for loop to print out the coordinates of the matches.
