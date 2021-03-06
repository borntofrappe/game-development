Player = Class {}

local ANGLE_FRICTION = 0.005
local ANGLE_CHANGE = 0.07

local SPEED_FRICTION = 1.5
local SPEED_CHANGE = 150

local RADIUS = 8
local LIVES = 3

function Player:init(x, y, angle)
  self.x = x or WINDOW_WIDTH / 2
  self.y = y or WINDOW_HEIGHT / 2
  self.r = RADIUS

  self.points = 0
  self.lives = LIVES

  self.dx = 0
  self.dy = 0

  self.angle = angle or 0
  self.dangle = 0

  self.projectiles = {}
end

function Player:reset()
  self.x = WINDOW_WIDTH / 2
  self.y = WINDOW_HEIGHT / 2

  self.dx = 0
  self.dy = 0

  self.angle = 0
  self.dangle = 0
end

function Player:teleport()
  self.x = math.random(0, WINDOW_WIDTH)
  self.y = math.random(0, WINDOW_HEIGHT)
  self.angle = math.rad(math.random(360))

  self.dx = 0
  self.dy = 0
  self.dangle = 0
end

function Player:collides(asteroid)
  return ((self.x - asteroid.x) ^ 2 + (self.y - asteroid.y) ^ 2) ^ 0.5 < self.r + asteroid.r
end

function Player:update(dt)
  self.angle = (self.angle + self.dangle) % (math.pi * 2)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.dangle > 0 then
    self.dangle = math.max(0, self.dangle - ANGLE_FRICTION)
  end
  if self.dangle < 0 then
    self.dangle = math.min(0, self.dangle + ANGLE_FRICTION)
  end

  if love.keyboard.isDown("right") then
    self.dangle = ANGLE_CHANGE
  end
  if love.keyboard.isDown("left") then
    self.dangle = -ANGLE_CHANGE
  end

  if self.dx > 0 then
    self.dx = math.max(0, self.dx - SPEED_FRICTION)
  end
  if self.dx < 0 then
    self.dx = math.min(0, self.dx + SPEED_FRICTION)
  end

  if self.dy > 0 then
    self.dy = math.max(0, self.dy - SPEED_FRICTION)
  end
  if self.dy < 0 then
    self.dy = math.min(0, self.dy + SPEED_FRICTION)
  end

  if love.keyboard.isDown("up") then
    self.dx = math.sin(self.angle) * SPEED_CHANGE
    self.dy = math.cos(self.angle) * SPEED_CHANGE * -1
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

  for k, projectile in pairs(self.projectiles) do
    projectile:update(dt)

    if projectile.removed then
      table.remove(self.projectiles, k)
    end
  end
end

function Player:destroy()
  self.lives = self.lives - 1
  return self.lives == 0
end

function Player:score(points)
  self.points = self.points + points
end

function Player:shoot()
  table.insert(self.projectiles, Projectile(self.x, self.y, self.angle))
end

function Player:render()
  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end

  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)

  if love.keyboard.isDown("up") then
    love.graphics.polygon(
      "line",
      math.floor(-self.r / 2),
      math.floor(self.r),
      math.floor(self.r / 2),
      math.floor(self.r),
      0,
      math.floor(self.r * 3 / 2)
    )
  end

  love.graphics.polygon(
    "line",
    math.floor(-self.r),
    math.floor(self.r),
    math.floor(self.r),
    math.floor(self.r),
    0,
    math.floor(-self.r)
  )
  love.graphics.pop()
end
