Refactor the way the board is updated, checking for matches until no match is found.

## Issues

With the previous update, the code checks for matches, removes them and updates the board as necessary. Two issues however:

- _as_ the board is updated, there is a possibility that the new tiles create another match. In this instance the code is not equipped to remove the match immediately, and does so only as a n additional swap occurs

- _while_ the board is in the process of being updated, it is still possible to try and swap two tiles. In this situation, the risk is that the player selects/swaps two tiles which do not exist yet.

With this update, I set out to fix both counts.

**Please note**: I've modified the `Tile` class to generate tiles in a limited number of colors. This to facilitate the number of matches.

## updateBoard

The idea is to have a function dedicated to update the board. This function:

- checks if there are matches through the `updateMatches` function

  ```lua
  function Board:updateBoard()
    if self:updateMatches() then

    end
  end
  ```

- removes the matches

  ```lua
  if self:updateMatches() then
    self:removeMatches()
  end
  ```

- updates the tiles to include new instances

  ```lua
  if self:updateMatches() then
    self:removeMatches()
    self:updateTiles()
  end
  ```

  This function was called `updateBoard` in the previous update, and fills the board with new tiles.

- after a certain amount of time, calls itself

  ```lua
  if self:updateMatches() then
    self:removeMatches()
    self:updateTiles()
    Timer.after(
      0.45,
      function()
        self:updateBoard()
      end
    )
  end
  ```

  In this manner, the board is able to consider new matches. If there are none, the conditional makes it possible to exit the function without doing anything.

  The timer is included to cope with the `Timer.tween` animation introduced in the previous functions. Without a delay, the `updateMatches` function tries to access the `color` field of tiles which might not exist, prompting an error.

## isUpdating

The new delay stresses the issue of selecting/swapping tiles when the board is not complete. To avoid such an overlap, the `Board` class introduces a new variable, a boolean, and conditions the logic following a key on the `enter` key to the variable being `true`.

```lua
if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
  if not self.isUpdating then
  end
end
```

`isUpdating` is initialized with a value of `false`.

```lua
function Board:init(rows, columns)
  -- initialize board

  self.isUpdating = false
end
```

In the `updateBoard` function, it is set to `true` _as_ the function identifies a match, and it is reset to its original value of `false` only if there are no more matches.

```lua
function Board:updateBoard()
  if self:updateMatches() then
    self.isUpdating = true
    -- remove, update
  else
    self.isUpdating = false
  end
end
```
