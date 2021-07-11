StartState = BaseState:new()

function StartState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change("end")
  end
end

function StartState:render()
  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.printf(
    " StartState\nPress enter to move to the end state",
    0,
    WINDOW_HEIGHT / 2 - 8,
    WINDOW_WIDTH,
    "center"
  )
end
