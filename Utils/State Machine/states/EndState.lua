EndState = BaseState:new()

function EndState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change("start")
  end
end

function EndState:render()
  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.printf(
    "EndState\nPress enter to move to the start state",
    0,
    WINDOW_HEIGHT / 2 - 8,
    WINDOW_WIDTH,
    "center"
  )
end
