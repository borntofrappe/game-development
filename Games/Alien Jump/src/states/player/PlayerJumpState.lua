PlayerJumpState = Class {__includes = BaseState}

function PlayerJumpState:init(player)
  self.player = player
  self.gravity = GRAVITY
  self.animation = ALIEN_ANIMATION["jump"]
  self.player.currentAnimation = self.animation

  self.player.dy = -ALIEN_JUMP_SPEED
end

function PlayerJumpState:update(dt)
  self.player.dy = self.player.dy + self.gravity
  self.player.y = self.player.y + (self.player.dy * dt)

  if self.player.y > VIRTUAL_HEIGHT - self.player.height then
    self.player.y = VIRTUAL_HEIGHT - self.player.height
    self.player:changeState("walk")
  end
end
