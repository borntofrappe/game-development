TitleState = BaseState:create()

function TitleState:enter()
  self.message = {
    ["text"] = "Aim\n\nShoot\n\nRepeat",
    ["alpha"] = 1
  }

  local newLines = 0
  for i = 1, #self.message.text do
    if self.message.text:sub(i, i) == "\n" then
      newLines = newLines + 1
    end
  end

  self.message.newLines = newLines

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
  elseif love.keyboard.wasPressed("return") then
    Timer:reset()
    gStateMachine:change("play")
  end
end

function TitleState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(gTextures["title"], 64, WINDOW_HEIGHT / 2 - gTextures["title"]:getHeight() / 2)

  love.graphics.setFont(gFonts["title"])
  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b, self.message.alpha)
  love.graphics.printf(
    self.message.text,
    WINDOW_WIDTH / 2,
    WINDOW_HEIGHT / 2 - gFonts["title"]:getHeight() * self.message.newLines / 2,
    WINDOW_WIDTH / 2,
    "center"
  )
end
