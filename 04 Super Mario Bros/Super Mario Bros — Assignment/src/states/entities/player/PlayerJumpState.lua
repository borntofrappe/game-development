PlayerJumpState = Class({__includes = BaseState})

function PlayerJumpState:init(player)
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

  self.player.dy = -PLAYER_JUMP_SPEED
  gSounds["jump"]:stop()
  gSounds["jump"]:play()
end

function PlayerJumpState:update(dt)
  self.player.dy = self.player.dy + GRAVITY
  self.player.y = self.player.y + (self.player.dy * dt)

  if self.player.dy >= 0 then
    self.player:changeState("falling")
  end

  if love.keyboard.isDown("left") then
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
        if object.isGoal then
          gSounds["new-level"]:play()
          gStateMachine:change(
            "play",
            {
              width = self.player.level.tileMap.width + 10,
              score = self.player.score
            }
          )
        end
        object.onCollide(object)
        self.player.y = (object.y - 1) * TILE_SIZE + object.height
        self.player.dy = 0
        self.player:changeState("falling")
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
  if love.keyboard.isDown("right") then
    self.player.x = self.player.x + 1
  end

  for k, entity in pairs(self.player.level.entities) do
    if entity:collides(self.player) then
      gSounds["death"]:play()
      gStateMachine:change("start")
    end
  end
end
