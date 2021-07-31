CatchState = BaseState:new()

function CatchState:enter()
  local width = 45
  local height = 45
  local points = {}
  local xStart = PLAYING_WIDTH / 2
  local yStart = PLAYING_HEIGHT * 3 / 4 - height / 2
  self.lineWidth = 8
  self.width = width
  self.xStart = xStart
  self.yStart = yStart

  local n = 20 -- the higher the smoother
  for i = 0, n do
    local angle = math.rad(i * 180 / n)
    local x = math.cos(angle) * width
    local y = math.sin(angle) * height

    table.insert(points, x)
    table.insert(points, y)
  end

  self.points = points

  local balls = {}
  local r = 15
  for i = 1, 1 do
    local x = math.random(r, PLAYING_WIDTH - r)
    local y = math.random(r, math.floor(PLAYING_HEIGHT / 2 - r))
    local ball = {
      ["x"] = x,
      ["y"] = y,
      ["r"] = r
    }

    table.insert(balls, ball)
  end

  self.balls = balls
end

function CatchState:update(dt)
  local x, y = love.mouse:getPosition()
  if
    x > WINDOW_PADDING and x < WINDOW_WIDTH - WINDOW_PADDING and y > WINDOW_PADDING and
      y < WINDOW_HEIGHT - WINDOW_PADDING
   then
    self.xStart =
      math.max(self.width + self.lineWidth / 2, math.min(PLAYING_WIDTH - self.width - self.lineWidth / 2, x))
  end
end

function CatchState:render()
  love.graphics.setColor(0.38, 0.35, 0.27)
  for _, ball in ipairs(self.balls) do
    love.graphics.circle("fill", ball.x, ball.y, ball.r)
  end

  love.graphics.translate(self.xStart, self.yStart)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.setColor(0.28, 0.25, 0.18)
  love.graphics.line(self.points)
end
