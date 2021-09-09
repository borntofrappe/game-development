PlayerShootingState = BaseState:new()

local PLAYER_ANIMATION_DELAY = 0.15

function PlayerShootingState:new(player)
  player.currentAnimation = Animation:new({4}, 1)

  local this = {
    ["player"] = player,
    ["delay"] = PLAYER_ANIMATION_DELAY
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerShootingState:update(dt)
  self.delay = self.delay - dt

  if self.delay <= 0 then
    if
      love.keyboard.isDown("left") or love.keyboard.isDown("right") or love.keyboard.isDown("up") or
        love.keyboard.isDown("down")
     then
      self.player:changeState("walk")
    else
      self.player:changeState("idle")
    end
  end
end
