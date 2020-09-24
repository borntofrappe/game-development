CreatureMovingState = Class({__includes = BaseState})

function CreatureMovingState:init(tileMap, player, creature)
  self.tileMap = tileMap
  self.player = player
  self.creature = creature
  self.direction = math.random(2) == 1 and "right" or "left"
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

function CreatureMovingState:update(dt)
  self.creature.currentAnimation:update(dt)

  if self.direction == "right" then
    self.creature.x = self.creature.x + CREATURE_MOVE_SPEED * dt

    local tileTopRight = self.tileMap:pointToTile(self.creature.x + self.creature.width, self.creature.y)
    local tileBottomRight =
      self.tileMap:pointToTile(self.creature.x + self.creature.width, self.creature.y + self.creature.height + 1)

    if (tileTopRight and tileBottomRight) and (tileTopRight.id == TILE_GROUND or tileBottomRight.id == TILE_SKY) then
      self.creature.x = (tileBottomRight.x - 1) * TILE_SIZE - self.creature.width
      self.direction = "left"
      self.creature.direction = self.direction
    end
  else
    self.creature.x = self.creature.x - CREATURE_MOVE_SPEED * dt

    local tileTopLeft = self.tileMap:pointToTile(self.creature.x, self.creature.y)
    local tileBottomLeft = self.tileMap:pointToTile(self.creature.x, self.creature.y + self.creature.height + 1)

    if
      ((tileTopLeft and tileBottomLeft) and (tileTopLeft.id == TILE_GROUND or tileBottomLeft.id == TILE_SKY) or
        self.creature.x < 0)
     then
      self.creature.x = tileBottomLeft and (tileBottomLeft.x - 1) * TILE_SIZE + tileBottomLeft.width or 0
      self.direction = "right"
      self.creature.direction = self.direction
    end
  end

  if math.abs(self.player.x - self.creature.x) < CREATURE_CHASING_RANGE then
    self.creature:changeState("chasing")
  end

  if math.abs(self.player.x - self.creature.x) > VIRTUAL_WIDTH then
    self.creature:changeState("idle")
  end
end
