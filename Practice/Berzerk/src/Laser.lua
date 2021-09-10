Laser = {}

local LASER_UPDATE_SPEED = 40
local LASER_UPDATE_SPEEDS = {
  ["left"] = {
    ["dx"] = -LASER_UPDATE_SPEED,
    ["dy"] = 0
  },
  ["right"] = {
    ["dx"] = LASER_UPDATE_SPEED,
    ["dy"] = 0
  },
  ["up"] = {
    ["dx"] = 0,
    ["dy"] = -LASER_UPDATE_SPEED
  },
  ["down"] = {
    ["dx"] = 0,
    ["dy"] = LASER_UPDATE_SPEED
  }
}
local LASER_SIZES = {1, 4}
local LASER_INSET = {
  ["x"] = 4,
  ["y"] = 2
}

function Laser:new(enemy, direction)
  local dx = LASER_UPDATE_SPEEDS[direction].dx
  local dy = LASER_UPDATE_SPEEDS[direction].dy

  local width = dx == 0 and LASER_SIZES[1] or LASER_SIZES[2]
  local height = width == LASER_SIZES[1] and LASER_SIZES[2] or LASER_SIZES[1]

  local x = enemy.x + LASER_INSET.x - width / 2
  local y = enemy.y + LASER_INSET.y - height / 2

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
