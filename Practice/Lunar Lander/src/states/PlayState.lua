PlayState = BaseState:new()

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end
end
