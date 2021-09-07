EnemyIdleState = BaseState:new()

function EnemyIdleState:new(enemy)
  local this = {
    ["enemy"] = enemy
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyIdleState:update(dt)
  self.enemy.currentAnimation:update(dt)
end
