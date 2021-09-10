EnemyWalkingState = BaseState:new()

local ENEMY_UPDATE_SPEED = 10
local ENEMY_WALKING_DURATION = {1, 3}

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

  self.duration = love.math.random(ENEMY_WALKING_DURATION[1], ENEMY_WALKING_DURATION[2])
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

  if self.enemy:collides(self.enemy.level.player, 1) then
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

  local isColliding = false

  for k, wall in pairs(self.enemy.level.walls) do
    if self.enemy:collides(wall) then
      isColliding = true
      break
    end
  end

  if isColliding then
    self.enemy.inPlay = false
  end

  self.enemy.x =
    math.max(
    self.enemy.level.room.x,
    math.min(
      self.enemy.level.room.x + self.enemy.level.room.width - self.enemy.width,
      self.enemy.x + self.enemy.dx * dt
    )
  )
  self.enemy.y =
    math.max(
    self.enemy.level.room.y,
    math.min(
      self.enemy.level.room.y + self.enemy.level.room.height - self.enemy.height,
      self.enemy.y + self.enemy.dy * dt
    )
  )
end
