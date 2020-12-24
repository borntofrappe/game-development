CreatureChasingState = Class({__includes = BaseState})

function CreatureChasingState:init(tileMap, player, creature)
  self.tileMap = tileMap
  self.player = player
  self.creature = creature

  self.direction = self.player.x > self.creature.x + self.creature.width and "right" or "left"
  self.creature.direction = self.direction

  self.animation =
    Animation(
    {
      frames = {1, 2},
      interval = 0.5
    }
  )
  self.creature.currentAnimation = self.animation
end

function CreatureChasingState:update(dt)
  self.creature.currentAnimation:update(dt)

  if self.player.x > self.creature.x + self.creature.width then
    self.creature.direction = "right"
    self.creature.x = self.creature.x + CREATURE_MOVE_SPEED * dt

    local tileTopRight = self.tileMap:pointToTile(self.creature.x + self.creature.width, self.creature.y)
    local tileBottomRight =
      self.tileMap:pointToTile(self.creature.x + self.creature.width, self.creature.y + self.creature.height + 1)

    if (tileTopRight and tileBottomRight) and (tileTopRight.id == TILE_GROUND or tileBottomRight.id == TILE_SKY) then
      self.creature.x = (tileBottomRight.x - 1) * TILE_SIZE - self.creature.width
    end
  elseif self.player.x < self.creature.x then
    self.creature.direction = "left"
    self.creature.x = self.creature.x - CREATURE_MOVE_SPEED * dt

    local tileTopLeft = self.tileMap:pointToTile(self.creature.x, self.creature.y)
    local tileBottomLeft = self.tileMap:pointToTile(self.creature.x, self.creature.y + self.creature.height + 1)

    if (tileTopLeft and tileBottomLeft) and (tileTopLeft.id == TILE_GROUND or tileBottomLeft.id == TILE_SKY) then
      self.creature.x = (tileBottomLeft.x - 1) * TILE_SIZE + tileBottomLeft.width
    end
  end

  if math.abs(self.player.x - self.creature.x) > CREATURE_CHASING_RANGE then
    self.creature:changeState("moving")
  end
end
