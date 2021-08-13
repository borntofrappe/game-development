CreatureStuckedState = Class({__includes = BaseState})

function CreatureStuckedState:init(player, creature)
  self.player = player
  self.creature = creature
  self.animation =
    Animation(
    {
      frames = {1, 2},
      interval = 0.5
    }
  )
  self.creature.currentAnimation = self.animation
end

function CreatureStuckedState:update(dt)
  self.creature.currentAnimation:update(dt)

  if math.abs(self.player.x - self.creature.x) < CREATURE_CHASING_RANGE then
    self.creature:changeState("chasing")
  end
end
