PlayState = Class({__includes = BaseState})

function PlayState:enter(params)
  self.level = params.level
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.score = params.score
  self.paddle = params.paddle
  self.ball = params.ball
  self.bricks = params.bricks
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
        ball = self.ball,
        bricks = self.bricks
      }
    )
    gSounds["pause"]:play()
  end

  self.paddle:update(dt)
  self.ball:update(dt)

  if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - self.ball.height
    self.ball.dy = self.ball.dy * -1

    deltaCenter = (self.ball.x + self.ball.width / 2) - (self.paddle.x + self.paddle.width / 2)
    self.ball.dx = self.ball.dx + deltaCenter * 4

    gSounds["paddle_hit"]:play()
  end

  for k, brick in pairs(self.bricks) do
    brick:update(dt)

    if self.ball:collides(brick) and brick.inPlay then
      self.score = self.score + 50 * brick.tier + 200 * (brick.color - 1)
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
            ball = self.ball
          }
        )
        gSounds["victory"]:play()
      end

      if self.ball.dx > 0 then
        isBefore = self.ball.x + self.ball.width < brick.x + 5
        if isBefore then
          self.ball.x = brick.x - self.ball.width
          self.ball.dx = self.ball.dx * -1
        else
          self.ball.y = self.ball.dy > 0 and brick.y - self.ball.height or brick.y + brick.height
          self.ball.dy = self.ball.dy * -1
        end
      else
        isAfter = self.ball.x > brick.x + brick.width - 5
        if isAfter then
          self.ball.x = brick.x + brick.width
          self.ball.dx = self.ball.dx * -1
        else
          self.ball.y = self.ball.dy > 0 and brick.y - self.ball.height or brick.y + brick.height
          self.ball.dy = self.ball.dy * -1
        end
      end
    end
  end

  if self.ball.y >= VIRTUAL_HEIGHT then
    self.health = self.health - 1
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
          bricks = self.bricks
        }
      )
    end
    gSounds["hurt"]:play()
  end
end

function PlayState:render()
  displayHealth(self.health, self.maxHealth)
  displayScore(self.score)

  for k, brick in pairs(self.bricks) do
    brick:render()
    brick:renderParticles()
  end
  self.paddle:render()
  self.ball:render()
end

function PlayState:isLevelCleared()
  for k, brick in pairs(self.bricks) do
    if brick.inPlay then
      return false
    end
  end
  return true
end
