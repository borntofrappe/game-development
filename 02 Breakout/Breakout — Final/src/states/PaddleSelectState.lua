PaddleSelectState = Class({__includes = BaseState})

function PaddleSelectState:init()
  self.paddle = Paddle(VIRTUAL_WIDTH / 2 - PADDLE_WIDTH / 2, VIRTUAL_HEIGHT - PADDLE_HEIGHT * 2)
end

function PaddleSelectState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
    gSounds["confirm"]:play()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "serve",
      {
        paddle = self.paddle
      }
    )
    gSounds["confirm"]:play()
  end

  if love.keyboard.waspressed("right") then
    if self.paddle.color == PADDLE_COLORS then
      gSounds["no-select"]:play()
    else
      self.paddle.color = self.paddle.color + 1
      gSounds["select"]:play()
    end
  end

  if love.keyboard.waspressed("left") then
    if self.paddle.color == 1 then
      gSounds["no-select"]:play()
    else
      self.paddle.color = self.paddle.color - 1
      gSounds["select"]:play()
    end
  end
end

function PaddleSelectState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Paddle selection", 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("Press enter to serve", 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, "center")

  self.paddle:render()

  love.graphics.setColor(1, 1, 1, 1)
  if self.paddle.color == 1 then
    love.graphics.setColor(1, 1, 1, 0.4)
  end
  love.graphics.draw(
    gTextures["arrows"],
    gFrames["arrows"][1],
    VIRTUAL_WIDTH / 2 - self.paddle.width - 24,
    self.paddle.y + self.paddle.height / 2 - 12
  )

  love.graphics.setColor(1, 1, 1, 1)
  if self.paddle.color == 4 then
    love.graphics.setColor(1, 1, 1, 0.4)
  end
  love.graphics.draw(
    gTextures["arrows"],
    gFrames["arrows"][2],
    VIRTUAL_WIDTH / 2 + self.paddle.width,
    self.paddle.y + self.paddle.height / 2 - 12
  )
end
