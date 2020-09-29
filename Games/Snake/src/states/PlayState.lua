PlayState = BaseState:create()

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("start")
  end
end

function PlayState:render()
  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("PlayState"), 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Press escape"), 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, "center")
end
