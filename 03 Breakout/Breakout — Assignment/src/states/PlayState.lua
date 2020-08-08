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

  self.powerups = params.powerups or {}
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
        powerups = self.powerups
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
      end
    end
  end

  for k, brick in pairs(self.bricks) do
    brick:update(dt)

    for key, ball in pairs(self.balls) do
      if testAABB(ball, brick) and brick.inPlay then
        self.score = self.score + 50 * brick.tier + 200 * (brick.color - 1)

        powerupFlag = math.random(5) == 1
        if brick.tier == 1 and brick.color == 1 and powerupFlag then
          powerup = Powerup(brick.x + brick.width / 2, brick.y + brick.height / 2)
          table.insert(self.powerups, powerup)
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
              paddle = self.paddle
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
  end

  for k, powerup in pairs(self.powerups) do
    powerup:update(dt)
    if testAABB(powerup, self.paddle) then
      table.insert(self.balls, Ball(powerup.x, powerup.y))
      gSounds["power-up"]:play()
      powerup.remove = true
    end
    if powerup.remove then
      table.remove(self.powerups, k)
    end
  end
end

function PlayState:render()
  displayHealth(self.health, self.maxHealth)
  displayScore(self.score)

  self.paddle:render()

  for k, powerup in pairs(self.powerups) do
    powerup:render()
  end

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
