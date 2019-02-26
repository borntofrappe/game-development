# Match Three 1 - Calculating Matches

With the swap feature implemented, it is a matter of recognizing a match: when three or more tiles of the same color are side by side.

The algorithm presented in the lecture is simple, yet effective:

- analyse the grid row by row;

- for each row, consider the color of the first tile;

- considering the color of the tile which follow, check if the two match;

- if the two match, increase a variable counting the number the matching colors;

- if the two don't match, reset the counter variable. Additionally, check if the counter is greater than or equal than three, in which case a match is found. In this instance, store all tiles with the same color in a dedicated table.

- repeat the operation for all rows;

- repeat the entire process analysing the grid column by column.

At the end of this lengthy process the table describes the tiles making up matches, if any. It is then possible to use said table to implement the games' features, like clearing the matching tiles and increasing the score.

## calculateMatches()

The code describes the approach much better than the list introduced earlier, so I'll go through the function step by step.

- define a table in which to store the matches and loop through the rows, initializing a variable referring to the first color.

  ```lua
  local matches = {}
  -- loop through the rows
  for y = 1, 8 do
    -- initialize a variable describing the current color
    local colorToMatch = self.tiles[y][1].color
  end
  ```

- initialize a counter variable and loop through each tile in the row.

  ```lua
  -- loop through the rows
  for y = 1, 8 do
    -- initialize a variable describing the current color
    local colorToMatch = self.tiles[y][1].color

    -- initialize the counter to keep track of the matching color
    colorMatches = 1

    -- consider every tile following the first one
    for x = 2, 8 do

    end
  end
  ```

- consider if the color of each successive tile matches the defined color. If so, increase the counter variable. Else, handle a mismatch, updating the variable identifying the color with the new value.

```lua
-- loop through the rows
for y = 1, 8 do
  -- initialize a variable describing the current color
  local colorToMatch = self.tiles[y][1].color

  -- initialize the counter to keep track of the matching color
  colorMatches = 1

  -- consider every tile following the first one
  for x = 2, 8 do
    -- increment the counter if the colorToMatch matches the color of the newly identified tile
    if self.tiles[y][x].color == colorToMatch then
      colorMatches = colorMatches + 1
    else
      -- set colorToMatch to the color of the new tile
      colorToMatch = self.tiles[y][x].color
      -- CHECK COUNTER


    end

  end
end
```

The `else` satement` is slightly more complex, so I'll go through it separately.

Before resetting the counter back to 1, consider if the variable describes a match greater than or equal to 3. In this instance, a match is found (3 or more adjacent tiles have the same color), and the approach is to take all the tiles tallying up the counter and store them in a table.

```lua
-- check if colorMatches is greater than or equal to 3
if colorMatches >= 3 then
  -- include the tiles with the matching color in a table describing matches
  local match = {}
  -- ! the color is described by the tiles **preceding** the one with the different color
  for x2 = x - 1, x - colorMatches, -1 do
    table.insert(match, self.tiles[y][x2])
  end

  -- add the match table to the overarching table of matches
  table.insert(matches, match)
end
```

Here we create a table, loop backwards from the last tile recored with the matching color until the first tile examined by `colorMatches`. We insert each tile in a `match` table which is itself placed inside the `matches` table.

Following the conditional handling 3 or more matches, the code resets `colorMatches` to 1, to have it start back with the new color. Before this reset though, a small optimization is introduced with regards to the last two tiles in each row. Indeed, when `colorMatches` is reset back to 1 and we analyse the last two tiles, it is impossible to find a match. In this instance we an break out of the for loop with `break`.

```lua
-- check if colorMatches is greater than or equal to 3
if colorMatches >= 3 then
  -- handle color matches
end

-- pre emptively go to the following row if there are only two tiles left
if x >= 7 then
  break
end

-- reset colorMatches to 1
colorMatches = 1
```

This covers how to check for matches **inside** the row, but there exist a possibility that a match ends on the last tile. In this instance the match is not identified because, per the conditional statement, a different color is still yet to be found. We check for this occurrence with another conditional before the very end of the for loop.

```lua
for x = 2, 8 do
  -- previous code

  -- check for a match considering tthe last tile in the row
  if colorMatches >= 3 then
    -- add the matching tiles to a local table and add the table to the overarching data structure
    local match = {}
    for x = 8, 8 - colorMatches, -1 do
      table.insert(match, self.tiles[y][x])
    end

    table.insert(matches, match)
  end
end
```

Once the for loop considers all the rows, the same logic is applied to the columns. Instead of looping through `y` first and `x` later, it is necessary to contemplate the tiles vertically. This effectively means swapping the references to `x` and `y` values.

Once the rows and once the columns are all looped through, `matches` holds a table for each match, if any. The `calculateMatches()` function stores a reference to said table in the board, in `self.matches`.

```lua
-- store a reference to the matches in the board
self.matches = matches
```

Finally the function returns either the matches or false, if no match is found (and therefore the matches table is empty).

```lua
-- return the matches, or false if no match is stored in the table
return #self.matches > 0 and self.matches or false
```

Once more, it is a rather complex function, but understandable when broken piece by piece. To check it working, I included a simple string in the top left corner, describing through a boolean whether a match is foun.
