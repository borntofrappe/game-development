CrashState = BaseState:create()

function CrashState:enter(params)
  local particleSystem = love.graphics.newParticleSystem(gTextures["particle"], 200)

  particleSystem:setPosition(params.x, params.y - 5)
  particleSystem:setParticleLifetime(0.25, 0.5)
  particleSystem:setEmissionArea("uniform", 18, 18)
  particleSystem:setRadialAcceleration(50, 500)
  particleSystem:setLinearDamping(15, 25)
  particleSystem:setSizes(0, 1, 1, 0)
  particleSystem:setRotation(0, math.pi * 2)

  self.particleSystem = particleSystem
  self.particleSystem:emit(30)

  lander.body:destroy()

  local messages = {
    "Too bad",
    "Better luck next time",
    "Let's call it a practice run",
    "Far from the perfect landing"
  }

  local message = messages[love.math.random(#messages)]

  self.message =
    Message:new(
    message,
    function()
      terrain.body:destroy()
      data["score"] = 0
      gStateMachine:change("start")
    end
  )
end

function CrashState:update(dt)
  self.message:update(dt)
  self.particleSystem:update(dt)

  if love.keyboard.wasPressed("return") then
    terrain.body:destroy()
    data["score"] = 0
    gStateMachine:change("start")
  end
end

function CrashState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.draw(self.particleSystem)

  self.message:render()
end
