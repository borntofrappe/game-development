EnemyWalkingState = BaseState:new()

local ENEMY_UPDATE_SPEED = 10
local ENEMY_STATE_DELAY = {1, 4}

function EnemyWalkingState:new(enemy, direction)
  local this = {
    ["enemy"] = enemy,
    ["direction"] = direction
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyWalkingState:enter()
  if self.direction == "right" then
    self.enemy.dx = ENEMY_UPDATE_SPEED
  elseif self.direction == "left" then
    self.enemy.dx = -ENEMY_UPDATE_SPEED
  elseif self.direction == "up" then
    self.enemy.dy = -ENEMY_UPDATE_SPEED
  elseif self.direction == "down" then
    self.enemy.dy = ENEMY_UPDATE_SPEED
  end

  self.delay = love.math.random(ENEMY_STATE_DELAY[1], ENEMY_STATE_DELAY[2])
end

function EnemyWalkingState:update(dt)
  self.enemy.currentAnimation:update(dt)

  self.delay = self.delay - dt

  if self.delay <= 0 then
    self.enemy:changeState("idle")
  end

  if self.enemy:collides(self.enemy.level.player) then
    self.enemy.level.player:changeState("lose")
    self.enemy:changeState("idle")
  end

  for k, enemy in pairs(self.enemy.level.enemies) do
    if self.enemy:collides(enemy) and (self.enemy.x ~= enemy.x or self.enemy.y ~= enemy.y) then
      self.enemy:changeState("idle")
      enemy:changeState("idle")
      break
    end
  end

  for k, wall in pairs(self.enemy.level.walls) do
    if self.enemy:collides(wall) then
      self.enemy:changeState("lose")
      break
    end
  end

  if
    self.enemy.x < self.enemy.level.room.x or
      self.enemy.x + self.enemy.width > self.enemy.level.room.x + self.enemy.level.room.width or
      self.enemy.y < self.enemy.level.room.y or
      self.enemy.y + self.enemy.height > self.enemy.level.room.y + self.enemy.level.room.height
   then
    self.enemy.inPlay = false
  end

  self.enemy.x = self.enemy.x + self.enemy.dx * dt
  self.enemy.y = self.enemy.y + self.enemy.dy * dt
end
