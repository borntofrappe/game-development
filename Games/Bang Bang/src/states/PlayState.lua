PlayState = BaseState:create()

function PlayState:enter()
  self.terrain = self:getTerrain()
  self.player = Player:create(self.terrain)
  self.menu = Menu:create(self.player)
end

function PlayState:update(dt)
  Timer:update(dt)
  self.menu:update(dt)

  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.wasPressed("return") then
    self.player:fire()
  end

  if love.keyboard.wasPressed("up") or love.keyboard.wasPressed("down") then
    if love.keyboard.wasPressed("up") then
      self.player.angle = math.min(ANGLE_MAX, self.player.angle + INCREMENT)
    elseif love.keyboard.wasPressed("down") then
      self.player.angle = math.max(ANGLE_MIN, self.player.angle - INCREMENT)
    end
    self.menu.labels.angleDataLabel.text = self.player.angle
  end

  if love.keyboard.wasPressed("right") or love.keyboard.wasPressed("left") then
    if love.keyboard.wasPressed("right") then
      self.player.velocity = math.min(VELOCITY_MAX, self.player.velocity + INCREMENT)
    elseif love.keyboard.wasPressed("left") then
      self.player.velocity = math.max(VELOCITY_MIN, self.player.velocity - INCREMENT)
    end
    self.menu.labels.velocityDataLabel.text = self.player.velocity
  end
end

function PlayState:render()
  self.menu:render()
  self.player:render()

  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b)
  love.graphics.setLineWidth(6)
  love.graphics.line(self.terrain)
end

function PlayState:getTerrain()
  local yStart = love.math.random(math.floor(WINDOW_HEIGHT * 2 / 3), WINDOW_HEIGHT)
  local mu = love.math.random(MU_MIN, MU_MAX)
  local sigma = love.math.random(SIGMA_MIN, SIGMA_MAX)

  local points = {}
  local scale1 = love.math.random(NORMAL_DISTRIBUTION_SCALE_MIN, NORMAL_DISTRIBUTION_SCALE_MAX)
  local scale2 = yStart < WINDOW_HEIGHT * 3 / 4 and math.floor(scale1 * 1.5) or math.floor(scale1 * 0.75)
  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
    local dy = getNormalDistribution(x, mu, sigma)
    if x < mu then
      dy = dy * scale1
    else
      dy = dy * scale2 - (getNormalDistribution(mu, mu, sigma) * scale2 - getNormalDistribution(mu, mu, sigma) * scale1)
    end
    local y = yStart - dy
    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end
