PlayerIdleState = BaseState:new()

function PlayerIdleState:new(player)
  player.currentAnimation = Animation:new({1}, 1)

  local this = {
    ["player"] = player
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerIdleState:update(dt)
  if
    love.keyboard.waspressed("left") or love.keyboard.waspressed("right") or love.keyboard.waspressed("up") or
      love.keyboard.waspressed("down")
   then
    self.player:changeState("walk")
  end

  if love.keyboard.waspressed("return") then
    self.player:changeState("shoot")
  end
end
