Particles = {}

local PARTICLES = 50

function Particles:new(x, y, xMin, yMin, xMax, yMax)
  local particleSystem = love.graphics.newParticleSystem(gTextures["particle"], PARTICLES)

  particleSystem:setPosition(x, y)
  particleSystem:setParticleLifetime(0.4, 1.2)
  particleSystem:setLinearAcceleration(xMin, yMin, xMax, yMax)
  particleSystem:setSizes(0, 1, 1, 0)

  particleSystem:emit(PARTICLES)

  local this = {
    ["particleSystem"] = particleSystem
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Particles:update(dt)
  self.particleSystem:update(dt)
end

function Particles:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.particleSystem)
end
