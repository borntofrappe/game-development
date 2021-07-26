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
  love.graphics.printf("Gameover", 0, WINDOW_HEIGHT / 2 - 8, WINDOW_WIDTH, "center")
end
