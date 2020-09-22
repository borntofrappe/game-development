TitleScreenState = BaseState:create()

function TitleScreenState:enter()
  self.snake = Snake:create()
end

function TitleScreenState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("play")
  end

  self.snake:update(dt)
end

function TitleScreenState:render()
  self.snake:render()

  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("Snake"), 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Press enter"), 0, WINDOW_HEIGHT / 2 + 12, WINDOW_WIDTH, "center")
end
