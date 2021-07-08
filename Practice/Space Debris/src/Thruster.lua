Thruster = {}

local TEXTURE = love.graphics.newImage("res/graphics/particle.png")
local PARTICLES = 50

function Thruster:new()
  local particleSystem = love.graphics.newParticleSystem(TEXTURE, PARTICLES)
  particleSystem:setParticleLifetime(0.3, 0.9)
  particleSystem:setLinearAcceleration(-200, 100, 200, 360)
  particleSystem:setLinearDamping(2, 4)

  local this = {
    ["particleSystem"] = particleSystem
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Thruster:emit(x, y)
  self.particleSystem:setPosition(x, y)
  self.particleSystem:emit(PARTICLES)
end

function Thruster:update(dt)
  self.particleSystem:update(dt)
end

function Thruster:render()
  love.graphics.draw(self.particleSystem)
end
