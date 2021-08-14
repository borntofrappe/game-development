Town = {}

function Town:new(x, y)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = STRUCTURE_SIZE,
    ["height"] = STRUCTURE_SIZE
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Town:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures.spritesheet, gQuads.structures[1], self.x, self.y)
end
