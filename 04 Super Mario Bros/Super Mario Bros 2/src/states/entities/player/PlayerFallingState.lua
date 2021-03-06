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
  if love.keyboard.isDown("left") then
    self.player.direction = "left"
    self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
  elseif love.keyboard.isDown("right") then
    self.player.direction = "right"
    self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
  end

  if self.player.y > TILE_SIZE * (ROWS_SKY - 1) - self.player.height then
    self.player.dy = 0
    self.player.y = TILE_SIZE * (ROWS_SKY - 1) - self.player.height

    if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
      self.player:changeState("walking")
    else
      self.player:changeState("idle")
    end
  else
    self.player.dy = self.player.dy + GRAVITY
    self.player.y = self.player.y + (self.player.dy * dt)
  end
end
