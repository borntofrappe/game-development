Gem = {}

function Gem:new(x, y, size, color)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = size,
    ["color"] = color
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Gem:render()
  love.graphics.draw(gTextures.spritesheet, gQuads.gems[self.color][self.size], self.x, self.y)
end
