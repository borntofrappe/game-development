Paddle = Class{}

function Paddle:init(x, y, r)
  self.origin = {
    ["x"] = x,
    ["y"] = y
  }
  self.x = x
  self.y = y
  self.r = r
  self.isReady = false
  self.points = 0
  self.goal = 3

  self.dx = 0
end

function Paddle:reset()
  self.x = self.origin.x
  self.y = self.origin.y
end

function Paddle:update(dt)
  self.x = math.min(WINDOW_WIDTH - self.r, math.max(self.r, self.x + self.dx * dt))
end

function Paddle:render()
  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.circle('line', self.x, self.y, self.r)
  love.graphics.setColor(0.8, 0.93, 0.88)
  love.graphics.circle('fill', self.x, self.y, self.r * self.points / self.goal)
end