Player = {}
Player.__index = Player

function Player:create()
  this = {
    x = WINDOW_WIDTH / 2,
    y = WINDOW_HEIGHT / 2,
    dx = 0,
    direction = 1,
    dy = 0,
    angle = 0,
    directionAngle = 0,
    dangle = 0
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    local angle = self.angle % 360
    if angle > 90 and angle < 270 and self.direction == 1 then
      self.direction = -1
    elseif (angle < 90 or angle > 270) and self.direction == -1 then
      self.direction = 1
    end
    self.dy = PUSH
  end

  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    self.directionAngle = 1
    self.dangle = PUSH_LATERAL
  end

  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    self.directionAngle = -1
    self.dangle = PUSH_LATERAL
  end

  if self.dy > 0 then
    self.dy = self.dy - FRICTION * dt
    self.y = self.y - self.dy * self.direction

    self.dx = math.sin(math.rad(self.angle)) * self.dy
    self.x = self.x + self.dx

    if self.y > WINDOW_HEIGHT then
      self.y = -10
    end

    if self.y < -10 then
      self.y = WINDOW_HEIGHT
    end

    if self.x < -10 then
      self.x = WINDOW_WIDTH
    end

    if self.x > WINDOW_WIDTH then
      self.x = -10
    end
  end

  if self.dangle > 0 then
    self.dangle = self.dangle - FRICTION_LATERAL * dt
    self.angle = self.angle + self.dangle * self.directionAngle * dt
  end
end

function Player:render()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(math.rad(self.angle))

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.polygon("line", 0, -10, 10, 10, -10, 10)
end
