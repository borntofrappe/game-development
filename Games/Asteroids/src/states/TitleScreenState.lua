TitleScreenState = BaseState:create()

function TitleScreenState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("play")
  end
end

function TitleScreenState:render()
  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("Asteroids"), 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Press enter to play"), 0, WINDOW_HEIGHT * 3 / 4 - 16, WINDOW_WIDTH, "center")
end
