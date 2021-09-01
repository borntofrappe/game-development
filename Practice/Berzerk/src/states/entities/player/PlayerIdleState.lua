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
  if love.keyboard.waspressed("right") then
    self.player:changeState("walk")
  elseif love.keyboard.waspressed("left") then
    self.player:changeState("walk")
  end

  if love.keyboard.waspressed("return") then
    self.player:changeState("shoot")
  end

  -- debugging
  if love.keyboard.waspressed("g") then
    self.player:changeState("gameover")
  end
end
