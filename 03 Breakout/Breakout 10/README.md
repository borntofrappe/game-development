# Breakout 10 - High Scores

Together with the particle system update, the high score update ranks high in terms of novelty and difficulty. We need to write, update, read a local file and Love2D provides a series of functions in the `love.filesystem` module to achieves just that.

By default, love2D looks for files in a fixed directory, where it has access. Based on this directory you can:

- use `love.filesystem.exist(path)` to check if a certain folder exist;

- use `love.filesystem.write(path, data)` to write to a specific location;

- use `love.filesystem.lines(path)` to iterate through a file. This to ultimately read the data stored in the file.

In love2D, the high scores can be stored in a table, much alike the color palette for the particle system. Locally however, the list needs to be converted into string values, and the approach taken by the lecturer is to store the names and scores each in a new line.

```text
name
score
name
score
...
```

## main.lua

Create a function which loads the high scores from a `breakout` folder. If a file in this folder doesn't exist, create one with a set number of scores.

```lua
function loadHighScores()
  -- consider an arbitrary folder
  love.filesystem.setIdentity('breakout')

  -- check if the folder does not contain a list of results
  if not love.filesystem.getInfo('breakout.lst') then
    -- create a list with a series of entries
    local highScores = ''
    -- the list is structured with a new line for each name and new line for each score
    for i = 10, 1, -1 do
      highScores = highScores .. 'GAB\n'
      highScores = highScores .. tostring(5000 + 1250 * i) .. '\n'
    end

    -- write the string to a local file
    love.filesystem.write('breakout.lst', highScores)

  end
end
```

A few notes on the snippet:

- a for loop can specify three values, in which case it functions much alike JavaScript.

  ```text
  for beginning, end, step do

  end
  ```

- `love.filesystem.exist` is deprecated in favor of `love.filesystem.getInfo`. This method allows to detail a file according certain filters, but with one argument it allows for the same feat.

- the lecturer uses a `lst` file extension, but a `txt` is valid as well. Perhaps such a format is to avoid immediate tampering, but most likely it is because `lst` files typically structure their content through [line breaks](https://fileinfo.com/extension/lst).

Following the conditional, it is certain that a `breakout.lst` file is available, either because existing or just created. Based on this file, the function reads the contents, creates a table with the high scores and returns this table.

The way the lecturer creates a table from the `lst` file is rather inspired, and provides quite the helpful logic in terms of learning lua, so I'll describe it here thoroughly.

- create an empty table in which to store the information;

  ```lua
  highScores = {}
  ```

- create a counter variable, used to add the high scores in order and one at a time

  ```lua
  highScores = {}
  counter = 1
  ```

- create a boolean to toggle between `name` and `score`. The idea is to go through each line of the `lst` file, read the name and set the boolean to false. In the loop, this guarantees that the next iteration will read the score, and setting the boolean back to true it ensures the loop continues to consider names and scores in order. One line at a time.

  ```lua
  highScores = {}
  counter = 1
  isName = true
  ```

- fill the table with 10 empty smaller tables, initializing the name and score to null values.

  ```lua
  highScores = {}
  counter = 1
  isName = true

  for i = 1, 10 do
    highScores[i] = {
      name = nil,
      score = nil
    }
  end
  ```

  Notice how the loop runs 10 times and starting from 1. This to later have access to the scores and immediately list them by index (from player #1 name and score to player #10).

- loop through the `lst` file and using the counter variable consider one row at a time.

  ```lua
  for line in love.filesystem.lines('breakout.lst') do

  end
  ```

- one row at a time, add in the table the name and the score using the `isName` flag, alternating it every row.

  ```lua
  for line in love.filesystem.lines('breakout.lst') do
    if isName then
      highScores[counter].name = string.sub(line, 1,3)
    else
      highScores[counter].score = tonumber(line)
      counter = counter + 1
    end

    isName = not isName
  end
  ```

  At every iteration `isName` is switched to its opposite value, accessing alternatively the name and score. When adding the score, `counter` is incremented, targeting the following set of name + score.

  Notice `string.sub`, a function which takes as argument the string to be shortened, as well as where the substring ought to begin and end.

  Notice `tonumber`, to force the string values of the players' scores into numbers.

After all this logic (creating an `lst` file if not available and creating a table out of the `lst` file), the function returns the very table containing the relevant information.

We have now available a table structured as follows:

```text
hihghScores = {
  [1] = {
    name,
    score
  },
  [2] = {
    name,
    score
  }
  // and so forth for 10 players
}
```

The lecturer doesn't specify how the table is later used, but by looking at the [repo](https://github.com/games50/breakout/blob/master/breakout10/main.lua), it seems the value is passed to the pertinent state through the second argument of the `StateMachine:change()` function. This presumably to show the high score state as soon as the game gets loaded.

I prefer to create a global variable in `gHighScores`, in the `:load` function of `main`. Once created:

```lua
gHighScores = loadHighScores()
```

It is possible to use it anywhere in the application. Especially in the `HighScore.lua` created exactly to show the contents of the table.

## HighScore.lua

In this state, which can be reached from the `StartState`, all is necessary is displaying the high scores one row at a time. By using the `print` and `printf` function it is possible to align the text in a rather understandable table.

Beside the `render()` function, the state needs to also specify the `update(dt)` function as to listen for a key press on a series of keys. From the high score state, the intent is to go back to the start state.

## StartState

The start state is responsible to trigger the serve or high score state, but currently calls only the first one.

Luckily, the split between the two hinges on the selection made on the home screen, which is already available through the `highlight` variable.

Upon pressin enter, it is possible to check this value and respectively call the serve or high score state.

```lua
if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

  if highlight == 1 then
    gStateMachine:change('serve', {
      -- necessary information
    })
  else
    gStateMachine:change('highscore')
  end

end

```
