GameoverState = BaseState:new()

function GameoverState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("play")
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("start")
  end
end

function GameoverState:render()
  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf("Gameover", 0, WINDOW_HEIGHT / 2 - gFonts["large"]:getHeight() / 2, WINDOW_WIDTH, "center")
end
