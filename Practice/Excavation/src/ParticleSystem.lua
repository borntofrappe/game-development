ParticleSystem = {}

local PARTICLES = 60

function ParticleSystem:new()
  local image = love.graphics.newImage("res/graphics/particle.png")

  local particleSystem = love.graphics.newParticleSystem(image, PARTICLES)
  particleSystem:setParticleLifetime(0.3, 0.5)
  particleSystem:setEmissionArea("uniform", TILE_SIZE, TILE_SIZE)
  particleSystem:setSizes(1, 1, 0)
  particleSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
  particleSystem:setRadialAcceleration(10, 50)

  particleSystem:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  local this = {
    ["particleSystem"] = particleSystem
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function ParticleSystem:emit(x, y, percentage)
  self.particleSystem:setPosition(x, y)
  self.particleSystem:setEmissionArea("uniform", math.floor(TILE_SIZE * percentage), math.floor(TILE_SIZE * percentage))
  self.particleSystem:emit(math.floor(PARTICLES * percentage))
end

function ParticleSystem:update(dt)
  self.particleSystem:update(dt)
end

function ParticleSystem:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.particleSystem)
end
