Player = {}
Player.__index = Player

function Player:create(x, y)
  this = {
    x = x or WINDOW_WIDTH / 2,
    y = y or WINDOW_HEIGHT / 2,
    dx = 0,
    dy = 0,
    angle = 0,
    isPushing = false,
    r = PLAYER_RADIUS,
    alpha = 1
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  self.isPushing = false
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    self.isPushing = true
    self.dy = math.cos(math.rad(self.angle)) * PLAYER_SPEED
    self.dx = math.sin(math.rad(self.angle)) * PLAYER_SPEED
  end

  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    self.angle = self.angle + PLAYER_SPEED_LATERAL * dt
  end

  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    self.angle = self.angle - PLAYER_SPEED_LATERAL * dt
  end

  if self.dx < 0 then
    self.dx = self.dx + PLAYER_FRICTION * dt
  elseif self.dx > 0 then
    self.dx = self.dx - PLAYER_FRICTION * dt
  end

  if self.dy < 0 then
    self.dy = self.dy + PLAYER_FRICTION * dt
  elseif self.dy > 0 then
    self.dy = self.dy - PLAYER_FRICTION * dt
  end

  self.y = self.y - self.dy
  self.x = self.x + self.dx

  if self.y > WINDOW_HEIGHT then
    self.y = -8
  end

  if self.y < -8 then
    self.y = WINDOW_HEIGHT
  end

  if self.x < -8 then
    self.x = WINDOW_WIDTH
  end

  if self.x > WINDOW_WIDTH then
    self.x = -8
  end
end

function Player:render()
  love.graphics.translate(math.floor(self.x), math.floor(self.y))
  love.graphics.rotate(math.rad(self.angle))

  if self.isPushing then
    love.graphics.setColor(
      gColors["background"]["r"],
      gColors["background"]["g"],
      gColors["background"]["b"],
      self.alpha
    )
    love.graphics.setLineWidth(1.5)
    love.graphics.polygon(
      "line",
      math.floor(-self.r / 2),
      math.floor(self.r),
      math.floor(self.r / 2),
      math.floor(self.r),
      0,
      math.floor(self.r * 3 / 2)
    )

    love.graphics.setColor(
      gColors["foreground"]["r"],
      gColors["foreground"]["g"],
      gColors["foreground"]["b"],
      self.alpha
    )
    love.graphics.setLineWidth(1.5)
    love.graphics.polygon(
      "line",
      math.floor(-self.r / 2),
      math.floor(self.r),
      math.floor(self.r / 2),
      math.floor(self.r),
      0,
      math.floor(self.r * 3 / 2)
    )
  end

  love.graphics.setColor(gColors["background"]["r"], gColors["background"]["g"], gColors["background"]["b"], self.alpha)
  love.graphics.polygon(
    "fill",
    0,
    math.floor(-self.r),
    math.floor(self.r),
    math.floor(self.r),
    math.floor(-self.r),
    math.floor(self.r)
  )
  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"], self.alpha)
  love.graphics.setLineWidth(2)
  love.graphics.polygon(
    "line",
    0,
    math.floor(-self.r),
    math.floor(self.r),
    math.floor(self.r),
    math.floor(-self.r),
    math.floor(self.r)
  )
end
