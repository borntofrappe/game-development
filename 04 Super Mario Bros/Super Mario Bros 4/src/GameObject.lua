GameObject = Class {}

function GameObject:init(def)
  self.x = def.x
  self.y = def.y

  self.width = def.width or TILE_SIZE
  self.height = def.height or TILE_SIZE

  self.texture = def.texture
  self.color = def.color
  self.variety = def.variety
end

function GameObject:render()
  love.graphics.draw(
    gTextures[self.texture],
    gFrames[self.texture][self.color][self.variety],
    (self.x - 1) * self.width,
    (self.y - 1) * self.height
  )
end
