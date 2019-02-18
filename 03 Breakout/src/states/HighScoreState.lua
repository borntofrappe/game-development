--[[
  highscore state

  showing:

  - name
  - score

  of 10 players as highlighted in the high scores table

  allowing to:
  - go back to the start state
]]

-- inherit from the BaseState class
HighScoreState = Class{__includes = BaseState}

-- in the render() function initialize a variable to receive the high scores table from the sending state (the start state or the enter high score state)
function HighScoreState:enter(params)
  self.highScores = params.highScores
end


-- in the update(dt) function listen on a selection of key presses
function HighScoreState:update(dt)
  -- when registering a click on the enter or escape key, go back to the start state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('escape') then
    gStateMachine:change('start', {
      highScores = self.highScores
    })

    gSounds['confirm']:play()
  end
end

-- in the render() function display the players from the high scores table
function HighScoreState:render()
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'High Scores',
    0,
    10,
    VIRTUAL_WIDTH,
    'center'
  )

  -- display the position, name and score aligning the values within the 512 by 288 screen
  love.graphics.setFont(gFonts['normal'])
  for i = 1, #self.highScores do
    love.graphics.print(
      tostring(i) .. '.',
      180,
      28 + (i * 24)
    )

    love.graphics.printf(
      tostring(self.highScores[i].name),
      0,
      28 + (i * 24),
      VIRTUAL_WIDTH / 2,
      'right'
    )

    love.graphics.printf(
      tostring(self.highScores[i].score),
      0,
      28 + (i * 24),
      VIRTUAL_WIDTH - 180,
      'right'
    )
  end
end