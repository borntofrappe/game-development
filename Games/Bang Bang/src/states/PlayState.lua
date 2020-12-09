PlayState = BaseState:create()

function PlayState:enter()
  self.terrain = self:getPoints()

  local xPlayer = love.math.random(10) * 2 + 1
  self.player = Player:create(self.terrain[xPlayer], self.terrain[xPlayer + 1])
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  self.player:update(dt)
end

function PlayState:render()
  self.player:render()

  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b)
  love.graphics.setLineWidth(5)
  love.graphics.line(self.terrain)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.print(
    "Angle " .. formatData(self.player.angle) .. "\nVelocity " .. formatData(self.player.velocity),
    8,
    8
  )
end

function PlayState:getPoints()
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
