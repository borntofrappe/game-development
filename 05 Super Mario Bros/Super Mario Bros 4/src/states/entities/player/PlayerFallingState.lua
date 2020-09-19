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

  local tileBottomLeft = self.player.map:pointToTile(self.player.x + 2, self.player.y + self.player.height)
  local tileBottomRight =
    self.player.map:pointToTile(self.player.x + self.player.width - 2, self.player.y + self.player.height)

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
    self.player:checkLeftCollision()
  elseif love.keyboard.isDown("right") then
    self.player.direction = "right"
    self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
    self.player:checkRightCollision()
  end
end
