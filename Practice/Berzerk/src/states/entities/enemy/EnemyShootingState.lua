EnemyShootingState = BaseState:new()

local ENEMY_STATE_DELAY = 0.2

function EnemyShootingState:new(enemy)
  local this = {
    ["enemy"] = enemy
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyShootingState:enter()
  if self.enemy.ammunitions > 0 then
    local direction
    local dx = self.enemy.level.player.x - self.enemy.x
    local dy = self.enemy.level.player.y - self.enemy.y
    if math.abs(dx) < math.abs(dy) then
      direction = dy > 0 and "down" or "up"
    else
      direction = dx > 0 and "right" or "left"
    end

    local laser = Laser:new(self.enemy, direction)
    table.insert(self.enemy.lasers, laser)
    self.enemy.ammunitions = self.enemy.ammunitions - 1
  end

  Timer:after(
    ENEMY_STATE_DELAY,
    function()
      self.enemy:changeState("idle")
    end
  )
end
