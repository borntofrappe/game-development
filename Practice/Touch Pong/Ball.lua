Ball = Class{}

function Ball:init(x, y, r)
  self.origin = {
    ["x"] = x,
    ["y"] = y
  }
  self.x = x
  self.y = y
  self.r = r

  local dx = love.math.random(BALL_SPEED_MIN_X, BALL_SPEED_MAX_X)
  local dy = love.math.random(BALL_SPEED_MIN_Y, BALL_SPEED_MAX_Y)
  self.dx = love.math.random() > 0.5 and dx or dx * -1
  self.dy = love.math.random() > 0.5 and dy or dy * -1
end

function Ball:reset(side)
  self.x = self.origin.x
  self.y = self.origin.y

  local dx = love.math.random(BALL_SPEED_MIN_X, BALL_SPEED_MAX_X)
  local dy = love.math.random(BALL_SPEED_MIN_Y, BALL_SPEED_MAX_Y)
  self.dx = love.math.random() > 0.5 and dx or dx * -1

  if side then
    if side == 'top' then 
      self.dy = self.dy * -1
    end
  else
    self.dy = love.math.random() > 0.5 and dy or dy * -1
  end
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

function Ball:collides(paddle)
  return ((paddle.x - self.x) ^ 2 + (paddle.y - self.y) ^ 2) ^ 0.5 < paddle.r + self.r
end

function Ball:bounce(paddle)
  self.dy = self.dy * -1 * 1.1

  self.dx = love.math.random(BALL_SPEED_MIN_X, BALL_SPEED_MAX_X)

  --[[
    if (self.dx > 0 and self.x < paddle.x) or (self.dx < 0 and self.x > paddle.x) then 
      self.dx = self.dx * -1
    end
  --]]
  if (self.dx * (self.x - paddle.x) < 0) then 
    self.dx = self.dx * -1
  end
end

function Ball:render()
  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.circle('fill', self.x, self.y, self.r)
end