Asteroid = {}
Asteroid.__index = Asteroid

function Asteroid:create(x, y, size)
  local randomX =
    math.random(2) == 1 and math.random(0, WINDOW_WIDTH / 3) or math.random(WINDOW_WIDTH * 2 / 3, WINDOW_WIDTH)
  local randomY =
    math.random(2) == 1 and math.random(0, WINDOW_HEIGHT / 3) or math.random(WINDOW_HEIGHT * 2 / 3, WINDOW_WIDTH)

  local dx =
    math.random(2) == 1 and math.random(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX) or
    math.random(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX) * -1
  local dy =
    math.random(2) == 1 and math.random(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX) or
    math.random(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX) * -1

  this = {
    x = x or randomX,
    y = y or randomY,
    dx = dx,
    dy = dy,
    size = size or ASTEROID_DEFAULT_SIZE,
    inPlay = true
  }

  this.r = this.size * ASTEROID_SIZE_MULTIPLIER

  setmetatable(this, self)

  return this
end

function Asteroid:update(dt)
  if self.inPlay then
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.y > WINDOW_HEIGHT then
      self.y = -self.r
    end

    if self.y < -self.r then
      self.y = WINDOW_HEIGHT
    end

    if self.x < -self.r then
      self.x = WINDOW_WIDTH
    end

    if self.x > WINDOW_WIDTH then
      self.x = -self.r
    end
  end
end

function Asteroid:render()
  if self.inPlay then
    love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
    love.graphics.circle("fill", math.floor(self.x), math.floor(self.y), self.r)
  end
end
