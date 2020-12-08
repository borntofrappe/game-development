TitleState = BaseState:create()

function TitleState:enter()
  self.message = {
    ["text"] = "Aim\tShoot\tRepeat",
    ["alpha"] = 1
  }

  Timer:every(
    2,
    function()
      Timer:tween(
        0.5,
        {
          [self.message] = {["alpha"] = 0}
        }
      )
      Timer:after(
        0.5,
        function()
          Timer:tween(
            0.5,
            {
              [self.message] = {["alpha"] = 1}
            }
          )
        end
      )
    end
  )
end

function TitleState:update(dt)
  Timer:update(dt)

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  elseif love.keyboard.wasPressed("return") then
    Timer:reset()
    gStateMachine:change("play")
  end
end

function TitleState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["title"], 0, 0)

  love.graphics.setFont(gFonts["bold"])
  love.graphics.setColor(0, 0, 0, self.message.alpha)
  love.graphics.printf(self.message.text, 0, WINDOW_HEIGHT / 2 + 72, WINDOW_WIDTH, "center")
end
