CreatureIdleState = Class({__includes = BaseState})

function CreatureIdleState:init(player, creature)
  self.player = player
  self.creature = creature
  self.animation =
    Animation(
    {
      frames = {1},
      interval = 1
    }
  )
  self.creature.currentAnimation = self.animation
end

function CreatureIdleState:update(dt)
  if math.abs(self.player.x - self.creature.x) < VIRTUAL_WIDTH then
    self.creature:changeState("moving")
  end
end
