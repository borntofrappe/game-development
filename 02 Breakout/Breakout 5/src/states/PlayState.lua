PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.paddle = Paddle()
  self.ball = Ball()
  self.bricks = LevelMaker.createMap()
end

function PlayState:enter(params)
  if params then
    self.paddle.x = params.paddle.x
    self.ball.x = params.ball.x
    self.ball.y = params.ball.y
    self.ball.dx = params.ball.dx
    self.ball.dy = params.ball.dy
    self.ball.color = params.ball.color
    self.bricks = params.bricks
  end
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
        paddle = {
          x = self.paddle.x
        },
        ball = {
          x = self.ball.x,
          y = self.ball.y,
          dx = self.ball.dx,
          dy = self.ball.dy,
          color = self.ball.color
        },
        bricks = self.bricks
      }
    )
    gSounds["pause"]:play()
  end

  self.paddle:update(dt)
  self.ball:update(dt)

  if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - self.ball.height
    self.ball.dy = math.max(-150, self.ball.dy * -1 * 1.02)

    local deltaCenter = (self.ball.x + self.ball.width / 2) - (self.paddle.x + self.paddle.width / 2)
    self.ball.dx = math.min(150, math.max(-150, self.ball.dx + deltaCenter * 5))

    gSounds["paddle_hit"]:play()
  end

  for k, brick in pairs(self.bricks) do
    if self.ball:collides(brick) and brick.inPlay then
      brick:hit()

      if self.ball.x + self.ball.width - 3 < brick.x and self.ball.dx > 0 then
        self.ball.x = brick.x - self.ball.width
        self.ball.dx = self.ball.dx * -1
      elseif self.ball.x + 3 > brick.x + brick.width and self.ball.dx < 0 then
        self.ball.x = brick.x + brick.width
        self.ball.dx = self.ball.dx * -1
      elseif self.ball.y + self.ball.height / 2 < brick.y + brick.height / 2 then
        self.ball.y = brick.y - self.ball.height
        self.ball.dy = self.ball.dy * -1
      else
        self.ball.y = brick.y + brick.height
        self.ball.dy = self.ball.dy * -1
      end

      break
    end
  end
end

function PlayState:render()
  for k, brick in pairs(self.bricks) do
    brick:render()
  end
  self.paddle:render()
  self.ball:render()
end
