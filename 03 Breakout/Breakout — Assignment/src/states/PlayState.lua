PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.balls = {}
end

function PlayState:enter(params)
  self.level = params.level
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.score = params.score
  self.paddle = params.paddle
  self.bricks = params.bricks

  if params.balls then
    self.balls = params.balls
  elseif params.ball then
    table.insert(self.balls, params.ball)
  end

  self.threshold = params.threshold
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
    gSounds["confirm"]:play()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "pause",
      {
        level = self.level,
        health = self.health,
        maxHealth = self.maxHealth,
        score = self.score,
        paddle = self.paddle,
        balls = self.balls,
        bricks = self.bricks,
        threshold = self.threshold
      }
    )
    gSounds["pause"]:play()
  end

  self.paddle:update(dt)

  for k, ball in pairs(self.balls) do
    ball:update(dt)

    if testAABB(ball, self.paddle) then
      ball.y = self.paddle.y - ball.height
      ball.dy = ball.dy * -1

      deltaCenter = (ball.x + ball.width / 2) - (self.paddle.x + self.paddle.width / 2)
      ball.dx = ball.dx + deltaCenter * 4

      gSounds["paddle_hit"]:play()
    end

    if ball.y >= VIRTUAL_HEIGHT then
      table.remove(self.balls, k)
      gSounds["hurt"]:play()
      if #self.balls == 0 then
        self.health = self.health - 1
        self.paddle:shrink()
        if self.health == 0 then
          gStateMachine:change(
            "gameover",
            {
              score = self.score
            }
          )
        else
          gStateMachine:change(
            "serve",
            {
              level = self.level,
              health = self.health,
              maxHealth = self.maxHealth,
              score = self.score,
              paddle = self.paddle,
              bricks = self.bricks,
              threshold = self.threshold
            }
          )
        end
      end
    end
  end

  for k, brick in pairs(self.bricks) do
    brick:update(dt)

    for key, ball in pairs(self.balls) do
      if testAABB(ball, brick) and brick.inPlay then
        if brick.tier and brick.color then
          self.score = self.score + 50 * brick.tier + 200 * (brick.color - 1)
        elseif not brick.isLocked then
          self.score = self.score + 1000
        end
        if self.score > self.threshold then
          self.paddle:grow()
          self.threshold = self.threshold * 2.5
        end

        brick:hit()

        if self:isLevelCleared() then
          gStateMachine:change(
            "victory",
            {
              level = self.level,
              health = self.health,
              maxHealth = self.maxHealth,
              score = self.score,
              paddle = self.paddle,
              threshold = self.threshold
            }
          )
          gSounds["victory"]:play()
        end

        if ball.dx > 0 then
          isBefore = ball.x + ball.width < brick.x + 5
          if isBefore then
            ball.x = brick.x - ball.width
            ball.dx = ball.dx * -1
          else
            ball.y = ball.dy > 0 and brick.y - ball.height or brick.y + brick.height
            ball.dy = ball.dy * -1
          end
        else
          isAfter = ball.x > brick.x + brick.width - 5
          if isAfter then
            ball.x = brick.x + brick.width
            ball.dx = ball.dx * -1
          else
            ball.y = ball.dy > 0 and brick.y - ball.height or brick.y + brick.height
            ball.dy = ball.dy * -1
          end
        end
      end
    end

    if brick.showPowerup and brick.powerup.inPlay and testAABB(self.paddle, brick.powerup) then
      brick.powerup.inPlay = false
      gSounds["power-up"]:play()
      if brick.powerup.powerup == 9 then
        table.insert(self.balls, Ball(brick.powerup.x, brick.powerup.y))
      elseif brick.isLocked and brick.powerup.powerup == 10 then
        brick.isLocked = false
      end
    end
  end
end

function PlayState:render()
  displayHealth(self.health, self.maxHealth)
  displayScore(self.score)

  self.paddle:render()

  for k, brick in pairs(self.bricks) do
    brick:render()
    brick:renderParticles()
  end

  for k, ball in pairs(self.balls) do
    ball:render()
  end
end

function PlayState:isLevelCleared()
  for k, brick in pairs(self.bricks) do
    if brick.inPlay then
      return false
    end
  end
  return true
end
