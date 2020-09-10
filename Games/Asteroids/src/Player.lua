Player = {}
Player.__index = Player

function Player:create()
  this = {
    x = WINDOW_WIDTH / 2,
    y = WINDOW_HEIGHT / 2,
    dx = 0,
    dy = 0,
    angle = 0,
    direction = 0,
    dangle = 0,
    isPushing = false
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  self.isPushing = false
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    self.isPushing = true
    self.dy = math.cos(math.rad(self.angle)) * PUSH
    self.dx = math.sin(math.rad(self.angle)) * PUSH
  end

  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    self.direction = 1
    self.dangle = PUSH_LATERAL
  end

  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    self.direction = -1
    self.dangle = PUSH_LATERAL
  end

  if self.dx < 0 then
    self.dx = self.dx + FRICTION * dt
  elseif self.dx > 0 then
    self.dx = self.dx - FRICTION * dt
  end

  if self.dy < 0 then
    self.dy = self.dy + FRICTION * dt
  elseif self.dy > 0 then
    self.dy = self.dy - FRICTION * dt
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

  if self.dangle > 0 then
    self.dangle = self.dangle - FRICTION_LATERAL * dt
    self.angle = (self.angle + self.dangle * self.direction * dt) % 360
  end
end

function Player:render()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(math.rad(self.angle))

  if self.isPushing then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1.5)
    love.graphics.polygon("line", -5, 8, 5, 8, 0, 13)
  end

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.polygon("fill", 0, -8, 8, 8, -8, 8)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.polygon("line", 0, -8, 8, 8, -8, 8)
end
