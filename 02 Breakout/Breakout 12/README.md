# Breakout 12

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

_Please note:_ the serve state is initialized with a considerably large high score and one health point, to ensure that the game ends early and with a high score.

```lua
function ServeState:init()
  self.score = 50000
  self.health = 1
end
```

## Record high score

The update allows to record a high score past the game over state.

In this instance load the high scores in the `init` function.

```lua
function GameoverState:init()
  self.highScores = loadHighScores()
end
```

To find if the number of points ranks up to a high score, I decided to define a variable for the index, and use a controlled value of `-1`.

```lua
function GameoverState:enter(params)
  self.score = params.score
  self.index = -1
end
```

The idea is to loop through the table, and change the index if the score exceeds the table-d measure.

```lua
for k, highScore in pairs(self.highScores) do
  if self.score >= highScore.score then
    self.index = k
    break
  end
end
```

With this setup, once you leave the gameover state by pressing enter, check the value of the index. If this is still `-1`, move to the start state. Else, move to `EnterHighScoreState` to actually record the score.

```lua
if self.index == -1 then
  gStateMachine:change('start')
else
  gStateMachine:change('enterhighscore', {
    highScores = self.highScores,
    score = self.score,
    index = self.index
  })
end
```

## EnterHighScore

The state is responsible for saving the score, but first, it is tasked to consider the player's name.

### Score name

The approach is similar to the one allowing to choose between "start" and "high scores" in the first screen:

- show three options side by side. In this instance, three letter `A`

- create a variable to control a specific option

- update the variable when pressing the arrow keys

The only difference with respect to the introductory menu is that the choice is between three options, and each option represents the ASCII code for a letter in the alpabeth

```lua
function EnterHighScoreState:init()
  self.choice = 1
  self.chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
  }
end
```

To write the actual letter, use the `string` library and the `char` function

```lua
function EnterHighScoreState:render()
  for k, char in pairs(self.chars) do
    love.graphics.printf(
      string.char(char),
      --..
    )
  end
end
```

To update the letter, consider the values in the [65, 90] range.

### newHighScores

By pressing enter, the game registers the new score at the specified index. It does so by creating a new table, and then comparing the index against the existing keys.

```lua
newHighScores = {}
for k, highScore in pairs(self.highScores) do
  if k < self.index then
    --
  elseif k == self.index then
    --
  else
    --
end
```

The idea is to:

- use the existing value for the scores preceding the new one

  ```lua
  if k < self.index then
    newHighScores[k] = highScore
  ```

- use the current score when the index matches

  ```lua
  elseif k == self.index then
    newHighScores[k] = {
      name = name,
      score = self.score
    }
  ```

  For the name concatenate the characters from `self.chars`.

  ```lua
  name = ""
  for k, char in pairs(self.chars) do
    name = name .. string.char(char)
  end
  ```

- use the previous value for the scores which follow the new score

  ```lua
  else
    newHighScores[k] = self.highScores[k - 1]
  ```

Following the loop, `newHighScores` includes the scores in the new order. Writing the scores in the `lst` file is a matter of repeating the process introduced in `main.lua` with the `loadHighScores` function.

- create a string

  ```lua
  highScores = ''
  ```

- loop through the table

  ```lua
  for k, highScore in pairs(newHighScores) do
  end
  ```

- append the name and score, each in a new line

  ```lua
  for k, highScore in pairs(newHighScores) do
    highScores = highScores .. highScore.name .. '\n'
    highScores = highScores .. highScore.score .. '\n'
  end
  ```

- write locally skipping the last new line character

  ```lua
  love.filesystem.write('highscores.lst', string.sub(highScores, 1, #highScores - 1))
  ```

As you record the high score, finally, move the game to `HighScoresState` so that it is possible to find the number of points and name registered in the new spot.
