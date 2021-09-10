EnemyIdleState = BaseState:new()

local ENEMY_DECISION_INTERVAL = {0, 5}
local ENEMY_DECISIONS = {
  ["idle"] = {4, 7},
  ["walking"] = {2, 6},
  ["shooting"] = {2, 4}
}

function EnemyIdleState:new(enemy)
  local this = {
    ["enemy"] = enemy,
    ["timer"] = 0,
    ["interval"] = love.math.random(ENEMY_DECISION_INTERVAL[1], ENEMY_DECISION_INTERVAL[2])
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyIdleState:enter()
  self.enemy.dx = 0
  self.enemy.dy = 0
end

function EnemyIdleState:update(dt)
  self.enemy.currentAnimation:update(dt)

  self.timer = self.timer + dt
  if self.timer >= self.interval then
    self.timer = self.timer % self.interval

    local decisions = {}
    local directions = {"left", "right", "up", "down"}

    for k, enemyDecision in pairs(ENEMY_DECISIONS) do
      local n = love.math.random(enemyDecision[1], enemyDecision[2])

      for i = 1, n do
        local decision = k
        if decision == "walking" then
          if self.enemy.level and love.math.random(2) == 1 then
            local direction
            local dx = self.enemy.level.player.x - self.enemy.x
            local dy = self.enemy.level.player.y - self.enemy.y
            if math.abs(dx) < math.abs(dy) then
              direction = dy > 0 and "down" or "up"
            else
              direction = dx > 0 and "right" or "left"
            end

            decision = decision .. "-" .. direction
          else
            decision = decision .. "-" .. directions[love.math.random(#directions)]
          end
        end
        table.insert(decisions, decision)
      end
    end

    local decision = decisions[love.math.random(#decisions)]
    if decision ~= "idle" then
      self.enemy:changeState(decision)
    else
    end
  end
end
