StartState = BaseState:new()

function StartState:enter()
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end

function StartState:render()
  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.printf("Bonne Chance", 0, WINDOW_HEIGHT / 2 - 8, WINDOW_WIDTH, "center")
end
