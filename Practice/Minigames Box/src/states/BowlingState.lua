BowlingState = BaseState:new()

local BALL_SPEED = 260

function BowlingState:enter()
  self.state = "launching"

  self.ball = {
    ["x"] = WINDOW_WIDTH / 4,
    ["y"] = WINDOW_HEIGHT / 2,
    ["r"] = 20,
    ["dx"] = 0,
    ["dy"] = 0
  }

  local pins = {}

  self.arrow = {
    ["x0"] = self.ball.x,
    ["y0"] = self.ball.y,
    ["x1"] = self.ball.r * 1.5,
    ["x2"] = self.ball.r * 1.5 + 30,
    ["flap"] = 10
  }

  local columns = 3
  local rows = 1
  local r = 10
  local xStart = WINDOW_WIDTH * 3 / 4
  local yStart = WINDOW_HEIGHT / 2
  for column = 1, columns do
    for row = 1, rows do
      local pin = {
        ["x"] = xStart + (column - (columns - 1) / 2 - 1) * r * 2.5,
        ["y"] = yStart + (row - (rows - 1) / 2 - 1) * r * 2.5,
        ["r"] = r
      }
      table.insert(pins, pin)
    end
    rows = rows + 1
  end

  self.pins = pins

  self.angle = 0
  self.dAngle = 50
  self.directionAngle = math.random(2) == 1 and 1 or -1
end

function BowlingState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") and self.state == "launching" then
    self.ball.dx = math.cos(math.rad(self.angle)) * BALL_SPEED
    self.ball.dy = math.sin(math.rad(self.angle)) * BALL_SPEED
    self.state = "launched"
  end

  if self.state == "launched" then
    self.ball.x = self.ball.x + self.ball.dx * dt
    self.ball.y = self.ball.y + self.ball.dy * dt
  end

  if self.state == "launching" then
    self.angle = self.angle + self.dAngle * dt * self.directionAngle
    if self.angle >= 45 then
      self.angle = 45
      self.directionAngle = -1
    end

    if self.angle <= -45 then
      self.angle = -45
      self.directionAngle = 1
    end
  end
end

function BowlingState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.circle("fill", self.ball.x, self.ball.y, self.ball.r)

  for i, pin in pairs(self.pins) do
    love.graphics.circle("fill", pin.x, pin.y, pin.r)
  end

  if self.state == "launching" then
    love.graphics.setLineWidth(4)
    love.graphics.translate(self.arrow.x0, self.arrow.y0)
    love.graphics.rotate(math.rad(self.angle))
    love.graphics.line(self.arrow.x1, 0, self.arrow.x2, 0)
    love.graphics.line(self.arrow.x2, 0, self.arrow.x2 - self.arrow.flap, -self.arrow.flap)
    love.graphics.line(self.arrow.x2, 0, self.arrow.x2 - self.arrow.flap, self.arrow.flap)
  end
end
