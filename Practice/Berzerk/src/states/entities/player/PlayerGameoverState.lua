PlayerGameoverState = BaseState:new()

function PlayerGameoverState:new(player)
  player.currentAnimation = Animation:new({5, 1}, 0.15)

  local this = {
    ["player"] = player
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerGameoverState:update(dt)
  self.player.currentAnimation:update(dt)

  -- debugging
  if love.keyboard.waspressed("g") then
    self.player:changeState("idle")
  end
end
