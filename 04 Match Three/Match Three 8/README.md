# Match Three 8 - Board

With the different states of the game set up, minus the `LevelState`, it is time to incorporate the board as developed in updates 1, 2, 3 and 4. The `LevelState` also depends on the score achieved while playing, so it is a good idea to postpone its development once the scoring system is set up. <!-- I could fake scoring reacting to a selection of the key presses though -->

## PlayState.lua

The variables of the game can be incorporated in the play state, where they are needed.

- in the `init()` function initialize variables for the `level`, `score`, `goal` and `time`. By default have the time refer to an arbitrary amount of seconds, and the goal refer to a placeholder amount of points.

- in the `render` function pipe each value in the panel describing the variables.

- when the countdown timer hits zero, pass the score to the `GameoverState`, to have it hihglighted.

This covers the most trivial part of the update, allowing to use variables instead of hard-coded values. To update the variables however, it is necessary to include an instance of the board class. Luckily, the `Board` class has already been developed to manage the logic of the board (have the tile swap, have the matches removed). It is then a matter of joining the logic of the class to the logic of the state.

- in the `init()` function initialize an instance of the `Board` class, positioning the grid through the `offsetX` and `offsetY` values passed in the instantiation of the class;

  ```lua
  self.board = Board(offsetX, offsetY)
  ```

- in the `update(dt)` function update the class through `self.board:update(dt)`. This call is included in the conditional determining whether the game has started, alongside the logic for the countdown timer.

- in the `render()` function draw the boeard through `self.board:render()`.

This allows to include the board, but also poses a few issues:

- the countdown timer updates too often. This has to do with the fact that both `PlayState` and `Board` have a call to `Timer.update()`, and by removing said call from the board, we can have the `PlayState` manage the timers of the transition and graphics.

- updating the score according to the value returned by `calculateMatches()` function does not work. This has to do with the interplay between the `calculateMatches()` and `removeMatches()` functions, and will be cleared in the section dedicated to updating the score.

## Updating the Score

Once the board is rendered and the swapping of tiles managed through the instance of the `Board` class, it is possible to update the score on the basis of the matches, considering the `calculateMatches()` function. Indeed this function not only populates a table with the different matches, but also **returns** said table (the table or false, if no match is found).

In the `update(dt)` logic of the play state it is possible to use this function to therefore draw out the table of matches, and later attribute a score depending on them. Currently, the game gives 50 points per tile,

```lua
-- retrieve the matches from the calculateMatches function
local matches = self.board:calculateMatches()
-- if matches is not an empty table add 50 points to the score for each tile being matched
if matches then
  -- loop through the table of matches
  for k, match in pairs(matches) do
    -- loop through the tiles of each match
    for j, tile in pairs(match) do
      self.score = self.score + 50
    end
  end
end
```

This allows to effectively increase the score, but the code does not work as-is, and that has to do with `removeMatches()`. In `Board.lua()` this function is called immediately after `calculateMatches()`. It loops through the table of matches as to remove them from the grid and them sets the table of matches to `nil`. This means that `matches` as specified in the snippet above does not reflect the actual reality of the game, and always stores a reference to `false`. To fix this issue, it is possible to call `removeMatches()` from the instance of the `Board` class and **after** the matches have influenced the score.

```lua
-- retrieve the matches from the calculateMatches function
local matches = self.board:calculateMatches()
-- if matches is not an empty table add 50 points to the score for each tile being matched
if matches then
  -- loop through the table of matches
  for k, match in pairs(matches) do
    -- loop through the tiles of each match
    for j, tile in pairs(match) do
      self.score = self.score + 50
      -- empty the matches table
      self.board:removeMatches()
    end
  end
end
```

With this logic, the score can be updated to effectively reflect the number of tiles being matched. The logic of a scoring system can be them refined to give additional points depending on the variety of each shape, provide additional time for each match, but this ultimately covers how to include the `Board` in the `PlayState`. It is necessary to be mindful of what is updated where (to avoid overlapping calls to the `Timer` object) and to understand the consequences of the logic included in tboth files. `Board` allows to confine much of the logic for the board of tiles, but `PlayState` is the file ultimately responsible for the state of the game.

## GameoverState.lua

This is rather minor, but the gamover state is modified to accept the score from the play state, and render said value in the center of the screen.
