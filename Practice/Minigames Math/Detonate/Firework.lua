Firework = {}

local SPEED = 150
local RADIUS = 3

local TEXTURE = love.graphics.newImage("particle.png")
local PARTICLES = {
  ["trail"] = 20,
  ["explosion"] = 300,
  ["fizzle"] = 30
}

function Firework:new()
  local particles = PARTICLES

  local trail = love.graphics.newParticleSystem(TEXTURE, particles["trail"])
  trail:setParticleLifetime(0.3, 0.8)
  trail:setSizes(0.2, 0.1)
  trail:setColors(1, 1, 1, 0.3, 1, 1, 1, 0)

  local explosion = love.graphics.newParticleSystem(TEXTURE, particles["explosion"])
  explosion:setParticleLifetime(0.8, 1.8)
  explosion:setLinearAcceleration(-120, -80, 120, 140)
  explosion:setSizes(0.5, 0.5, 0.4, 0.3, 0.3)
  explosion:setColors(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.7, 1, 1, 1, 0.5, 1, 1, 1, 0)

  local fizzle = love.graphics.newParticleSystem(TEXTURE, particles["fizzle"])
  fizzle:setParticleLifetime(0.5, 1)
  fizzle:setLinearAcceleration(-30, -20, 30, 50)
  fizzle:setSizes(0.3, 0.3, 0.25, 0.2)
  fizzle:setColors(1, 1, 1, 1, 1, 1, 1, 0)

  local this = {
    ["x"] = WINDOW_WIDTH / 2 - RADIUS / 2,
    ["y"] = WINDOW_HEIGHT + RADIUS,
    ["r"] = RADIUS,
    ["dy"] = SPEED * -1,
    ["particles"] = particles,
    ["particleSystem"] = trail,
    ["particleSystems"] = {
      ["trail"] = trail,
      ["explosion"] = explosion,
      ["fizzle"] = fizzle
    }
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Firework:update(dt)
  self.y = self.y + self.dy * dt

  self.particleSystem:update(dt)
end

function Firework:trail()
  self.particleSystem:setPosition(self.x, self.y)
  self.particleSystem:emit(self.particles["trail"])
end

function Firework:explode()
  self.particleSystem = self.particleSystems["explosion"]
  self.particleSystem:setPosition(self.x, self.y)
  self.particleSystem:emit(self.particles["explosion"])
end

function Firework:fizzle()
  self.particleSystem = self.particleSystems["fizzle"]
  self.particleSystem:setPosition(self.x, self.y)
  self.particleSystem:emit(self.particles["fizzle"])
end

function Firework:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.particleSystem)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
