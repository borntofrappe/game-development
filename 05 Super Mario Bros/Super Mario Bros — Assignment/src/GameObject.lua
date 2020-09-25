GameObject = Class {}

function GameObject:init(def)
  self.x = def.x
  self.y = def.y

  self.width = def.width or TILE_SIZE
  self.height = def.height or TILE_SIZE

  self.texture = def.texture
  self.color = def.color
  self.variety = def.variety

  self.isSolid = def.isSolid
  self.isCollidable = def.isCollidable
  self.onCollide = def.onCollide

  self.isConsumable = def.isConsumable
  self.onConsume = def.onConsume
  self.onDisappear = def.onDisappear

  self.isLock = def.isLock
  self.isKey = def.isKey
end

function GameObject:collides(target)
  if target.x + target.width < (self.x - 1) * TILE_SIZE or target.x > (self.x - 1) * TILE_SIZE + self.width then
    return false
  end

  if target.y + target.height < (self.y - 1) * TILE_SIZE or target.y > (self.y - 1) * TILE_SIZE + self.height then
    return false
  end

  return true
end

function GameObject:render()
  love.graphics.draw(
    gTextures[self.texture],
    gFrames[self.texture][self.color][self.variety],
    (self.x - 1) * TILE_SIZE,
    (self.y - 1) * TILE_SIZE
  )
end
