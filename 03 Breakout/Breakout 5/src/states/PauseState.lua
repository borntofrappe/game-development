--[[
  pause state

  showing:

  - pause
  - how to proceed

  allowing to:
  - go to the play state
]]

-- inherit from the BaseState class
PauseState = Class{__includes = BaseState}

-- in the enter function instantiate variables from the values received from the play state
function PauseState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.score = params.score
  self.ball = params.ball
end

-- -- in the update function listen for a selection of keys
function PauseState:update(dt)
  -- listen for a key press on the enter key, at which point go back to the play state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- send back the variables specified on enter
    gStateMachine:change('play', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      score = self.score,
      ball = self.ball
    })
    -- play a sound as the game moves to the play screen
    gSounds['confirm']:play()
  end

end

-- in the render function, show text describing the pause screen and how to go back playing
function PauseState:render()
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Pause',
    0,
    VIRTUAL_HEIGHT / 3,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['normal'])
  love.graphics.printf(
    'Press enter to resume playing',
    0,
    VIRTUAL_HEIGHT / 2 - 8,
    VIRTUAL_WIDTH,
    'center'
  )

end