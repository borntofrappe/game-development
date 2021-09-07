EnemyIdleState = BaseState:new()

function EnemyIdleState:new(enemy)
  enemy.currentAnimation = Animation:new({1, 2, 3, 4, 5, 6, 7, 8}, 0.2)

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
