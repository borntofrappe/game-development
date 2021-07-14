Debris = {}

local TEXTURE = love.graphics.newImage("res/graphics/debris.png")
local PARTICLES = 10
local BUFFER = PARTICLES * MAZE_DIMENSION ^ 2 * 4

function Debris:new()
  local particleSystem = love.graphics.newParticleSystem(TEXTURE, BUFFER)
  particleSystem:setParticleLifetime(0.25, 0.55)
  particleSystem:setRadialAcceleration(100, 200)
  particleSystem:setEmissionArea("uniform", CELL_SIZE / 2, CELL_SIZE / 2)
  particleSystem:setSpin(0, math.pi * 2)
  particleSystem:setRotation(0, math.pi * 2)
  particleSystem:setSizes(0, 1, 1, 1, 0)

  local this = {
    ["particleSystem"] = particleSystem
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Debris:emit(x, y, acceleration)
  self.particleSystem:setPosition(x, y)
  self.particleSystem:setLinearAcceleration(acceleration[1], acceleration[2], acceleration[3], acceleration[4])

  self.particleSystem:emit(PARTICLES)
end

function Debris:update(dt)
  self.particleSystem:update(dt)
end

function Debris:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.particleSystem)
end
