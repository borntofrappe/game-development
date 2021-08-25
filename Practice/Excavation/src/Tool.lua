Tool = {}

function Tool:new(name, type, x, y)
  local this = {
    ["name"] = name,
    ["type"] = type,
    ["x"] = x,
    ["y"] = y,
    ["width"] = TOOLS_WIDTH,
    ["height"] = TOOLS_HEIGHT
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Tool:render()
  love.graphics.draw(gTextures.spritesheet, gQuads.tools[self.name][self.type], self.x, self.y)
end
