CrashState = BaseState:create()

function CrashState:enter(params)
  local particleSystem = love.graphics.newParticleSystem(gTextures["particle"], 200)

  particleSystem:setPosition(params.x, params.y - 5)
  particleSystem:setParticleLifetime(0.25, 0.75)
  particleSystem:setEmissionArea("uniform", 18, 18)
  particleSystem:setRadialAcceleration(0, 500)
  particleSystem:setLinearDamping(10, 20)
  particleSystem:setSizes(0, 1, 1, 0)
  particleSystem:setRotation(0, math.pi * 2)

  self.particleSystem = particleSystem
  self.particleSystem:emit(20)

  lander.body:destroy()

  self.timer = 0

  local messages = {
    "Too bad",
    "That wasn't cheap",
    "Better luck next time"
  }

  self.message = messages[love.math.random(#messages)]
end

function CrashState:update(dt)
  self.particleSystem:update(dt)

  self.timer = self.timer + dt
  if self.timer > TIMER_DELAY then
    self.timer = 0
    terrain.body:destroy()
    lander = Lander:new(world)
    terrain = Terrain:new(world)
    gStateMachine:change("start")
  end
end

function CrashState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.draw(self.particleSystem)

  love.graphics.printf(self.message, 0, WINDOW_HEIGHT / 2 - font:getHeight(), WINDOW_WIDTH, "center")
end
