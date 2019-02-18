--[[
  enter highscore state

  showing:

  - A
  - A
  - A

  allowing to:
  - select the three letters as to make up a name
  - register a high score
  - go to the high score state

  the state is only shown when a high score is obtained, and modifies the `lst` file including the high score and removing the lowest available score
]]

-- initialize a variable to keep track of the selection between the first, second, third letter
local highlight = 1

-- create a variable describing the characters through the ASCII codes
-- the idea is to add/subtract to this values and show the letter in between A and Z (65 and 90)
local chars = {
  [1] = 65,
  [2] = 65,
  [3] = 65
}

-- inherit from the BaseState class
EnterHighScoreState = Class{__includes = BaseState}

-- in the enter() function create a variable to reference the score passed from the gameover state
function EnterHighScoreState:enter(params)
  self.score = params.score
  self.highScores = params.highScores
  self.scoreIndex = params.scoreIndex
end

-- in the update(dt) function listen on a selection of key presses
function EnterHighScoreState:update(dt)
  -- when registering a click on the enter key, save the name and score in the `lst` file and at the position described by scoreIndex
  -- go then to the high score state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- create a new table to describe the updated list (including the current score)
    newHighScores = {}
    -- loop through the highscore table copying the contents to the new variable
    -- add the new score where needed and follow up with every remaining score in the global table
    -- this effectively means the last score is left out
    for i = 1, #self.highScores do
      if i < self.scoreIndex then
        newHighScores[i] = self.highScores[i]
      elseif i == self.scoreIndex then
        newHighScores[i] = {
          -- name retrieved from the three letters updated in `chars`
          name = tostring(string.char(chars[1])) .. tostring(string.char(chars[2])) .. tostring(string.char(chars[3])),
          score = self.score
        }
      else
        newHighScores[i] = self.highScores[i - 1]
      end
    end

    -- to write the table's values locally, create a string with one line for each name and one line for each score
    local list = ''
    for i = 1, #newHighScores do
      -- for each item add to the string the name and score value
      -- always ending with a new line given the format of the file
      list = list .. tostring(newHighScores[i].name) .. '\n'
      list = list .. tostring(newHighScores[i].score) .. '\n'
    end

    -- write the new table into the `lst` file
    love.filesystem.write('breakout.lst', list)

    -- change the state to the high score screen, to show the new list
    gStateMachine:change('highscore', {
      highScores = newHighScores
    })
    gSounds['confirm']:play()
  end

  -- when registering a click on the left or right arrow, switch highlight to target the previous/following letter
  -- when going left or right past the first or last letter, go to the last or first letter respectively
  if love.keyboard.wasPressed('left') then
    if highlight <= 1 then
      highlight = 3
    else
      highlight = highlight - 1
    end
  end

  if love.keyboard.wasPressed('right') then
    if highlight >= 3 then
      highlight = 1
    else
      highlight = highlight + 1
    end
  end

  -- when registering a click on the up or down arrow, increment/decrement the integer to show the following/preceding letter
  -- in the [65-90] range
  if love.keyboard.wasPressed('down') then
    if chars[highlight] <= 65 then
      chars[highlight] = 90
    else
      chars[highlight] = chars[highlight] - 1
    end
  end

  if love.keyboard.wasPressed('up') then
    if chars[highlight] >= 90 then
      chars[highlight] = 65
    else
      chars[highlight] = chars[highlight] + 1
    end
  end

end

-- in the render() function display three giant letter A side by side
-- wrapped in two strings explaining the state
function EnterHighScoreState:render()
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Name your score',
    0,
    VIRTUAL_HEIGHT / 4 - 16,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['humongous'])
  -- loop through the chars table and render the letters vertically centered, horizontally spaced from one another
  for i = 1, #chars do
    -- if the index matches the selection described by highlight set a different color
    if i == highlight then
      love.graphics.setColor(0.4, 1, 1, 1)
    else
      love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.printf(
      -- convert the integer to letters with string.char()
      string.char(chars[i]),
      0,
      VIRTUAL_HEIGHT / 2 - 28,
      -- horizontally space them by changing the measure dictacting the alignment
      VIRTUAL_WIDTH + (i - 2) * 100,
      'center'
    )
  end

  -- reset the color to white
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    -- 'Press enter to confirm',
    'New high score: ' .. tostring(self.score),
    0,
    VIRTUAL_HEIGHT * 3 / 4 + 8,
    VIRTUAL_WIDTH,
    'center'
  )
end