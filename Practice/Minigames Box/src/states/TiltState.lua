TiltState = BaseState:new()

function TiltState:enter()
  local width = 220
  local height = 8
  local platform = {
    ["x"] = PLAYING_WIDTH / 2 - width / 2,
    ["y"] = PLAYING_HEIGHT / 3 - height / 2,
    ["width"] = width,
    ["height"] = height
  }

  self.platform = platform

  local r = 12
  local ball = {
    ["x"] = PLAYING_WIDTH / 2,
    ["y"] = platform.y - r,
    ["r"] = r
  }

  self.ball = ball

  local container = {
    ["lineWidth"] = 5,
    ["width"] = platform.width / 2,
    ["height"] = 100
  }

  container.x = math.random(2) == 1 and platform.x - container.width or platform.x + platform.width
  container.y = PLAYING_HEIGHT - container.height - container.lineWidth / 2

  self.container = container
end

function TiltState:update(dt)
end

function TiltState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.rectangle("fill", self.platform.x, self.platform.y, self.platform.width, self.platform.height)
  love.graphics.circle("fill", self.ball.x, self.ball.y, self.ball.r)

  love.graphics.setLineWidth(self.container.lineWidth)
  love.graphics.line(
    self.container.x,
    self.container.y,
    self.container.x,
    self.container.y + self.container.height,
    self.container.x + self.container.width,
    self.container.y + self.container.height,
    self.container.x + self.container.width,
    self.container.y
  )
end
