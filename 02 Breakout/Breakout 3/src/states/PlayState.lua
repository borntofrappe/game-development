PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.paddle = Paddle()
  self.ball = Ball()
end

function PlayState:enter(params)
  if params then
    self.paddle.x = params.paddle.x
    self.ball.x = params.ball.x
    self.ball.y = params.ball.y
    self.ball.dx = params.ball.dx
    self.ball.dy = params.ball.dy
    self.ball.color = params.ball.color
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
        }
      }
    )
    gSounds["pause"]:play()
  end

  self.paddle:update(dt)
  self.ball:update(dt)

  if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - self.ball.height
    self.ball.dy = self.ball.dy * -1

    gSounds["paddle_hit"]:play()
  end
end

function PlayState:render()
  self.paddle:render()
  self.ball:render()
end
