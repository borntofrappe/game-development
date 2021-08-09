Cannonball = {}
Cannonball.__index = Cannonball

function Cannonball:new(x, y)
  local size = 36

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = size
  }

  setmetatable(this, self)
  return this
end

function Cannonball:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["cannonball"], self.x, self.y, 0, 1, 1, self.size / 2, self.size / 2)
end
