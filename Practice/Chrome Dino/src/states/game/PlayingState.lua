PlayingState = BaseState:new()

function PlayingState:enter()
end

function PlayingState:update(dt)
  gDino:update(dt)

  gGround.x = gGround.x - SCROLL_SPEED * dt
  if gGround.x <= -gGround.width then
    gGround.x = 0
  end

  if love.keyboard.waspressed("escape") then
    gStateStack:pop()
    gStateStack:push(WaitingState:new())
  end
end

function PlayingState:exit()
  gDino:changeState("idle")
  gGround.x = 0
end
