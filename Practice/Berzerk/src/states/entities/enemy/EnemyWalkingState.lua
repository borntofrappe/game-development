EnemyWalkingState = BaseState:new()

function EnemyWalkingState:new(enemy, direction)
  local this = {
    ["enemy"] = enemy
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyWalkingState:update(dt)
  self.enemy.currentAnimation:update(dt)
end
