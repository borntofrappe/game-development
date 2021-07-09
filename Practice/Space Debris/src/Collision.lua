Collision = {}

local TEXTURE = love.graphics.newImage("res/graphics/particle.png")
local PARTICLES = 300

function Collision:new()
  local particleSystem = love.graphics.newParticleSystem(TEXTURE, PARTICLES)
  particleSystem:setParticleLifetime(0.5, 1.5)
  particleSystem:setLinearDamping(4, 8)
  particleSystem:setEmissionArea("normal", 4, 4)

  local this = {
    ["particleSystem"] = particleSystem
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Collision:emit(x, y, xMin, yMin, xMax, yMax)
  self.particleSystem:setPosition(x, y)
  self.particleSystem:setLinearAcceleration(xMin, yMin, xMax, yMax)

  self.particleSystem:emit(PARTICLES)
end

function Collision:update(dt)
  self.particleSystem:update(dt)
end

function Collision:render()
  love.graphics.draw(self.particleSystem)
end
