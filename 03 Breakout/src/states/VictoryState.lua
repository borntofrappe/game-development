--[[
  victory state

  showing:

  - victory
  - level
  - score
  - hearts

  allowing to:
  - go to the serve state (with a new level)
]]

-- inherit from the BaseState class
VictoryState = Class{__includes = BaseState}

-- in the enter() function receive the values from the play state
function VictoryState:enter(params)
  self.level = params.level
  self.score = params.score
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.paddle = params.paddle
  self.highScores = params.highScores
end

-- in the update(dt) function listen on a selection of key presses
function VictoryState:update(dt)
  -- when registering a click on the enter key, go to the serve state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- include the values instantiated on enter and a new level through the level maker class
    gStateMachine:change('serve', {
      level = self.level + 1,
      bricks = LevelMaker.createMap(self.level + 1),
      score = self.score,
      health = self.health,
      maxHealth = self.maxHealth,
      paddle = self.paddle,
      highScores = self.highScores
    })
    gSounds['confirm']:play()
  end

  -- update the position of the paddle to add some minor interactivity
  self.paddle:update(dt)
end


-- in the render() function display the level being completed and how to proceed
-- show also the paddle
function VictoryState:render()
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'LEVEL ' .. tostring(self.level) .. ' COMPLETE',
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
    'Press enter to play the next level',
    0,
    VIRTUAL_HEIGHT * 3 / 4,
    VIRTUAL_WIDTH,
    'center'
  )

  self.paddle:render()
end