Gem = {}

function Gem:new(column, row, size, color)
  local this = {
    ["x"] = (column - 1) * TILE_SIZE,
    ["y"] = (row - 1) * TILE_SIZE,
    ["column"] = column,
    ["row"] = row,
    ["size"] = size,
    ["color"] = color,
    ["dugUp"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Gem:render()
  love.graphics.draw(gTextures.spritesheet, gQuads.gems[self.color][self.size], self.x, self.y)
end
