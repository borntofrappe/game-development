Player = Class({__includes = Entity})

function Player:init(def)
  Entity.init(self, def)
  self.score = 0
end

function Player:update(dt)
  Entity.update(self, dt)
end

function Player:render()
  Entity.render(self)
end

function Player:checkLeftCollision()
  local tileTopLeft = self.level.tileMap:pointToTile(self.x, self.y + 1)
  local tileBottomLeft = self.level.tileMap:pointToTile(self.x, self.y + self.height - 1)

  if (tileTopLeft and tileBottomLeft) and (tileTopLeft.id == TILE_GROUND or tileBottomLeft.id == TILE_GROUND) then
    self.x = (tileBottomLeft.x - 1) * TILE_SIZE + tileBottomLeft.width
  end
end

function Player:checkRightCollision()
  local tileTopRight = self.level.tileMap:pointToTile(self.x + self.width - 1, self.y + 1)
  local tileBottomRight = self.level.tileMap:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

  if (tileTopRight and tileBottomRight) and (tileTopRight.id == TILE_GROUND or tileBottomRight.id == TILE_GROUND) then
    self.x = (tileBottomRight.x - 1) * TILE_SIZE - self.width
  end
end

function Player:checkObjectCollision()
  local collidedObjects = {}

  for k, object in pairs(self.level.objects) do
    if object:collides(self) and object.isSolid then
      table.insert(collidedObjects, object)
    end
  end

  return collidedObjects
end
