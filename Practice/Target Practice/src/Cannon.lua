Cannon = {}
Cannon.__index = Cannon

function Cannon:new(x, y)
  local width = 110
  local height = 90

  local offsetX = 34
  local offsetY = 66
  local offsetWidth = 19
  local offsetHeight = 10

  local this = {
    ["x"] = x,
    ["y"] = y - height + offsetY,
    ["offsetX"] = offsetX,
    ["offsetY"] = offsetY,
    ["offsetWidth"] = offsetWidth,
    ["offsetHeight"] = offsetHeight,
    ["width"] = width,
    ["height"] = height,
    ["angle"] = 0,
    ["velocity"] = 50
  }

  setmetatable(this, self)
  return this
end

function Cannon:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["cannon"], self.x, self.y, math.rad(self.angle * -1), 1, 1, self.offsetX, self.offsetY)
  love.graphics.draw(gTextures["wheel"], self.x - self.offsetX, self.y - self.offsetY)
end
