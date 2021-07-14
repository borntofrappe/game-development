Dust = {}

local TEXTURE = love.graphics.newImage("res/graphics/dust.png")
local PARTICLES = 50

function Dust:new()
  local particleSystem = love.graphics.newParticleSystem(TEXTURE, PARTICLES)
  particleSystem:setParticleLifetime(0.2, 0.5)
  particleSystem:setLinearDamping(2, 5)
  particleSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0.3, 1, 1, 1, 0)

  local this = {
    ["particleSystem"] = particleSystem
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Dust:emit(x, y, acceleration)
  self.particleSystem:setPosition(x, y)
  self.particleSystem:setLinearAcceleration(acceleration[1], acceleration[2], acceleration[3], acceleration[4])

  self.particleSystem:emit(PARTICLES)
end

function Dust:update(dt)
  self.particleSystem:update(dt)
end

function Dust:render()
  love.graphics.draw(self.particleSystem)
end
