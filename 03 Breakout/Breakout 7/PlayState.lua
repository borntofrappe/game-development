--[[
  play state

  showing:

  - bricks
  - ball
  - paddle
  - hearts
  - score

  allowing to:
  - move the paddle
  - move the ball
  - react to a collision between the ball and the wall
  - react to a collision between the ball and the bricks
  - react to a collision between the ball and the paddle
  - go to the start state
  - go to the pause state

  by playing the game ending up in:
  - serve state
  - gameover state
]]

-- inherit from the BaseState class
PlayState = Class{__includes = BaseState}

-- in the enter function receive the elements of the game from the serve state
function PlayState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.score = params.score
  self.ball = params.ball
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

    gSounds['paddle_hit']:play()
  end

  -- loop through the table of keys and trigger the hit() function if the ball collides with a brick displayed on the screen
  for k, brick in pairs(self.bricks) do
    if brick.inPlay and self.ball:collides(brick) then
      -- increase the score accounting for the tier and color of the brick
      self.score = self.score + ((brick.tier - 1) * 200 + brick.color * 50)
      -- call the function handling the appearance of the brick
      brick:hit()

      --[[
        to change the direction of the ball when it hits a brick consider
        dx and dy
        if the ball preceeds or follows the brick
      ]]

      -- moving rightwards
      if self.ball.dx > 0 then
        -- moving downwards (and rightwards)
        if self.ball.dy > 0 then
          -- the ball has hit the brick either on the left or top of the brick
          -- to find which side, consider if the coordinate of the ball sits before/after the brick
          -- horizontally and vertically, to also account for a situation in which the ball falls inside of a group of bricks
          beforeX = (self.ball.x + self.ball.width) - brick.x - 3
          beforeY = (self.ball.y + self.ball.height) - brick.y - 3
          -- left side (right before the brick), bounce dx
          if beforeX < 0 then
            self.ball.dx = -self.ball.dx
            self.ball.x = brick.x - self.ball.width
          -- top side (after the left edge of the brick), bounce dy
          elseif beforeY < 0 then
            self.ball.dy = -self.ball.dy
            self.ball.y = brick.y - self.ball.height
          end

        -- moving upwards (and rightwards)
        else
          -- the ball has hit the brick either on the left or bottom
          -- consider if the ball is following the brick
          beforeX = (self.ball.x + self.ball.width) - brick.x - 3
          afterY = self.ball.y - (brick.y + brick.height) + 3
          -- left side (after the brick), bounce dx
          if beforeX < 0 then
            self.ball.dx = -self.ball.dx
            self.ball.x = brick.x - self.ball.width
          -- bottom side (before the brick), bounce dy
          elseif afterY > 0 then
            self.ball.dy = -self.ball.dy
            self.ball.y = brick.y + brick.height
          end

        end

      -- moving leftwards
      else

        -- moving downwards (and leftwards)
        if self.ball.dy > 0 then
          -- the ball has hit the brick either on the right or top
          afterX = self.ball.x - (brick.x + brick.width) + 3
          beforeY = (self.ball.y + self.ball.height) - brick.y - 3
          -- right side, bounce dx
          if afterX > 0 then
            self.ball.dx = -self.ball.dx
            self.ball.x = brick.x + brick.width
          -- top side, bounce dy
          elseif beforeY < 0 then
            self.ball.dy = -self.ball.dy
            self.ball.y = brick.y - self.ball.height
          end

        -- moving upwards (and leftwards)
        else
          -- the ball has hit the brick either on the right or bottom
          afterX = self.ball.x - (brick.x + brick.width) + 3
          afterY = self.ball.y - (brick.y + brick.height) + 3
          -- right side, bounce dx
          if afterX > 0 then
            self.ball.dx = -self.ball.dx
            self.ball.x = brick.x + brick.width
          -- bottom side, bounce dy
          elseif afterY > 0 then
            self.ball.dy = -self.ball.dy
            self.ball.y = brick.y + brick.height
          end

        end
      end

    end
  end

  -- check if the ball goes past the bottom of the screen, at which point decrement the health by 1
  if self.ball.y >= VIRTUAL_HEIGHT then
    self.health = self.health - 1
    -- play the matching sound
    gSounds['hurt']:play()

    -- if the health reaches 0, transition to the gameover state
    if self.health == 0 then
      -- passing only the score
      gStateMachine:change('gameover', {
        score = self.score,
      })
    -- else transition to the serve state
    else
      -- passing the necessary information
      gStateMachine:change('serve', {
        paddle = self.paddle,
        bricks = self.bricks,
        health = self.health,
        score = self.score,
        ball = self.ball
      })
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
    -- transition to the play state sending the information which needs to persist
    gStateMachine:change('pause', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      score = self.score,
      ball = self.ball
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

  -- display the score
  displayScore(self.score)

  -- display the hearts
  displayHealth(self.health)
end