Particles = {}

local PARTICLES = 200
local LIFETIME = {0.2, 1}
local DELAY = 1

function Particles:new(x, y, color)
  local particleSystem = love.graphics.newParticleSystem(gTextures["particle"], PARTICLES)
  particleSystem:setParticleLifetime(LIFETIME[1], LIFETIME[2])
  particleSystem:setLinearAcceleration(-100, -100, 100, 100)
  particleSystem:setSizes(2, 2, 1)
  particleSystem:setPosition(x, y)
  particleSystem:setColors(color.r, color.g, color.b, 1)
  particleSystem:emit(PARTICLES)

  local this = {
    ["particleSystem"] = particleSystem,
    ["isEmitting"] = true,
    ["dt"] = 0,
    ["lifetime"] = LIFETIME[2]
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Particles:update(dt)
  self.particleSystem:update(dt)

  self.dt = self.dt + dt
  if self.dt >= self.lifetime then
    self.isEmitting = false
  end
end

function Particles:render()
  love.graphics.draw(self.particleSystem)
end
