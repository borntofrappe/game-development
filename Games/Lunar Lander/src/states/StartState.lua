StartState = BaseState:create()

function StartState:enter()
  local messages = {
    "Good luck",
    "Give it your best",
    "Tricky terrain"
  }

  self.message = messages[love.math.random(#messages)]
end

function StartState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("return") then
    gStateMachine:change("orbit")
  end
end

function StartState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  lander:render()
  love.graphics.printf(self.message, 0, WINDOW_HEIGHT / 2 - font:getHeight(), WINDOW_WIDTH, "center")
end
