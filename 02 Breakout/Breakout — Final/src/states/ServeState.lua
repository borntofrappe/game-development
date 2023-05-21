ServeState = Class({__includes = BaseState})

local LEVEL = 1
local HEALTH = 3
local MAX_HEALTH = 3
local SCORE = 0
local THRESHOLD = 1000

function ServeState:enter(params)
  self.level = params.level or LEVEL
  self.health = params.health or HEALTH
  self.maxHealth = params.maxHealth or MAX_HEALTH
  self.score = params.score or SCORE
  self.paddle = params.paddle or Paddle(VIRTUAL_WIDTH / 2 - PADDLE_WIDTH / 2, VIRTUAL_HEIGHT - PADDLE_HEIGHT * 2)
  self.ball = params.ball or Ball(VIRTUAL_WIDTH / 2 - BALL_WIDTH / 2, VIRTUAL_HEIGHT - PADDLE_HEIGHT * 2 - BALL_HEIGHT)
  self.bricks = params.bricks or LevelMaker.createMap(self.level)
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
        bricks = self.bricks
      }
    )
    gSounds["confirm"]:play()
  end

  self.paddle:update(dt)
  self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
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
