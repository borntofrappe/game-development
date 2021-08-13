PlayState = BaseState:new()

function PlayState:enter()
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("start")
  end
end

function PlayState:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Play", 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")
end
