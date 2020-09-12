GameoverState = BaseState:create()

function GameoverState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("title")
  end
end

function GameoverState:render()
  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("Gameover"), 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Press enter to continue"), 0, WINDOW_HEIGHT * 3 / 4 - 18, WINDOW_WIDTH, "center")
end
