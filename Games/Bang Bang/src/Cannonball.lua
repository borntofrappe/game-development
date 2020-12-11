Cannonball = {}
Cannonball.__index = Cannonball

function Cannonball:create(x, y)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = CANNONBALL_SIZE / 2,
    ["isDestroyed"] = false
  }

  setmetatable(this, self)

  return this
end

function Cannonball:render()
  if not self.isDestroyed then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures["cannonball"], self.x, self.y, 0, 1, 1, self.r, self.r)
  end
end
