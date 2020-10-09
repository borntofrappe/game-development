PlayerIdleState = Class({__includes = BaseState})

function PlayerIdleState:init(player)
  self.player = player
  self.animation = Animation({["frames"] = {2}, ["interval"] = 1})
  self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)
  if love.keyboard.wasPressed("up") then
    self.player.direction = "up"
    self.player:changeState("walking")
  elseif love.keyboard.wasPressed("right") then
    self.player.direction = "right"
    self.player:changeState("walking")
  elseif love.keyboard.wasPressed("down") then
    self.player.direction = "down"
    self.player:changeState("walking")
  elseif love.keyboard.wasPressed("left") then
    self.player.direction = "left"
    self.player:changeState("walking")
  end
end
