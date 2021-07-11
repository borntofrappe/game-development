PlayState = BaseState:new()

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("gameover")
  end
end

function PlayState:render()
  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf("Play", 0, WINDOW_HEIGHT / 2 - gFonts["large"]:getHeight() / 2, WINDOW_WIDTH, "center")
end
