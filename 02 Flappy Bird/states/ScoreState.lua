-- state showing the score screen

-- inherit from the BaseState class
ScoreState = Class{__includes = BaseState}

-- in the enter function take the score passed through the params object and include it in a variable of the class
-- consider also the image representing the score
function ScoreState:enter(params)
  self.score = params.score
  self.image = params.image
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
      self.image,
      VIRTUAL_WIDTH / 2 - 10,
      VIRTUAL_HEIGHT / 2 - self.image:getHeight() / 2) -- offsetting for the height of the image

    love.graphics.setFont(normalFont)
    love.graphics.print(
      'x' .. tostring(math.floor(self.score / 5)),
      VIRTUAL_WIDTH / 2 + 10,
      VIRTUAL_HEIGHT / 2 - 8) -- offsetting for the heifht of the font
  end


  love.graphics.setFont(normalFont)
  love.graphics.printf(
    'Press enter to play once more',
    0,
    VIRTUAL_HEIGHT * 3 / 4,
    VIRTUAL_WIDTH,
    'center'
  )

end
