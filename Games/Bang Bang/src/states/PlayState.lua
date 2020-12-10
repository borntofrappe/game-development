PlayState = BaseState:create()

function PlayState:enter()
  self.level = Level:create()
  self.menu = Menu:create(self.level)
end

function PlayState:update(dt)
  Timer:update(dt)

  self.menu:update(dt)

  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.wasPressed("return") then
    self.level:fire()
  end

  if love.keyboard.wasPressed("up") or love.keyboard.wasPressed("down") then
    if love.keyboard.wasPressed("up") then
      self.level.cannon.angle = math.min(ANGLE_MAX, self.level.cannon.angle + INCREMENT)
    elseif love.keyboard.wasPressed("down") then
      self.level.cannon.angle = math.max(ANGLE_MIN, self.level.cannon.angle - INCREMENT)
    end
    self.menu.labels.angleDataLabel.text = self.level.cannon.angle
  end

  if love.keyboard.wasPressed("right") or love.keyboard.wasPressed("left") then
    if love.keyboard.wasPressed("right") then
      self.level.cannon.velocity = math.min(VELOCITY_MAX, self.level.cannon.velocity + INCREMENT)
    elseif love.keyboard.wasPressed("left") then
      self.level.cannon.velocity = math.max(VELOCITY_MIN, self.level.cannon.velocity - INCREMENT)
    end
    self.menu.labels.velocityDataLabel.text = self.level.cannon.velocity
  end
end

function PlayState:render()
  self.menu:render()
  self.level:render()
end
