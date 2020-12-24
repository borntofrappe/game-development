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
end

function PlayerJumpState:update(dt)
  if self.player.dy > 0 then
    self.player:changeState("falling")
  end

  if love.keyboard.isDown("left") then
    self.player.direction = "left"
    self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
  elseif love.keyboard.isDown("right") then
    self.player.direction = "right"
    self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
  end

  self.player.dy = self.player.dy + GRAVITY
  self.player.y = self.player.y + (self.player.dy * dt)
end
