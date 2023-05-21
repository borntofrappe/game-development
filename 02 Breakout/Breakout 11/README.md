# Breakout 11

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## High score data

The idea is to store the data for the high scores in a `.lst` file, devoting two lines for each high score.

```lst
name
score
name
score
name
score
```

One line for the name of the player, one for actual score.

When reading the data, the goal is to then produce a table, where each item collects a high score.

```lua
highscores = {
  [1] = {
    name,
    score
  },
  [2] = {
    name,
    score
  }
}
```

## loadHighScores

In `main.lua`, `loadHighScores` makes use of several functions from the [love.filesystem](https://love2d.org/wiki/love.filesystem) module.

Immediately, set the current folder to one "breakout". If one does not exist, love2d will produce one in the path specified by the wiki.

```lua
love.filesystem.setIdentity('breakout')
```

In this directory, check if a `.lst` file exist, so to make up placeholder data if one is not present.

```lua
if not love.filesystem.getInfo('highscores.lst') then
  -- ...
end
```

In the body of the if statement the idea is to create a string separating names and a decreasing number of points. Each name and each score is separated by a new line character to match the structure described above.

With this string, create a `.lst` file with the relevant information and with `love.filesystem.write()`.

```lua
love.filesystem.write("highscores.lst", stringData)
```

Following the logic of the if statement, you are sure to have a `.lst` file with the records. In order to populate a table with the relevant information, `love.filesystem.lines()` provides what is essentially a table of lines, so that you can loop through the strings and extract the name, or again the score.

```lua
for line in love.filesystem.lines('highscores.lst') do
    -- do something
end
```

## HighScoresState

The update adds a state for the high scores, accessible from `StartState` when the variable `choice` describes the second option.

In terms of logic, the state loads the high scores per the `loadHighScores○ function. Press escape or enter you then move back to the start state.

In terms of content, the goal is to iterates through the results to render the name and scores one after the other.

```lua
function HighScoresState:init()
  self.highScores = loadHighScores()
end

function HighScoresState:render()
  for k, highScore in pairs(self.highScores) do
    -- render name and score
  end
end
```

The most challenging part is figuring out the space and alignment of the text.
