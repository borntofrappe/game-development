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
end

-- in the update(dt) function listen for a press on the enter key
-- if so call the global state machine variable to change the state to the play state
-- include in the second argument the values retrieved from the play state to have the game resumed from the previous point
function PauseState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play', {
      score = self.score,
      bird = self.bird,
      pipePairs = self.pipePairs,
      timer = self.timer,
      interval = self.interval,
      lastY = self.lastY
    })
  end
end

-- in the render function, describe how the game is paused and how to resume the game
function PauseState:render()
  love.graphics.setFont(bigFont)
  love.graphics.printf(
    'Pause',
    0,
    VIRTUAL_HEIGHT / 3 - 24,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(normalFont)
  love.graphics.printf(
    'Press enter to resume playing',
    0,
    VIRTUAL_HEIGHT / 2 - 8,
    VIRTUAL_WIDTH,
    'center'
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
