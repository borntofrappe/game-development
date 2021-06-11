Asteroid = Class {}

local SPEED_MIN = 20
local SPEED_MAX = 90
local RADIUS_BASE = 4
local RADIUS_TYPE = 4
local POINTS_TYPE = 50
local TYPES = 3

function Asteroid:init(x, y, type, speed_min)
  self.x = x or math.random(0, WINDOW_WIDTH)
  self.y = y or math.random(0, WINDOW_HEIGHT)
  self.type = type or TYPES
  self.points = (TYPES - (self.type - 1)) * POINTS_TYPE
  self.r = RADIUS_BASE + (self.type - 1) * RADIUS_TYPE

  self.speed = math.random(speed_min or SPEED_MIN, SPEED_MAX)
  local angle = math.rad(math.random(360))

  self.dx = math.cos(angle) * self.speed
  self.dy = math.sin(angle) * self.speed
end

function Asteroid:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x < -self.r then
    self.x = WINDOW_WIDTH + self.r
  end

  if self.x > WINDOW_WIDTH + self.r then
    self.x = -self.r
  end

  if self.y < -self.r then
    self.y = WINDOW_HEIGHT + self.r
  end

  if self.y > WINDOW_WIDTH + self.r then
    self.y = -self.r
  end
end

function Asteroid:render()
  love.graphics.circle("fill", self.x, self.y, self.r)
end
