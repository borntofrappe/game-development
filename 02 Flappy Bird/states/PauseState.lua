-- state showing the pause screen
-- showing text describing the state of the game

-- inherit from the BaseState class
PauseState = Class{__includes = BaseState}

-- in the enter function consider the values passed through the play state, to make them persist
function PauseState:enter(params)
  self.score = params.score
  self.bird = params.bird
  self.pipePairs = params.pipePairs
  self.timer = params.timer
  self.interval = params.interval
  self.lastY = params.lastY
  self.isLow = params.isLow
  self.isHigh = params.isHigh
  self.hasJumpedSixtyTimes = params.hasJumpedSixtyTimes
end

-- in the update(dt) function listen for a press on the enter key
-- if so call the global state machine variable to change the state to the play state
-- include in the second argument the values retrieved from the play state to have the game resumed from the previous point
function PauseState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- resume the soundtrack
    sounds['soundtrack']:play()

    gStateMachine:change('play', {
      score = self.score,
      bird = self.bird,
      pipePairs = self.pipePairs,
      timer = self.timer,
      interval = self.interval,
      lastY = self.lastY,
      isLow = self.isLow,
      isHigh = self.isHigh,
      hasJumpedSixtyTimes = self.hasJumpedSixtyTimes
    })
  end
end

-- in the render function, describe how the game is paused and the score
function PauseState:render()
  love.graphics.setFont(bigFont)
  love.graphics.printf(
    'Pause',
    0,
    VIRTUAL_HEIGHT / 3 - 48,
    VIRTUAL_WIDTH,
    'center'
  )

  -- create a pause icon out of rectangle elements
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setLineWidth(7)
  love.graphics.rectangle(
    'line',
    VIRTUAL_WIDTH / 2 - 30,
    VIRTUAL_HEIGHT / 2 - 30,
    60,
    60
  )

  love.graphics.rectangle(
    'fill',
    VIRTUAL_WIDTH / 2 - 15,
    VIRTUAL_HEIGHT / 2 - 15,
    10,
    30
  )

  love.graphics.rectangle(
    'fill',
    VIRTUAL_WIDTH / 2 + 5,
    VIRTUAL_HEIGHT / 2 - 15,
    10,
    30
  )


  love.graphics.setFont(normalFont)
  love.graphics.printf(
    'Current score: ' .. tostring(self.score),
    0,
    VIRTUAL_HEIGHT * 3 / 4 - 4,
    VIRTUAL_WIDTH,
    'center'
  )

end
