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
  - serve state (losing health)
  - gameover state (losing all health)
]]

-- inherit from the BaseState class
PlayState = Class{__includes = BaseState}

-- in the enter() function receive the elements of the game from the serve state
function PlayState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.score = params.score
  self.level = params.level
  self.ball = params.ball
  self.highScores = params.highScores
end

-- in the update(dt) function update the paddle, the ball and listen on a selection of keys
function PlayState:update(dt)
  self.paddle:update(dt)
  self.ball:update(dt)

  -- check for a collision with the paddle and change the vertical coordinate accordingly
  if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - self.ball.height
    self.ball.dy = -self.ball.dy

    -- change dx according to the direction of the ball and where the ball hits the paddle (from the center)
    -- deltaCenter is computed to describe the distance between the center of the ball and the center of the paddle
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


  -- loop through the table of bricks updating their state and reacting to a possible collision with the ball
  for k, brick in pairs(self.bricks) do
    -- update the brick (mainly the particle system of the brick)
    brick:update(dt)

    -- check for collision with a brick which is in play
    if self.ball:collides(brick) and brick.inPlay then
      -- increase the score accounting for the tier and color of the brick
      self.score = self.score + ((brick.tier - 1) * 200 + brick.color * 50)
      -- call the function handling the appearance of the brick
      brick:hit()

      -- check for victory and go to the victory state if the function returns true
      if self:checkForVictory() then
        gStateMachine:change('victory', {
          level = self.level,
          score = self.score,
          health = self.health,
          maxHealth = self.maxHealth,
          paddle = self.paddle,
          highScores = self.highScores
        })


        gSounds['victory']:play()
      end

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
      gStateMachine:change('gameover', {
        score = self.score,
        highScores = self.highScores
      })
    -- else transition to the serve state
    else
      gStateMachine:change('serve', {
        paddle = self.paddle,
        bricks = self.bricks,
        health = self.health,
        maxHealth = self.maxHealth,
        score = self.score,
        level = self.level,
        ball = self.ball,
        highScores = self.highScores
      })
    end
  end

  -- when registering a click on the escape key, go back to the start state
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('start', {
      highScores = self.highScores
    })
    gSounds['confirm']:play()
  end

  -- when registering a click on the enter key, go to the pause state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('pause', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      maxHealth = self.maxHealth,
      score = self.score,
      level = self.level,
      ball = self.ball,
      highScores = self.highScores
    })
    gSounds['pause']:play()
  end

end

-- in the render() function, render the elements of the game
function PlayState:render()
  -- paddle
  self.paddle:render()
  -- ball
  self.ball:render()

  -- bricks
  for k, brick in pairs(self.bricks) do
    brick:render()
    -- render also the particles connected to each brick (and positioned at its center)
    brick:renderParticles()
  end

  -- display the score
  displayScore(self.score)

  -- display the hearts
  displayHealth(self.health, self.maxHealth)
end

-- in the checkForVictory function, loop through the table of bricks
-- if one brick is in play return false, else true
function PlayState:checkForVictory()
  for k, brick in pairs(self.bricks) do
    if brick.inPlay then
      return false
    end
  end
  return true
end