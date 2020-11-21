Particle = {}

function Particle:new(x, y, r)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = r
  }

  setmetatable(this, self)
  self.__index = self
  return this
end

function Particle:render()
  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.circle("fill", self.x, self.y, self.r)
end

function Particle:collides(particle)
  return (math.abs(self.x - particle.x) + math.abs(self.y - particle.y)) ^ 2 < (self.r + particle.r) ^ 2
end
