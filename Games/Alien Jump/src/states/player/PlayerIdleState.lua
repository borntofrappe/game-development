PlayerIdleState = Class {__includes = BaseState}

function PlayerIdleState:init(player)
  self.player = player
  self.animation = ALIEN_ANIMATION["idle"]
  self.player.currentAnimation = self.animation
end
