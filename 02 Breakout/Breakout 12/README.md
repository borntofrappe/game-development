# Breakout 12

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Score

To help with the development of the feature, the score is initialized with a big enough value to make sure a high score is registered. The health is also reduced to ensure a gameover happens more rapidly.

```lua
function ServeState:init()
  self.score = 50000
  self.health = 1
end
```

## Gameover

The feature begins in the gameover state. Here, load the high scores in the `init` function.

```lua
function GameoverState:init()
  self.highScores = loadHighScores()
end
```

To detect a high score, I decided to define a variable for the index, and use a controlled value of `-1`.

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

With this setup, once you leave the gameover state by pressing enter, check the value of the index. If this is still `-1`, move to the start state. Else, move to the enter state to actually record the score.

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

## EnterHihScore

The state is responsible for saving the score, but first, it is tasked to consider the player name.

### Score name

The approach is similar to the one allowing to choose between _start_ and _high scores_ in the first screen:

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

To update the letter, consider the values in the `[65, 90]` range.

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

- use the previous value for the scores which follow the new score

  ```lua
  else
    newHighScores[k] = highScores[k - 1]
  ```

Following the loop, `newHighScores` includes the scores in the new order. Writing the scores in the `lst` file is a matter of repeating the process introduced in the previous update.

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
