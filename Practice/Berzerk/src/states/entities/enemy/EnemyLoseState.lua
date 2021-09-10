EnemyLoseState = BaseState:new()

local ENEMY_IN_PLAY_DELAY = 0.3

function EnemyLoseState:new(enemy)
  local this = {
    ["enemy"] = enemy
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyLoseState:enter()
  self.enemy.currentAnimation.interval = ENEMY_IN_PLAY_DELAY / #self.enemy.currentAnimation.frames

  Timer:after(
    ENEMY_IN_PLAY_DELAY,
    function()
      self.enemy.inPlay = false
    end
  )
end

function EnemyLoseState:update(dt)
  self.enemy.currentAnimation:update(dt)
end
