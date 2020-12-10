Level = {}
Level.__index = Level

function Level:create()
  local terrain = Terrain:create()
  local cannon = Cannon:create(terrain)

  this = {
    terrain = terrain,
    cannon = cannon
  }

  setmetatable(this, self)

  return this
end

function Level:update(dt)
  if love.keyboard.wasPressed("return") then
    self.cannon:fire()
  end

  if love.keyboard.wasPressed("up") or love.keyboard.wasPressed("down") then
    if love.keyboard.wasPressed("up") then
      self.cannon.angle = math.min(ANGLE_MAX, self.cannon.angle + INCREMENT)
    elseif love.keyboard.wasPressed("down") then
      self.cannon.angle = math.max(ANGLE_MIN, self.cannon.angle - INCREMENT)
    end
    self.menu.labels.angleDataLabel.text = self.cannon.angle
  end

  if love.keyboard.wasPressed("right") or love.keyboard.wasPressed("left") then
    if love.keyboard.wasPressed("right") then
      self.cannon.velocity = math.min(VELOCITY_MAX, self.cannon.velocity + INCREMENT)
    elseif love.keyboard.wasPressed("left") then
      self.cannon.velocity = math.max(VELOCITY_MIN, self.cannon.velocity - INCREMENT)
    end
    self.menu.labels.velocityDataLabel.text = self.cannon.velocity
  end
end

function Level:render()
  if self.isFiring then
    self.cannonball:render()
  end

  self.cannon:render()
  self.terrain:render()
end
