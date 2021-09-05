PlayState = BaseState:new()

function PlayState:enter()
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("title")
  end
end

function PlayState:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.print("Play", 8, 8)
end
