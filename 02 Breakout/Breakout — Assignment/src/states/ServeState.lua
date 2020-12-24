ServeState = Class({__includes = BaseState})

function ServeState:enter(params)
  self.level = params.level or 1
  self.health = params.health or 3
  self.maxHealth = params.maxHealth or 3
  self.score = params.score or 0
  self.paddle = params.paddle or Paddle(VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - 32)
  self.ball = params.ball or Ball(VIRTUAL_WIDTH / 2 - 4, VIRTUAL_HEIGHT - 32 - 8)
  self.bricks = params.bricks or LevelMaker.createMap(self.level)
  self.threshold = params.threshold or 1000
end

function ServeState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
    gSounds["confirm"]:play()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        level = self.level,
        health = self.health,
        maxHealth = self.maxHealth,
        score = self.score,
        paddle = self.paddle,
        ball = self.ball,
        bricks = self.bricks,
        threshold = self.threshold
      }
    )
    gSounds["confirm"]:play()
  end

  self.paddle:update(dt)
  self.ball.x = self.paddle.x + self.paddle.width / 2 - 4
end

function ServeState:render()
  displayHealth(self.health, self.maxHealth)
  displayScore(self.score)

  for k, brick in pairs(self.bricks) do
    brick:render()
  end
  self.paddle:render()
  self.ball:render()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts["big"])

  love.graphics.printf("Level: " .. self.level, 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])

  love.graphics.printf("Press enter to play", 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, "center")
end
