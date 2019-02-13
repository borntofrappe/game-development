-- state showing the paddle

-- inherit from the BaseState class
PlayState = Class{__includes = BaseState}

-- in the init function create an instance of the paddle class
function PlayState:init()
  self.paddle = Paddle{}
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
end

-- in the render function, render the paddle through the connected render function
function PlayState:render()
  self.paddle:render()
end