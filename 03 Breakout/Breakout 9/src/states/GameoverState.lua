--[[
  gameover state

  showing:

  - gameover
  - score
  - how to proceed

  allowing to:
  - go to the start state
  - quit
]]

-- inherit from the BaseState class
GameoverState = Class{__includes = BaseState}

-- in the enter function instantiate self.score with the score received from the play state
function GameoverState:enter(params)
  self.score = params.score
end

-- in the update(dt) function listen on a selection of key presses
function GameoverState:update(dt)
  -- when pressing enter go back to the start state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('start')
    -- play a sound as the game moves to the start screen
    gSounds['confirm']:play()
  end

  -- when pressing escape quit the game
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end


-- in the render function display the gameover text atop the score
function GameoverState:render()
  love.graphics.setFont(gFonts['humongous'])
  love.graphics.printf(
    'GAME OVER',
    0,
    VIRTUAL_HEIGHT / 3 - 28,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Score: ' .. tostring(self.score),
    0,
    VIRTUAL_HEIGHT / 2 - 8,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['normal'])
  love.graphics.printf(
    'Press enter to play again',
    0,
    VIRTUAL_HEIGHT * 3 / 4,
    VIRTUAL_WIDTH,
    'center'
  )
end