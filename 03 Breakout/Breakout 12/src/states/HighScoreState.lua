--[[
  highscore state

  showing:

  - name
  - score

  of 10 players as store in the local lst file
  available in the gHighScores variable

  allowing to:
  - go back to the start state
]]

-- inherit from the BaseState class
HighScoreState = Class{__includes = BaseState}

-- in the update(dt) function listen on a selection of key presses
function HighScoreState:update(dt)
  -- when pressing enter or escale go back to the start state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('escape') then
    gStateMachine:change('start')
    -- play a sound as the game moves to the start screen
    gSounds['confirm']:play()
  end

end

-- in the render function display the players in the high scores table
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
  for i = 1, #gHighScores do
    love.graphics.print(
      tostring(i) .. '.',
      180,
      28 + (i * 24)
    )

    love.graphics.printf(
      tostring(gHighScores[i].name),
      0,
      28 + (i * 24),
      VIRTUAL_WIDTH / 2,
      'right'
    )

    love.graphics.printf(
      tostring(gHighScores[i].score),
      0,
      28 + (i * 24),
      VIRTUAL_WIDTH - 180,
      'right'
    )
  end


end