EnemyIdleState = BaseState:new()

local ENEMY_DECISION_INTERVAL = {2, 5}
local ENEMY_WALKING_ODDS = {2, 5}
local ENEMY_WALKING_DURATION = {3, 6}

function EnemyIdleState:new(enemy)
  local this = {
    ["enemy"] = enemy,
    ["timer"] = 0,
    ["odds"] = love.math.random(ENEMY_WALKING_ODDS[1], ENEMY_WALKING_ODDS[2]),
    ["interval"] = love.math.random(ENEMY_DECISION_INTERVAL[1], ENEMY_DECISION_INTERVAL[2]),
    ["duration"] = love.math.random(ENEMY_WALKING_DURATION[1], ENEMY_WALKING_DURATION[2])
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
    if love.math.random(self.odds) == 1 then
      local directions = {"left", "right", "up", "down"}
      self.enemy:changeState(
        "walking-" .. directions[love.math.random(#directions)],
        {
          ["duration"] = self.duration
        }
      )
    end
  end
end
