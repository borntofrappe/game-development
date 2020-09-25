PlayerFallingState = Class({__includes = BaseState})

function PlayerFallingState:init(player)
  self.player = player
  self.gravity = GRAVITY

  self.animation =
    Animation(
    {
      frames = {3},
      interval = 1
    }
  )

  self.player.currentAnimation = self.animation
end

function PlayerFallingState:update(dt)
  self.player.dy = self.player.dy + GRAVITY
  self.player.y = self.player.y + (self.player.dy * dt)

  local tileBottomLeft = self.player.level.tileMap:pointToTile(self.player.x + 2, self.player.y + self.player.height)
  local tileBottomRight =
    self.player.level.tileMap:pointToTile(self.player.x + self.player.width - 2, self.player.y + self.player.height)

  if (tileBottomLeft and tileBottomRight) and (tileBottomLeft.id == TILE_GROUND or tileBottomRight.id == TILE_GROUND) then
    self.player.dy = 0
    self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height

    if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
      self.player:changeState("walking")
    else
      self.player:changeState("idle")
    end
  elseif love.keyboard.isDown("left") then
    self.player.direction = "left"
    self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
    self.player:checkLeftCollision(dt)
  elseif love.keyboard.isDown("right") then
    self.player.direction = "right"
    self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
    self.player:checkRightCollision(dt)
  end

  if love.keyboard.isDown("right") then
    self.player.x = self.player.x - 1
  end

  for k, object in pairs(self.player.level.objects) do
    if object:collides(self.player) then
      if object.isSolid then
        self.player.y = (object.y - 1) * TILE_SIZE - self.player.height
        self.player.dy = 0
        if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
          self.player:changeState("walking")
        else
          self.player:changeState("idle")
        end
      elseif object.isConsumable then
        object.onConsume(object, self.player)
        table.remove(self.player.level.objects, k)
        if object.isKey then
          for j, obj in pairs(self.player.level.objects) do
            if obj.isLock then
              obj.onDisappear(obj)
              table.remove(self.player.level.objects, j)
              break
            end
          end
        end
      end
    end
  end

  for k, entity in pairs(self.player.level.entities) do
    if entity:collides(self.player) then
      gSounds["kill"]:play()
      self.player.score = self.player.score + 100
      table.remove(self.player.level.entities, k)
      self.player:changeState("jump", true)
    end
  end

  if love.keyboard.isDown("right") then
    self.player.x = self.player.x + 1
  end

  if self.player.y + self.player.height >= VIRTUAL_HEIGHT then
    gSounds["chasm"]:play()
    gStateMachine:change("start")
  end
end
