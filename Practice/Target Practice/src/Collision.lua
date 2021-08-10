Collision = {}
Collision.__index = Collision

function Collision:new(x, y)
  local width = 28
  local height = 38

  local points = {
    x - width / 2,
    y,
    x - width,
    y - height / 1.5,
    x - width / 4,
    y - height / 2.5,
    x,
    y - height,
    x + width / 4,
    y - height / 2.5,
    x + width,
    y - height / 1.5,
    x + width / 2,
    y
  }

  local innerPoints = {
    x - width / 3,
    y,
    x - width / 2,
    y - height / 3,
    x - width / 5,
    y - height / 4,
    x,
    y - height / 2,
    x + width / 5,
    y - height / 4,
    x + width / 2,
    y - height / 3,
    x + width / 3,
    y
  }

  local this = {
    ["points"] = points,
    ["innerPoints"] = innerPoints
  }

  setmetatable(this, self)
  return this
end

function Collision:render()
  love.graphics.setColor(0.86, 0.23, 0.21)
  love.graphics.polygon("fill", self.points)
  love.graphics.setColor(0.98, 0.88, 0.27)
  love.graphics.polygon("fill", self.innerPoints)
end
