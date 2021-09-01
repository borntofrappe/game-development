PlayerShootingState = BaseState:new()

function PlayerShootingState:new(player)
  player.currentAnimation = Animation:new({4}, 1)

  local this = {
    ["player"] = player,
    ["delay"] = 0.15
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerShootingState:update(dt)
  self.delay = self.delay - dt

  if self.delay <= 0 then
    self.player:changeState("idle")
  end
end
