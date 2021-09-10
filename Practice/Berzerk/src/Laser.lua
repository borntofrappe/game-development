Laser = {}

local LASER_SPEED = 40

function Laser:new(enemy, direction)
  local dx = 0
  local dy = 0
  if direction == "left" then
    dx = -LASER_SPEED
  elseif direction == "right" then
    dx = LASER_SPEED
  elseif direction == "up" then
    dy = -LASER_SPEED
  elseif direction == "down" then
    dy = LASER_SPEED
  end

  local width = dy == 0 and 4 or 1
  local height = width == 4 and 1 or 4

  local x = enemy.x + enemy.width / 2 - width / 2
  local y = enemy.y + 2

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["dx"] = dx,
    ["dy"] = dy,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Laser:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x > VIRTUAL_WIDTH or self.x < -self.width or self.y > VIRTUAL_WIDTH or self.y < -self.height then
    self.inPlay = false
  end
end

function Laser:render()
  love.graphics.setColor(0.824, 0.824, 0.824)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Laser:collides(target)
  if target.x + target.width < self.x or target.x > self.x + self.width then
    return false
  end

  if target.y + target.height < self.y or target.y > self.y + self.height then
    return false
  end

  return true
end
