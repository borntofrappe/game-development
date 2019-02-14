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

    -- change dx according to the direction of the ball and where the ball hits the paddle (from the center)
    -- distance between the center of the ball and the center of the paddle
    -- if positive, the ball hits the paddle on the right section, if negative, on the left
    deltaCenter = (self.ball.x + self.ball.width / 2) - (self.paddle.x + self.paddle.width / 2)

    -- compute the horizontal speed incrementing the value by a factor weighed by deltaCenter
    --[[
      possible scenarios:
      deltaCenter > 0, dx > 0 (hitting on the right, moving to the right)
        make dx a greater value, adding the weighed factor

      deltaCenter < 0, dx < 0 (hitting on the left, moving to the left)
        make dx even smaller, again adding the weighed factor (as deltaCenter is already negative)

      deltaCenter > 0, dx < 0 (hitting on the right, moving to the left)
        make dx greater, as to balance, soften the hit, adding the weighed factor (a positive value)

      deltaCenter < 0, dx > 0 (hitting on the left, moving to the right)
        make dx smaller, as to balance the hit in the opposite direction, again adding the weighed factor (a negagive value)

      this means it is possible to offset dx if this is smaller relative to the counter-balancing distance from the center
    ]]
    self.ball.dx = self.ball.dx + deltaCenter * 4

    -- -- alter the horizontal speed according to the current direction
    -- if self.ball.dx >= 0 then
    --   self.ball.dx = self.ball.x + 5 * math.abs(deltaCenter)
    -- else
    --   self.ball.dx = self.ball.x - 5 * math.abs(deltaCenter)
    -- end

    gSounds['paddle_hit']:play()
  end

  -- loop through the table of keys and trigger the hit() function if the ball collides with a brick displayed on the screen
  for k, brick in pairs(self.bricks) do
    if brick.inPlay and self.ball:collides(brick) then
      brick:hit()

      -- to change the direction of the ball when it hits a brick, consider its movement and coordinates with respect to the brick's coordinates

      if self.ball.dx > 0 and self.ball.x + self.ball.width + 4 < brick.x then
        self.ball.dx = -self.ball.dx
        self.ball.x = brick.x - self.ball.width

      elseif self.ball.dx < 0 and self.ball.x - 4 > brick.x + brick.width then
        self.ball.dx = -self.ball.dx
        self.ball.x = brick.x + brick.width

      elseif self.ball.y + self.ball.height < brick.y then
        self.ball.dy = -self.ball.dy
        self.ball.y = brick.y - self.ball.height

      else
        self.ball.dy = -self.ball.dy
        self.ball.y = brick.y + brick.height

      end

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