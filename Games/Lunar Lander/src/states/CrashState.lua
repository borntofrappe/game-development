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
  if self.timer > TIMER_DELAY or love.keyboard.wasPressed("return") then
    self.timer = 0
    terrain.body:destroy()
    data["score"] = 0
    gStateMachine:change("start")
  end
end

function CrashState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.draw(self.particleSystem)

  love.graphics.setFont(gFonts["message"])
  love.graphics.printf(
    self.message:upper(),
    0,
    WINDOW_HEIGHT / 2 - gFonts["message"]:getHeight(),
    WINDOW_WIDTH,
    "center"
  )
end
