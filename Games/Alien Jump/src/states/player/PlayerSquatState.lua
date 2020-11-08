PlayerSquatState = Class {__includes = BaseState}

function PlayerSquatState:init(player)
  self.player = player
  self.animation = ALIEN_ANIMATION["squat"]
  self.player.currentAnimation = self.animation
end
