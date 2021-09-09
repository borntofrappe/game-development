PlayerLoseState = BaseState:new()

local PLAYER_ANIMATION_INTERVAL = 0.15

function PlayerLoseState:new(player)
  player.currentAnimation = Animation:new({5, 1}, PLAYER_ANIMATION_INTERVAL)

  local this = {
    ["player"] = player
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerLoseState:update(dt)
  self.player.currentAnimation:update(dt)

  -- debugging
  if love.keyboard.waspressed("d") then
    self.player:changeState("idle")
  end
end
