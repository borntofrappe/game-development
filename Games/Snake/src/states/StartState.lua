StartState = BaseState:create()

function StartState:enter()
end

function StartState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("StartState"), 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Press enter"), 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, "center")
end
