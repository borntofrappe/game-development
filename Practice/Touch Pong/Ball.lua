Ball = Class{}

function Ball:init(x, y, r)
  self.origin = {
    ["x"] = x,
    ["y"] = y
  }
  self.x = x
  self.y = y
  self.r = r

  local dx = love.math.random(50, 100)
  local dy = love.math.random(50, 100)
  self.dx = love.math.random() > 0.5 and dx or dx * -1
  self.dy = love.math.random() > 0.5 and dy or dy * -1
end

function Ball:reset()
  self.x = self.origin.x
  self.y = self.origin.y

  local dx = love.math.random(50, 100)
  local dy = love.math.random(50, 100)
  self.dx = love.math.random() > 0.5 and dx or dx * -1
  self.dy = love.math.random() > 0.5 and dy or dy * -1
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x > WINDOW_WIDTH - self.r then 
    self.x = WINDOW_WIDTH - self.r
    self.dx = self.dx * -1
  end

  if self.x < self.r then 
    self.x = self.r
    self.dx = self.dx * -1
  end
end

function Ball:render()
  love.graphics.setColor(0.8, 0.93, 0.88, 1)
  love.graphics.circle('fill', self.x, self.y, self.r)
end