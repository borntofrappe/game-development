PauseState = Class({__includes = BaseState})

function PauseState:init()
  gSounds["music"]:pause()
end

function PauseState:enter(params)
  self.paddle = {
    x = params.paddle.x
  }
  self.ball = {
    x = params.ball.x,
    y = params.ball.y,
    dx = params.ball.dx,
    dy = params.ball.dy,
    color = params.ball.color
  }

  self.bricks = params.bricks
end

function PauseState:exit()
  gSounds["music"]:play()
end

function PauseState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
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
    gSounds["confirm"]:play()
  end
end

function PauseState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Pause", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("Press enter to resume playing", 0, VIRTUAL_HEIGHT / 2 - 8, VIRTUAL_WIDTH, "center")
end
