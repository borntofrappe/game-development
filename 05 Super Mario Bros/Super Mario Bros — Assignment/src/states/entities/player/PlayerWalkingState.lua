PlayerWalkingState = Class({__includes = BaseState})

function PlayerWalkingState:init(player)
  self.player = player
  self.animation =
    Animation(
    {
      frames = {10, 11},
      interval = 0.1
    }
  )

  self.player.currentAnimation = self.animation
end

function PlayerWalkingState:update(dt)
  self.player.currentAnimation:update(dt)

  if not love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
    self.player:changeState("idle")
  else
    local tileBottomLeft = self.player.level.tileMap:pointToTile(self.player.x + 2, self.player.y + self.player.height)
    local tileBottomRight =
      self.player.level.tileMap:pointToTile(self.player.x + self.player.width - 2, self.player.y + self.player.height)

    local collidedObjects = self.player:checkObjectCollision()

    if
      #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and
        (tileBottomLeft.id == TILE_SKY and tileBottomRight.id == TILE_SKY)
     then
      self.player:changeState("falling")
    elseif love.keyboard.isDown("left") then
      self.player.direction = "left"
      self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
      self.player.y = self.player.y - 1
      self.player:checkLeftCollision(dt)
      self.player.y = self.player.y + 1
    elseif love.keyboard.isDown("right") then
      self.player.direction = "right"
      self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
      self.player.y = self.player.y - 1
      self.player:checkRightCollision(dt)
      self.player.y = self.player.y + 1
    end
  end

  if love.keyboard.wasPressed("space") then
    self.player:changeState("jump")
  end

  for k, object in pairs(self.player.level.objects) do
    if object.isConsumable and object:collides(self.player) then
      object.onConsume(object, self.player)
      if object.isKey then
        for j, obj in pairs(self.player.level.objects) do
          if obj.isLock then
            table.remove(self.player.level.objects, j)
            break
          end
        end
      end
      table.remove(self.player.level.objects, k)
    end
  end

  for k, entity in pairs(self.player.level.entities) do
    if entity:collides(self.player) then
      gSounds["death"]:play()
      gStateMachine:change("start")
    end
  end
end
