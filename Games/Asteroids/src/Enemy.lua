Enemy = {}
Enemy.__index = Enemy

function Enemy:create()
  local direction = math.random(2) == 1 and "right" or "left"

  this = {
    x = direction == "right" and -ENEMY_RADIUS or WINDOW_WIDTH + ENEMY_RADIUS,
    y = math.random(WINDOW_HEIGHT / 4, WINDOW_HEIGHT * 3 / 4),
    r = ENEMY_RADIUS,
    dx = direction == "right" and math.random(ENEMY_SPEED_X_MIN, ENEMY_SPEED_X_MAX) or
      math.random(-ENEMY_SPEED_X_MIN, -ENEMY_SPEED_X_MAX),
    dy = math.random(ENEMY_SPEED_Y_MIN, ENEMY_SPEED_Y_MAX),
    inPlay = true
  }

  setmetatable(this, self)

  return this
end

function Enemy:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if math.random(ENEMY_CHANGE_Y_ODDS) == 1 then
    self.dy = self.dy * -1
  end

  if self.x < ENEMY_RADIUS or self.x > WINDOW_WIDTH + ENEMY_RADIUS then
    self.inPlay = false
  end

  if self.y < ENEMY_RADIUS then
    self.y = WINDOW_HEIGHT + ENEMY_RADIUS
  end

  if self.y > WINDOW_HEIGHT + ENEMY_RADIUS then
    self.y = ENEMY_RADIUS
  end
end

function Enemy:render()
  if self.inPlay then
    love.graphics.setColor(gColors["background"]["r"], gColors["background"]["g"], gColors["background"]["b"])
    love.graphics.polygon(
      "fill",
      math.floor(self.x - self.r / 2),
      math.floor(self.y - self.r),
      math.floor(self.x + self.r / 2),
      math.floor(self.y - self.r),
      math.floor(self.x + self.r * 3 / 2),
      math.floor(self.y),
      math.floor(self.x + self.r / 2),
      math.floor(self.y + self.r),
      math.floor(self.x - self.r / 2),
      math.floor(self.y + self.r),
      math.floor(self.x - self.r * 3 / 2),
      math.floor(self.y)
    )
    love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
    love.graphics.polygon(
      "line",
      math.floor(self.x - self.r / 2),
      math.floor(self.y - self.r),
      math.floor(self.x + self.r / 2),
      math.floor(self.y - self.r),
      math.floor(self.x + self.r * 3 / 2),
      math.floor(self.y),
      math.floor(self.x + self.r / 2),
      math.floor(self.y + self.r),
      math.floor(self.x - self.r / 2),
      math.floor(self.y + self.r),
      math.floor(self.x - self.r * 3 / 2),
      math.floor(self.y)
    )
  end
end
