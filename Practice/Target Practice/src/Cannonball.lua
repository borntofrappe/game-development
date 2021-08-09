Cannonball = {}
Cannonball.__index = Cannonball

function Cannonball:new(x, y)
  local radius = 12

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = radius
  }

  setmetatable(this, self)
  return this
end

function Cannonball:render()
  love.graphics.setColor(0.99, 0.76, 0.33)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
