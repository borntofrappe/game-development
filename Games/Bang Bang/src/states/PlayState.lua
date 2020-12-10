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

  if love.keyboard.isDown("down") then
    self.player.angle = math.max(0, self.player.angle - dt * UPDATE_SPEED)
  elseif love.keyboard.isDown("up") then
    self.player.angle = math.min(90, self.player.angle + dt * UPDATE_SPEED)
  end

  if love.keyboard.isDown("right") then
    self.player.velocity = math.min(100, self.player.velocity + dt * UPDATE_SPEED)
  elseif love.keyboard.isDown("left") then
    self.player.velocity = math.max(10, self.player.velocity - dt * UPDATE_SPEED)
  end

  if love.keyboard.wasPressed("d") then
    self.player.isDestroyed = not self.player.isDestroyed
  end
end

function PlayState:render()
  self.menu:render()
  self.player:render()

  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b)
  love.graphics.setLineWidth(5)
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
