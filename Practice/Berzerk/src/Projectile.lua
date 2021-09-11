Projectile = {}

local PROJECTILE_BASE_SPEED = 30
local PROJECTILE_MULTIPLIER_SPEED = 3
local PROJECTILE_SIZES = {1, 4}
local PROJECTILE_INSET = {
  ["x"] = 6,
  ["y"] = 2
}

function Projectile:new(player)
  local dx
  if player.dx == 0 and player.dy == 0 then
    dx = player.direction == "right" and PROJECTILE_BASE_SPEED or -PROJECTILE_BASE_SPEED
  else
    dx = player.dx * PROJECTILE_MULTIPLIER_SPEED
  end
  local dy = player.dy * PROJECTILE_MULTIPLIER_SPEED

  local width = dx == 0 and PROJECTILE_SIZES[1] or PROJECTILE_SIZES[2]
  local height = width == PROJECTILE_SIZES[1] and PROJECTILE_SIZES[2] or PROJECTILE_SIZES[1]

  local x =
    player.direction == "right" and player.x + PROJECTILE_INSET.x or
    player.x + player.width - PROJECTILE_INSET.x - width
  local y = dy >= 0 and player.y + PROJECTILE_INSET.y or player.y + PROJECTILE_INSET.y - height

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
