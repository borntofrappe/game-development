Cannonball = {}
Cannonball.__index = Cannonball

function Cannonball:new(cannon)
  local x = cannon.body.x + cannon.body.width * math.cos(math.rad(cannon.angle))
  local y = cannon.body.y - cannon.body.width * math.sin(math.rad(cannon.angle))

  local r = 12

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = r
  }

  setmetatable(this, self)
  return this
end

function Cannonball:render()
  love.graphics.setColor(0.6, 0.62, 0.72)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
