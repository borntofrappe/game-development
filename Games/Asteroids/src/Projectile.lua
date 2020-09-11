Projectile = {}
Projectile.__index = Projectile

function Projectile:create(x, y, angle)
  local dy = math.cos(math.rad(angle)) * PUSH_PROJECTILE * -1
  local dx = math.sin(math.rad(angle)) * PUSH_PROJECTILE
  this = {
    x = x,
    y = y,
    r = 2,
    dx = dx,
    dy = dy,
    timer = 0,
    inPlay = true
  }

  setmetatable(this, self)

  return this
end

function Projectile:update(dt)
  self.timer = self.timer + dt
  if self.timer >= TIMER_PROJECTILE then
    self.inPlay = false
  end

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

function Projectile:render()
  if self.inPlay then
    love.graphics.setColor(colors["foreground"]["r"], colors["foreground"]["g"], colors["foreground"]["b"])
    love.graphics.circle("fill", self.x, self.y, self.r)
  end
end
