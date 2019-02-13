-- state showing the paddle

-- inherit from the BaseState class
PlayState = Class{__includes = BaseState}

-- in the enter function create an instance of the paddle and if a parameter is passed to the state, specify its horizontal coordinate
function PlayState:enter(params)
  self.paddle = Paddle{}
  if(params) then
    self.paddle.x = params.x
  end
end

-- -- in the update function update the paddle and listen for a selection of keys
function PlayState:update(dt)
  -- update the paddle through the connected update function
  self.paddle:update(dt)

  -- listen for a key press on the escape key, at which point go back to the play screen
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('start')
    -- play a sound as the game moves back toward the start screen
    gSounds['confirm']:play()
  end

  -- listen for a key press on the enter key, at which point go to the pause state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- transition to the play state sending the horizontal coordinate, as to have the value persist between states
    gStateMachine:change('pause', {
      x = self.paddle.x
    })
    -- play a sound as the game moves to the pause screen
    gSounds['select']:play()
  end

end

-- in the render function, render the paddle through the connected render function
function PlayState:render()
  self.paddle:render()
end