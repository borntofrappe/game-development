TitleScreenState = BaseState:create()

function TitleScreenState:enter()
end

function TitleScreenState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("play")
  end
end

function TitleScreenState:render()
  love.graphics.setColor(0.224, 0.824, 0.604)
  love.graphics.setFont(gFonts["title"])
  love.graphics.printf(string.upper("Snake"), 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Press enter"), 0, WINDOW_HEIGHT / 2 + 12, WINDOW_WIDTH, "center")
end
