PlayerWalkingState = Class({__includes = BaseState})

function PlayerWalkingState:init(player)
  self.player = player
  self.animation =
    Animation(
    {
      frames = {10, 11},
      interval = 0.1
    }
  )

  self.player.currentAnimation = self.animation
end

function PlayerWalkingState:update(dt)
  self.player.currentAnimation:update(dt)

  if not love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
    self.player:changeState("idle")
  end

  if love.keyboard.wasPressed("space") then
    self.player:changeState("jump")
  end

  if love.keyboard.isDown("left") then
    self.player.direction = "left"
    self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
  elseif love.keyboard.isDown("right") then
    self.player.direction = "right"
    self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
  end
end
