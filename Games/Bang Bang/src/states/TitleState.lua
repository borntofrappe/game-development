TitleState = BaseState:create()

function TitleState:enter()
  self.message = {
    ["text"] = "Aim\nShoot\nRepeat",
    ["alpha"] = 1
  }

  self.gap = 48

  Timer:every(
    2.5,
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
  end

  if love.keyboard.wasPressed("return") or love.mouse.wasPressed(1) then
    Timer:reset()
    gStateMachine:change("play")
  end
end

function TitleState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(
    gTextures["title"],
    WINDOW_WIDTH / 2 - gTextures["title"]:getWidth() / 2,
    WINDOW_HEIGHT / 2 - gTextures["title"]:getHeight() - self.gap
  )

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b, self.message.alpha)
  love.graphics.printf(self.message.text, 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
