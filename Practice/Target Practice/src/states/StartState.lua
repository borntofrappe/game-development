StartState = BaseState:new()

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end

function StartState:render()
  love.graphics.setColor(0.94, 0.94, 0.95)

  love.graphics.printf("Bonne chance", 0, WINDOW_HEIGHT / 2 - 4, WINDOW_WIDTH, "center")
end
