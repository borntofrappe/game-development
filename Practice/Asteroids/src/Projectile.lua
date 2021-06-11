Projectile = Class {}

local RADIUS = 2.5
local LIFESPAN = 0.9
local SPEED = 250

function Projectile:init(x, y, angle)
  self.x = x
  self.y = y
  self.r = RADIUS

  self.dx = math.sin(angle) * SPEED
  self.dy = -math.cos(angle) * SPEED

  self.time = 0
  self.removed = false
end

function Projectile:update(dt)
  if not self.removed then
    self.time = self.time + dt
    if self.time >= LIFESPAN then
      self.removed = true
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
  end

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

function Projectile:collides(asteroid)
  return ((self.x - asteroid.x) ^ 2 + (self.y - asteroid.y) ^ 2) ^ 0.5 < self.r + asteroid.r
end

function Projectile:render()
  love.graphics.circle("fill", self.x, self.y, self.r)
end
