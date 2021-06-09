WaitingScreenState = Class {__includes = BaseState}

function WaitingScreenState:init()
end

function WaitingScreenState:update(dt)
  if love.mouse.waspressed then
    gStateMachine:change("title")
  end
end

function WaitingScreenState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.big)
  love.graphics.printf("Wait for it", 0, WINDOW_HEIGHT / 2 - gFonts.big:getHeight() / 2, WINDOW_WIDTH, "center")
end
