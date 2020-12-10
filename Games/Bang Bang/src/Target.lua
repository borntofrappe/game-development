Target = {}
Target.__index = Target

function Target:create(x, y)
  this = {
    ["x"] = x - TARGET_WIDTH,
    ["y"] = y - TARGET_HEIGHT + TARGET_OFFSET_HEIGHT,
    ["width"] = TARGET_WIDTH,
    ["height"] = TARGET_HEIGHT
  }

  setmetatable(this, self)

  return this
end

function Target:render()
  love.graphics.draw(gTextures["target"], self.x, self.y)
end
