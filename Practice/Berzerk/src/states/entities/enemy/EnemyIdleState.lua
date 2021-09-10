EnemyIdleState = BaseState:new()

local ENEMY_DECISION_INTERVAL = {0, 5}
local ENEMY_DECISIONS = {
  ["idle"] = {4, 7},
  ["walking"] = {1, 3}
  -- ["shooting"] = {1, 3}
}

function EnemyIdleState:new(enemy)
  local this = {
    ["enemy"] = enemy
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyIdleState:enter()
  self.enemy.dx = 0
  self.enemy.dy = 0

  self.timer = 0
  self.interval = love.math.random(ENEMY_DECISION_INTERVAL[1], ENEMY_DECISION_INTERVAL[2])

  local decisions = {}
  local directions = {"left", "right", "up", "down"}

  for k, enemyDecision in pairs(ENEMY_DECISIONS) do
    local n = love.math.random(enemyDecision[1], enemyDecision[2])

    for i = 1, n do
      local decision = k
      if decision == "walking" then
        decision = decision .. "-" .. directions[love.math.random(#directions)]
      end
      table.insert(decisions, decision)
    end
  end
  self.decisions = decisions
end

function EnemyIdleState:update(dt)
  self.enemy.currentAnimation:update(dt)

  self.timer = self.timer + dt
  if self.timer >= self.interval then
    self.timer = self.timer % self.interval

    local decision = self.decisions[love.math.random(#self.decisions)]
    if decision ~= "idle" then
      self.enemy:changeState(decision)
    else
    end
  end
end
