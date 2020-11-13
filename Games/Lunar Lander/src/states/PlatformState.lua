PlatformState = Class({__includes = BaseState})

function PlatformState:init()
end

function PlatformState:update(dt)
  if love.keyboard.wasPressed("return") then
    gStateMachine:change("orbit")
  end
end

function PlatformState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.line(terrain)

  love.graphics.printf("Platform State", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
