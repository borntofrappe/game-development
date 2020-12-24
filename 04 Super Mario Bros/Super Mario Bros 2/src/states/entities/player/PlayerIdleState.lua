PlayerIdleState = Class({__includes = BaseState})

function PlayerIdleState:init(player)
  self.player = player
  self.animation =
    Animation(
    {
      frames = {1},
      interval = 1
    }
  )

  self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)
  if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
    self.player:changeState("walking")
  end

  if love.keyboard.wasPressed("space") then
    self.player:changeState("jump")
  end
end
