-- state showing the paddle

-- inherit from the BaseState class
PlayState = Class{__includes = BaseState}

-- in the enter function create an instance of the paddle and if a parameter is passed to the state, specify its horizontal coordinate
-- create also an instance of the ball, possibly specified through the enter parameter
-- include the bricks as creted through the level maker, or provided through the pause state
function PlayState:enter(params)
  self.paddle = Paddle{}
  if(params) then
    self.paddle.x = params.paddle.x
  end

  self.ball = Ball(math.random(7))
  if(params) then
    self.ball.x = params.ball.x
    self.ball.y = params.ball.y
    self.ball.dx = params.ball.dx
    self.ball.dy = params.ball.dy
    self.ball.skin = params.ball.skin
  end

  self.bricks = params and params.bricks or LevelMaker.createMap()
end

-- -- in the update function update the paddle, the ball and listen for a selection of keys
function PlayState:update(dt)
  -- update the paddle through the connected update function
  self.paddle:update(dt)

  -- update the ball through the connected function
  self.ball:update(dt)

  -- check for a collision with the paddle and change the vertical coordinate accordingly
  if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - self.ball.height
    self.ball.dy = -self.ball.dy

    gSounds['paddle_hit']:play()
  end

  -- loop through the table of keys and trigger the hit() function if the ball collides with a brick displayed on the screen
  for k, brick in pairs(self.bricks) do
    if brick.inPlay and self.ball:collides(brick) then
      brick:hit()
      -- depending on the direction of the collision, update the ball to move in the opposite trajectory
    end
  end

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
      paddle = {
        x = self.paddle.x
      },
      ball = {
        -- ! consider the speed accumulated between the update and the press on the enter key
        x = self.ball.x + self.ball.dx * dt,
        y = self.ball.y + self.ball.dy * dt,
        dx = self.ball.dx,
        dy = self.ball.dy,
        skin = self.ball.skin
      },
      bricks = self.bricks
    })
    -- play a sound as the game moves to the pause screen
    gSounds['select']:play()
  end

end

-- in the render function, render the paddle and the ball
function PlayState:render()
  self.paddle:render()
  self.ball:render()

  -- loop through the table of bricks and render each one of them through the :render function
  for k, brick in pairs(self.bricks) do
    brick:render()
  end
end