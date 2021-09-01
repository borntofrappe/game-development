PlayerWalkingState = BaseState:new()

function PlayerWalkingState:new(player)
  player.currentAnimation = Animation:new({2, 3}, 0.15)

  local this = {
    ["player"] = player
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerWalkingState:update(dt)
  self.player.currentAnimation:update(dt)

  if love.keyboard.isDown("right") then
    self.player.direction = "right"
  elseif love.keyboard.isDown("left") then
    self.player.direction = "left"
  else
    self.player:changeState("idle")
  end

  if love.keyboard.waspressed("return") then
    self.player:changeState("shoot")
  end
end
