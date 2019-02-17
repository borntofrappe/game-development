# Breakout 11 - Enter High Scores

With update 11 a new state is introduced to add a new high score. In the flow of the application, this is shown **after** the game over state, and only if an high score has been achieved.

Taking aside for a moment how to check for the lowest score in the high score table, we first tackle how to allow for user input through the arrow keys.

The goal is to have a screen with three bold `A` letters, the first of which is highlighted like the start or highscore option in the first screen. Based on this interface:

- use the up and down keys to change the specific letter. Alphabetically and one letter at a time.

  ```text
  A
  ↓
  B
  ↓
  C
  ```

- use the left and right keys to move toward the other letters (A -- > A)

  ```text
  A → A → A
  ```

## EnterHighScore.lua

In this new state, we take advantage of the fact that characters can be converted to and from integers, following the ASCII conversion. As we listen for key presses on the keys, we increment/decrement each integer value and render the respective character.

- create a table with the initial characters.

  ```lua
  local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
  }
  ```

- create a variable in which to reference the highligted character (the position of the highlighted character). This similarly to the start state, when selecting between play and high scores.

  ```lua
  local highlight = 1
  ```

- in the `render()` function, include the text explaining the screen and most importantly the three letters represented by the characters. This can be done by looping through the `chars` table and making use of the `string.chars` function (accepting as argument an integer, returning the ASCII character).

  ```lua
  for i = 1, #chars do
    if i == highlight then
      love.graphics.setColor(0.4, 1, 1, 1)
    else
      love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.printf(
      string.char(chars[i]),
      0,
      VIRTUAL_HEIGHT / 2 - 28,
      VIRTUAL_WIDTH + (i - 2) * 100,
      'center'
    )
  end
  ```

  Notice how the color is selected only for the highlighted character. Remember that colors persist after being set, so after the loop include a reset to white.

- in the `update(dt)` function, the meaty section of the update, react to a key press on the arrow keys.

  - left or right key; change here the `highlight` variable, in the [1-3] range;

  - up or down key; change the character in the `chars` table, and specifically the character described by `highlight` in the [65-90] range.

This takes care of letting the player select a three letter name. It is however essential to take this name and register it in the `lst` file. The name is selected as mentioned above, but the score is received from the `GameoverState`. From the `GameoverState` too, the enter state receives also `scoreIndex`, describing the position of the score in the top 10 rankings. As the enter state is dependant on a high score being scored, this value is computed and passed to the state to exactly include the score where needed.

A not-so-small note here: the lecturer includes three variables from the gameover state to the enter state, but my approach considers only two. This is because the highscore table in my game is global, and can be accessed without need of incorporating its value in every `gStateMachine:change()` function describing the game. Just a choice like another one.

Back to the subject at hand: taking the high score, its position in the list as retrieved from the gameover state. Taking the name from the three letter choice, the code needs to include the score in the high score list and write locally to the `lst` file the new list.

A new list in which:

- the new high score is positioned exactly where the index describes;

- every high score following the new value is pushed down a level;

- the last score in the list is removed from consideration, due to the list being fixed at ten scores.

Here's my approach in the `update(dt)` function, reacting to a key press on the enter key:

- create a new table.

  ```lua
  newHighScores = {}
  ```

  This is where the new list of high scores, including the new one, will be created.

- loop through the global list of high scores and populate the new table.

  Populate the table with the same values until reaching the index specified by `indexScore`.

  ```lua
  for i = 1, #gHighScores do
    if i < self.scoreIndex then
      newHighScores[i] = gHighScores[i]
    end
  end
  ```

  When the loop reaches the index, include the new name-score pair.

  ```lua
  elseif i == self.scoreIndex then
    newHighScores[i] = {
      name = tostring(string.char(chars[1])) .. tostring(string.char(chars[2])) .. tostring(string.char(chars[3])),
      score = self.score
    }
  ```

  Following the index, add the values in the global table preceding the index by 1. This means that the previous 5th score (for instance), is now stored as 6th, and so forth and so on.

  ```lua
  else
    newHighScores[i] = gHighScores[i - 1]
  ```

- once the new table of high scores is created, changes the global variable to match.

  ```lua
  gHighScores = newHighScores
  ```

- as the `filesystem.write()` function requires a string, create one mirroring the structure used when creating the `lst` file in the main function.

  ```lua
  local list = ''
  for i = 1, #gHighScores do
    list = list .. tostring(gHighScores[i].name) .. '\n'
    list = list .. tostring(gHighScores[i].score) .. '\n'
  end

  -- write the new table into the `lst` file
  love.filesystem.write('breakout.lst', list)
  ```

  Adding one row for each name, one row for each score.

## GameoverState

The state is responsible for passing to the enter state the score and the score's index in the list. The score is readily available in `self.score`, but the `scoreIndex` value needs to be considered by reading through the `lst` file.

- create a local variable in which to store the index, but also variables to effectively read through the `lst` file.

```lua
-- create a local variable to determine whether the score is higher of any value in the global table of high scores
local isHighScore = false
-- create a variable to only consider the rows with numbers
local isScore = false
-- create a variable to consider each successive score
local counter = 1
-- create a variable in which to store the index of the score in the list
local scoreIndex = 0
```

This similarly to how the list is read in `main.lua`;

- read through the file, and if a high score is not already determined, consider the scores found in this file.

  ```lua
  -- read through the list and update isHighScore and scoreIndex only if necesary
    for line in love.filesystem.lines('breakout.lst') do
      -- run the logic only if the isHighScore flag is set to false
      if not isHighScore then
        -- check only the line containing numbers
        if isScore then
          -- check if the score of the game is higher of the value described by the row
          if self.score >= tonumber(line) then
            isHighScore = true
            scoreIndex = counter
          end

          -- update counter to consider the following score
          counter = counter + 1
        end

        -- always set isScore to the opposite, identifying scores every other round
        isScore = not isScore
      end
    end
  ```

  This ensures that `isHighScore` can be used to either call the enter high score or start state, Moreover, it allows to have the index of the high score, if existing, in the `scoreIndex` variable.

- if a high score is found, call the enter high score state with the required values.

  ```lua
  -- if a high score is found call the enter high score state, passing the score and the position of the score in the list
  if isHighScore then
    gStateMachine:change('enterhighscore', {
      score = self.score,
      scoreIndex = scoreIndex
    })

  -- else call the play state
  else
    gStateMachine:change('start')
  end
  ```

It may be an ineffective approach, but it works and it is rather understandable. It is at least from my perspective.

I might need to read through the codebase once more, but the logic is sound.
