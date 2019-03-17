-- state showing the score screen

-- inherit from the BaseState class
ScoreState = Class{__includes = BaseState}

-- in the enter function take the score passed through the params object and include it in a variable of the class
-- consider also the image representing the score
function ScoreState:enter(params)
  self.score = params.score
  self.medalPoints = params.medalPoints
  self.isLow = params.isLow
  self.isHigh = params.isHigh
  self.hasJumpedSixtyTimes = params.hasJumpedSixtyTimes
end

-- in the init function set up the images for the badges
function ScoreState:init()
  self.medalLow = love.graphics.newImage('Resources/graphics/medal-low.png')
  self.medalHigh = love.graphics.newImage('Resources/graphics/medal-high.png')
  self.medalJump = love.graphics.newImage('Resources/graphics/medal-jump.png')
end

-- in the update(dt) function listen for a press on the enter key
-- if so call the global state machine variable to change the state to the countdown state
function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end


-- in the render function, display the score of the game and how to play oncce more
function ScoreState:render()
  love.graphics.setFont(bigFont)
  love.graphics.printf(
    'Score: ' .. tostring(self.score),
    0,
    VIRTUAL_HEIGHT / 2 - 64,
    VIRTUAL_WIDTH,
    'center'
  )

  -- in between the score and the instruction add the medal icon with a description of the number of medals collected
  if self.score >= 5 then
    love.graphics.draw(
      self.medalPoints,
      VIRTUAL_WIDTH / 2 - self.medalPoints:getWidth(),
      VIRTUAL_HEIGHT / 2 + self.medalPoints:getHeight() / 2 - 8)

    love.graphics.setFont(normalFont)
    love.graphics.print(
      'x' .. tostring(math.floor(self.score / 5)),
      VIRTUAL_WIDTH / 2 + 5,
      VIRTUAL_HEIGHT / 2 + 8
    )
  end


  -- show the other medals in the bottom of the screen, each in a setion of the width
  love.graphics.setFont(normalFont)
  if self.isHigh then
    love.graphics.draw(
      self.medalHigh,
      8,
      VIRTUAL_HEIGHT - 48
    )
    love.graphics.print(
      'Griffon',
      8 + self.medalHigh:getWidth() + 8,
      VIRTUAL_HEIGHT - 48 + self.medalHigh:getHeight() / 2 - 8
    )
  end


  if self.isLow then
    love.graphics.draw(
      self.medalLow,
      VIRTUAL_WIDTH / 2 - self.medalLow:getWidth() - 16,
      VIRTUAL_HEIGHT - 48
    )
    love.graphics.print(
      'Penguin',
      VIRTUAL_WIDTH / 2 - 8,
      VIRTUAL_HEIGHT - 48 + self.medalLow:getHeight() / 2 - 8
    )
  end


  if self.hasJumpedSixtyTimes then
    love.graphics.draw(
      self.medalJump,
      VIRTUAL_WIDTH - self.medalLow:getWidth() - 72,
      VIRTUAL_HEIGHT - 48
    )
    love.graphics.print(
      'Ostrich',
      VIRTUAL_WIDTH - 64,
      VIRTUAL_HEIGHT - 48 + self.medalLow:getHeight() / 2 - 8
    )
  end


end
