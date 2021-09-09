EnemyWalkingState = BaseState:new()

local ENEMY_UPDATE_SPEED = 8

function EnemyWalkingState:new(enemy, direction)
  local this = {
    ["enemy"] = enemy,
    ["direction"] = direction
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyWalkingState:enter(params)
  if self.direction == "right" then
    self.enemy.dx = ENEMY_UPDATE_SPEED
  elseif self.direction == "left" then
    self.enemy.dx = -ENEMY_UPDATE_SPEED
  elseif self.direction == "up" then
    self.enemy.dy = -ENEMY_UPDATE_SPEED
  elseif self.direction == "down" then
    self.enemy.dy = ENEMY_UPDATE_SPEED
  end

  self.duration = params.duration
end

function EnemyWalkingState:update(dt)
  self.enemy.currentAnimation:update(dt)

  self.duration = self.duration - dt

  if
    self.duration <= 0 or self.enemy.x <= 0 or self.enemy.x >= VIRTUAL_WIDTH - self.enemy.width or self.enemy.y <= 0 or
      self.enemy.y >= VIRTUAL_HEIGHT - self.enemy.height
   then
    self.enemy:changeState("idle")
  end

  local isColliding = false

  for k, wall in pairs(self.enemy.walls) do
    if self.enemy:collides(wall) then
      isColliding = true
      break
    end
  end

  if isColliding then
    self.enemy.inPlay = false
  end

  self.enemy.x = math.max(0, math.min(VIRTUAL_WIDTH - self.enemy.width, self.enemy.x + self.enemy.dx * dt))
  self.enemy.y = math.max(0, math.min(VIRTUAL_HEIGHT - self.enemy.height, self.enemy.y + self.enemy.dy * dt))
end
