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
  love.graphics.printf("Start", 0, WINDOW_HEIGHT / 2 - 8, WINDOW_WIDTH, "center")
end
