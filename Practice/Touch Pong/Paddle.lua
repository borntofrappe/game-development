Paddle = Class {}

function Paddle:init(x, y, r)
  self.origin = {
    ["x"] = x,
    ["y"] = y
  }
  self.x = x
  self.y = y
  self.r = r
  self.innerRadius = 0
  self.dx = 0
end

function Paddle:reset()
  self.x = self.origin.x
  self.y = self.origin.y
end

function Paddle:update(dt)
  self.x = self.x + self.dx * dt

  if self.dx < 0 and self.x < -self.r then
    self.x = WINDOW_WIDTH + self.r
  end

  if self.dx > 0 and self.x > WINDOW_WIDTH + self.r then
    self.x = -self.r
  end
end

function Paddle:render()
  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.circle("line", self.x, self.y, self.r)
  love.graphics.circle("fill", self.x, self.y, self.innerRadius)
end
