PlayerWalkState = Class {__includes = BaseState}

function PlayerWalkState:init(player)
  self.player = player
  self.animation = ALIEN_ANIMATION["walk"]
  self.player.currentAnimation = self.animation
end

function PlayerWalkState:update(dt)
  self.player.currentAnimation:update(dt)
end
