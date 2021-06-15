# Breakout 11

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Data

The idea is to store the data in a `.lst` file, dedicating two lines for each high score.

```lst
name
score
name
score
name
score
```

One line for the player name, one for actual score.

When reading the data, the idea is to then produce a table, where each pairing occupies a key.

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

The relevant interface is the one provided by [love.filesystem](https://love2d.org/wiki/love.filesystem). `loadHighScores` makes use of several functions from this module, in order to:

1. set the current folder

   ```lua
   love.filesystem.setIdentity('breakout')
   ```

2. check if a file already exist

   ```lua
   love.filesystem.getInfo('highscores.lst')
   ```

3. create arbitrary data in case the file doesn't exist

   ```lua
   love.filesystem.write('highscores.lst', highscores)
   ```

4. read from the sure-to-exist file one line at a time

   ```lua
   for line in love.filesystem.lines('highscores.lst') do
     -- do something
   end
   ```

## HighScoresState

In terms of flow, you access the high scores from the start state, when the variable `choice` describes the matching option. By pressing escape or enter you then move back to the start state.

In terms of content, the state loads the high scores as through the `loadHighScores` function, and then iterates through the results to render the name and scores one after the other.

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
