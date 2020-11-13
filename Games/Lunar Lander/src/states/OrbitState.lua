OrbitState = Class({__includes = BaseState})

function OrbitState:init()
end

function OrbitState:update(dt)
  if love.keyboard.wasPressed("return") then
    gStateMachine:change("platform")
  end
end

function OrbitState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.line(terrain)

  love.graphics.printf("Orbit State", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
