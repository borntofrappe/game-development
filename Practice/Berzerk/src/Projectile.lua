Projectile = {}

local PROJECTILE_BASE_SPEED = 30
local PROJECTILE_MULTIPLIER_SPEED = 3

function Projectile:new(player)
  local dx
  if player.dx == 0 and player.dy == 0 then
    dx = player.direction == "right" and PROJECTILE_BASE_SPEED or -PROJECTILE_BASE_SPEED
  else
    dx = player.dx * PROJECTILE_MULTIPLIER_SPEED
  end
  local dy = player.dy * PROJECTILE_MULTIPLIER_SPEED

  local width = dx == 0 and 1 or 4
  local height = width == 4 and 1 or 4

  local x = player.direction == "right" and player.x + 6 or player.x + 1 - width
  local y = player.y + 3 - height

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

function Projectile:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x > VIRTUAL_WIDTH or self.x < -self.width or self.y > VIRTUAL_WIDTH or self.y < -self.height then
    self.inPlay = false
  end
end

function Projectile:render()
  love.graphics.setColor(0.949, 0.545, 0.694)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Projectile:collides(target)
  if target.x + target.width < self.x or target.x > self.x + self.width then
    return false
  end

  if target.y + target.height < self.y or target.y > self.y + self.height then
    return false
  end

  return true
end
