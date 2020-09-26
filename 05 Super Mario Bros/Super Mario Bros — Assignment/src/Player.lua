Player = Class({__includes = Entity})

function Player:init(def)
  Entity.init(self, def)
  self.score = def.score
end

function Player:update(dt)
  Entity.update(self, dt)
end

function Player:render()
  Entity.render(self)
end

function Player:checkLeftCollision(dt)
  local tileTopLeft = self.level.tileMap:pointToTile(self.x, self.y + 1)
  local tileBottomLeft = self.level.tileMap:pointToTile(self.x, self.y + self.height - 1)

  if (tileTopLeft and tileBottomLeft) and (tileTopLeft.id == TILE_GROUND or tileBottomLeft.id == TILE_GROUND) then
    self.x = (tileBottomLeft.x - 1) * TILE_SIZE + tileBottomLeft.width
  end

  local collidedObjects = self:checkObjectCollision()
  if #collidedObjects > 0 then
    self.x = self.x + PLAYER_WALK_SPEED * dt
  end
end

function Player:checkRightCollision(dt)
  local tileTopRight = self.level.tileMap:pointToTile(self.x + self.width - 1, self.y + 1)
  local tileBottomRight = self.level.tileMap:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

  if (tileTopRight and tileBottomRight) and (tileTopRight.id == TILE_GROUND or tileBottomRight.id == TILE_GROUND) then
    self.x = (tileBottomRight.x - 1) * TILE_SIZE - self.width
  end

  self.x = self.x - 1
  local collidedObjects = self:checkObjectCollision()
  self.x = self.x + 1
  if #collidedObjects > 0 then
    self.x = self.x - PLAYER_WALK_SPEED * dt
  end
end

function Player:checkObjectCollision()
  local collidedObjects = {}

  for k, object in pairs(self.level.objects) do
    if object.isSolid and object:collides(self) then
      if object.isGoal then
        gSounds["new-level"]:play()
        gStateMachine:change(
          "play",
          {
            width = self.level.tileMap.width + 10,
            score = self.score
          }
        )
        break
      end
      table.insert(collidedObjects, object)
    end
  end

  return collidedObjects
end
