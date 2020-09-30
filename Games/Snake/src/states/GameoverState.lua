GameoverState = BaseState:create()

function GameoverState:enter(params)
  self.score = params.score or 0
end

function GameoverState:update()
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("start")
  end
end

function GameoverState:render()
  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("Gameover"), 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Score: " .. self.score), 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, "center")
end
