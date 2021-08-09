Target = {}
Target.__index = Target

function Target:new(x, y)
  local width = 50
  local height = 75

  local this = {
    ["x"] = x - width / 2,
    ["y"] = y - height,
    ["width"] = width,
    ["height"] = height
  }

  setmetatable(this, self)
  return this
end

function Target:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["target"], self.x, self.y)
end
