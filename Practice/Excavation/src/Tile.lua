Tile = {}

function Tile:new(x, y, id)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["id"] = id
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Tile:render()
  love.graphics.draw(gTextures.spritesheet, gQuads.textures[self.id], self.x, self.y)
end
