Collision = {}

local TEXTURE = love.graphics.newImage("res/graphics/particle.png")
local PARTICLES = 300

function Collision:new(x, y, xMin, yMin, xMax, yMax)
  local particleSystem = love.graphics.newParticleSystem(TEXTURE, PARTICLES)
  particleSystem:setParticleLifetime(0.5, 1.5)
  particleSystem:setLinearDamping(4, 8)
  particleSystem:setEmissionArea("normal", 4, 4)

  particleSystem:setPosition(x, y)
  particleSystem:setLinearAcceleration(xMin, yMin, xMax, yMax)
  particleSystem:emit(PARTICLES)

  local this = {
    ["particleSystem"] = particleSystem
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Collision:update(dt)
  self.particleSystem:update(dt)
end

function Collision:render()
  love.graphics.draw(self.particleSystem)
end
