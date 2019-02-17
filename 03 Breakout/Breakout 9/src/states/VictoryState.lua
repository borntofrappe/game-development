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

-- in the enter function receive the values from the play state
function VictoryState:enter(params)
  self.level = params.level
  self.score = params.score
  self.health = params.health
  self.paddle = params.paddle
end

-- in the update(dt) function listen on a selection of key presses
-- update the paddle as to allow the player some minor interactivity
function VictoryState:update(dt)
  -- when pressing enter go to the serve state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- include the values instantiated on enter and a new level through the level maker class
    gStateMachine:change('serve', {
      level = self.level + 1,
      bricks = LevelMaker.createMap(self.level + 1),
      score = self.score,
      health = self.health,
      paddle = self.paddle
    })
    -- play a sound as the game moves to the start screen
    gSounds['confirm']:play()
  end


  self.paddle:update(dt)

end


-- in the render function display the gameover text atop the score
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