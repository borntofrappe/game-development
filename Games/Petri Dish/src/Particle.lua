Particle = {}

function Particle:new(x, y, r, color)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = r,
    ["color"] = color or
      {
        ["r"] = 32 / 255,
        ["g"] = 54 / 255,
        ["b"] = 72 / 255
      }
  }

  setmetatable(this, self)
  self.__index = self
  return this
end

function Particle:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.circle("fill", self.x, self.y, self.r)
end

function Particle:collides(particle)
  return (math.abs(self.x - particle.x) ^ 2 + math.abs(self.y - particle.y) ^ 2) ^ 0.5 <
    self.r + particle.r - MERCI_RADIUS
end
