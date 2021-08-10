Cannonball = {}
Cannonball.__index = Cannonball

function Cannonball:new(cannon)
  local r = 12

  local this = {
    ["x"] = cannon.x,
    ["y"] = cannon.y,
    ["r"] = r
  }

  setmetatable(this, self)
  return this
end

function Cannonball:render()
  love.graphics.setColor(0.6, 0.62, 0.72)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
