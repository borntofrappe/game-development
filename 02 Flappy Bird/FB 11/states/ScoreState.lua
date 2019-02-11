-- state showing the score screen

-- inherit from the BaseState class
ScoreState = Class{__includes = BaseState}

-- in the enter function take the score passed through the params object and include it in a variable of the class
function ScoreState:enter(params)
  self.score = params.score
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
    VIRTUAL_HEIGHT / 2 - 48,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(normalFont)
  love.graphics.printf(
    'Press enter to play once more',
    0,
    VIRTUAL_HEIGHT * 3 / 4,
    VIRTUAL_WIDTH,
    'center'
  )

end
