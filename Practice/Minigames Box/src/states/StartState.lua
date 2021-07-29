StartState = BaseState:new()

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("countdown")
  end
end

function StartState:render()
  love.graphics.setFont(gFonts.large)
  love.graphics.printf("Minigames Box", 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight(), WINDOW_WIDTH, "center")
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Physics-based 2D experiments", 0, WINDOW_HEIGHT / 2 + 24, WINDOW_WIDTH, "center")
end
