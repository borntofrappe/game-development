StartState = BaseState:new()

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf("Start", 0, WINDOW_HEIGHT / 2 - gFonts["large"]:getHeight() / 2, WINDOW_WIDTH, "center")
end
