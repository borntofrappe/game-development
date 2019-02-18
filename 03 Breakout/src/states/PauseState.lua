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

-- in the enter() function instantiate the variables received from the play state
function PauseState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.score = params.score
  self.level = params.level
  self.ball = params.ball
  self.highScores = params.highScores
end

-- -- in the update(dt) function listen on a selection of keys
function PauseState:update(dt)
  -- when registering a click on the enter key, go back to the play state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- send back the variables specified on enter
    gStateMachine:change('play', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      maxHealth = self.maxHealth,
      score = self.score,
      level = self.level,
      ball = self.ball,
      highScores = self.highScores
    })
    gSounds['confirm']:play()
  end
end

-- in the render() function, show text describing the pause screen and how to go back to the play state
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