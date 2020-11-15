LandState = BaseState:create()

function LandState:enter()
  self.timer = 0

  local messages = {
    "Congratulations",
    "Great job",
    "Safe landing"
  }

  self.message = messages[love.math.random(#messages)]
end

function LandState:update(dt)
  self.timer = self.timer + dt
  if self.timer > TIMER_DELAY then
    self.timer = 0
    lander.body:destroy()
    terrain.body:destroy()
    lander = Lander:new(world)
    terrain = Terrain:new(world)
    gStateMachine:change("start")
  end
end

function LandState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  if not lander.body:isDestroyed() then
    lander:render()
  end
  love.graphics.printf(self.message, 0, WINDOW_HEIGHT / 2 - font:getHeight(), WINDOW_WIDTH, "center")
end
