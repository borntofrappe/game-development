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
  self.balls = params.balls
  self.highScores = params.highScores
end

-- in the update(dt) function update the paddle, the ball and listen on a selection of keys
function PlayState:update(dt)
  self.paddle:update(dt)

  -- update every ball in the balls table
  for k, ball in pairs(self.balls) do
    ball:update(dt)

    -- check for a collision with the paddle and change the vertical coordinate accordingly
    -- for every ball
    if ball:collides(self.paddle) then
      ball.y = self.paddle.y - ball.height
      ball.dy = -ball.dy

      -- change dx according to the direction of the ball and where the ball hits the paddle (from the center)
      -- deltaCenter is computed to describe the distance between the center of the ball and the center of the paddle
      -- if positive, the ball hits the paddle on the right section, if negative, on the left
      deltaCenter = (ball.x + ball.width / 2) - (self.paddle.x + self.paddle.width / 2)

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
      ball.dx = ball.dx + deltaCenter * 4

      gSounds['paddle_hit']:play()
    end

    -- check if the ball goes past the bottom of the screen, at which point remove it from view and check for a loss (only when all balls are removed from view decrement the health)
    if ball.y >= VIRTUAL_HEIGHT then
      ball.inPlay = false

      if self:checkForLoss() then
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
            highScores = self.highScores
          })
        end
      end
    end
  end

  -- loop through the table of bricks updating their state and reacting to a possible collision with one of the balls
  for k, brick in pairs(self.bricks) do
    -- update the brick (mainly the particle system of the brick)
    brick:update(dt)

    -- include the logic of the power up when the brick is hit
    -- check for a collision between the powerup and the paddle
    -- ! check it as long as the power up is in play to avoid overlaps
    if brick.powerup:collides(self.paddle) and brick.powerup.inPlay then
      -- set the inPlay boolean to false, to remove the power up from view
      brick.powerup.inPlay = false
      gSounds['power-up']:play()

      --[[
        possible powers
        1 reduce paddle size
        2 increase paddle size
        3 increase health (maxhealth if health is already capped)
        4 decrease health
        5 increase the speed of the balls
        6 decrease the speed of the balls
        7 make the balls 'lighter'
        8 make the balls 'heavier'
        9 make more balls appear
        -- 10 key to unlock the locked brick
      ]]

      if brick.powerup.power == 1 and self.paddle.size > 1 then
        self.paddle.size = self.paddle.size - 1
        self.paddle.width = self.paddle.size * 32
        -- change the size of the paddle and offset the x coordinate to maintain the paddle centered
        self.paddle.x = self.paddle.x + self.paddle.width / 4
        -- change the speed to have smaller paddles move faster
        self.paddle.speed = 160 + (4 - self.paddle.size) * 20

      elseif brick.powerup.power == 2 and self.paddle.size < 4 then
        self.paddle.size = self.paddle.size + 1
        self.paddle.width = self.paddle.size * 32
        -- change the size of the paddle and offset the x coordinate to maintain the paddle centered
        self.paddle.x = self.paddle.x - self.paddle.width / 4
        -- change the speed to have bigger paddles move slower
        self.paddle.speed = 160 + (4 - self.paddle.size) * 20

      elseif brick.powerup.power == 3 then
        -- if the health is capped increment max health
        if self.health == self.maxHealth then
          self.maxHealth = self.maxHealth + 1
        end
        -- increment health
        self.health = self.health + 1

      elseif brick.powerup.power == 4 then
        -- decrement health
        self.health = self.health - 1
        -- if health reaches 0, go to the gameover state
        if self.health == 0 then
          gStateMachine:change('gameover', {
            score = self.score,
            highScores = self.highScores
          })
        end

      elseif brick.powerup.power == 5 then
        -- increase the speed of every ball uniformly
        for k, ball in pairs(self.balls) do
          ball.dy = ball.dy * 1.2
          ball.dx = ball.dx * 1.2
        end

      elseif brick.powerup.power == 6 then
        -- decrease the speed of the every uniformly
        for k, ball in pairs(self.balls) do
          ball.dy = ball.dy * 0.8
          ball.dx = ball.dx * 0.8
        end


      elseif brick.powerup.power == 7 then
        -- reduce the horizontal movement and have every ball move slightly faster and always upwards
        for k, ball in pairs(self.balls) do
          ball.dy = -math.abs(ball.dy) * 1.2
          ball.dx = ball.dx * 0.5
        end

      elseif brick.powerup.power == 8 then
        -- reduce the horizontal movement and have every ball move slightly faster and always downwards
        for k, ball in pairs(self.balls) do
          ball.dy = math.abs(ball.dy) * 1.2
          ball.dx = ball.dx * 0.5
        end

      elseif brick.powerup.power == 9 then
        -- add an instance of the ball class to the balls table
        newBall = Ball()
        -- have the ball start either in the top left or top right corner
        -- ! it is actually not necessary to safe-proof the movement, toward the bottom right or bottom left corner respectively
        -- if needed the ball will immediately bounce toward the only quarter
        fiftyFifty = math.random(2) == 1
        if fiftyFifty then
          newBall.x = 0
        else
          newBall.x = VIRTUAL_WIDTH - newBall.width
        end
        table.insert(self.balls, newBall)

      elseif brick.powerup.power == 10 then
        -- set the booleans of the brick to have it show/include the unlocked brick
        brick.locked = false
        brick.unlocked = true
      end
    end

    -- check for collision between every brick and every ball
    for j, ball in pairs(self.balls) do

      if ball:collides(brick) and brick.inPlay then
        -- score: no changes for the locked brick, 2000 points for the unlocked brick, variable amount for pattern-ed bricks
        if not brick.locked then
          if brick.unlocked then
            -- add a sizeable number of points for the
            self.score = self.score + 2000
          else
            -- increase the score accounting for the tier and color of the brick
            self.score = self.score + ((brick.tier - 1) * 200 + brick.color * 50)
          end
        end

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
        if ball.dx > 0 then
          -- moving downwards (and rightwards)
          if ball.dy > 0 then
            -- the ball has hit the brick either on the left or top of the brick
            -- to find which side, consider if the coordinate of the ball sits before/after the brick
            -- horizontally and vertically, to also account for a situation in which the ball falls inside of a group of bricks
            beforeX = (ball.x + ball.width) - brick.x - 3
            beforeY = (ball.y + ball.height) - brick.y - 3
            -- left side (right before the brick), bounce dx
            if beforeX < 0 then
              ball.dx = -ball.dx
              ball.x = brick.x - ball.width
            -- top side (after the left edge of the brick), bounce dy
            elseif beforeY < 0 then
              ball.dy = -ball.dy
              ball.y = brick.y - ball.height
            end

          -- moving upwards (and rightwards)
          else
            -- the ball has hit the brick either on the left or bottom
            -- consider if the ball is following the brick
            beforeX = (ball.x + ball.width) - brick.x - 3
            afterY = ball.y - (brick.y + brick.height) + 3
            -- left side (after the brick), bounce dx
            if beforeX < 0 then
              ball.dx = -ball.dx
              ball.x = brick.x - ball.width
            -- bottom side (before the brick), bounce dy
            elseif afterY > 0 then
              ball.dy = -ball.dy
              ball.y = brick.y + brick.height
            end

          end

        -- moving leftwards
        else

          -- moving downwards (and leftwards)
          if ball.dy > 0 then
            -- the ball has hit the brick either on the right or top
            afterX = ball.x - (brick.x + brick.width) + 3
            beforeY = (ball.y + ball.height) - brick.y - 3
            -- right side, bounce dx
            if afterX > 0 then
              ball.dx = -ball.dx
              ball.x = brick.x + brick.width
            -- top side, bounce dy
            elseif beforeY < 0 then
              ball.dy = -ball.dy
              ball.y = brick.y - ball.height
            end

          -- moving upwards (and leftwards)
          else
            -- the ball has hit the brick either on the right or bottom
            afterX = ball.x - (brick.x + brick.width) + 3
            afterY = ball.y - (brick.y + brick.height) + 3
            -- right side, bounce dx
            if afterX > 0 then
              ball.dx = -ball.dx
              ball.x = brick.x + brick.width
            -- bottom side, bounce dy
            elseif afterY > 0 then
              ball.dy = -ball.dy
              ball.y = brick.y + brick.height
            end

          end
        end
      end
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
      balls = self.balls,
      highScores = self.highScores
    })
    gSounds['pause']:play()
  end

end

-- in the render() function, render the elements of the game
function PlayState:render()
  -- paddle
  self.paddle:render()

  -- balls
  for k, ball in pairs(self.balls) do
    ball:render()
  end

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

-- in the checkForLoss function, loop through the table of balls
-- if one ball is in play return false, else true
function PlayState:checkForLoss()
  for k, ball in pairs(self.balls) do
    if ball.inPlay then
      return false
    end
  end
  return true
end