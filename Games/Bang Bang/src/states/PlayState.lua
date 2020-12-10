PlayState = BaseState:create()

function PlayState:enter()
  self.terrain = self:getPoints()

  local xPlayer = love.math.random(10) * 2 + 1
  self.player = Player:create(self.terrain[xPlayer], self.terrain[xPlayer + 1])

  self.trajectory = self:getTrajectory(self.player)
  self.showTrajectory = false
  self.isFiring = false

  self.fireButton =
    Button:create(
    WINDOW_WIDTH / 2,
    8,
    128,
    48,
    "Fire!",
    function()
      self:fire()
    end
  )
end

function PlayState:update(dt)
  Timer:update(dt)
  self.fireButton:update(dt)

  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end
  if love.keyboard.wasPressed("t") then
    self.showTrajectory = not self.showTrajectory
  end

  if love.keyboard.wasPressed("return") and not self.isFiring then
    self.isFiring = true
    self:fire()
  end

  self.player:update(dt)
end

function PlayState:render()
  self.player:render()

  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b)
  love.graphics.setLineWidth(5)
  love.graphics.line(self.terrain)

  if self.showTrajectory then
    love.graphics.setLineWidth(2)
    love.graphics.line(self.trajectory)
  end

  love.graphics.setFont(gFonts["normal"])
  love.graphics.print(
    "Angle " .. formatData(self.player.angle) .. "\nVelocity " .. formatData(self.player.velocity),
    8,
    8
  )

  self.fireButton:render()
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

function PlayState:getTrajectory(player)
  local xOffset = player.x + player.offsetWidth / 2
  local yOffset = player.y - 18
  local a = player.angle
  local v = player.velocity

  local points = {}
  local theta = math.rad(a)

  local t = 0
  local tDelta = (self.terrain[3] - self.terrain[1]) / (v * math.cos(theta))

  while true do
    x = v * t * math.cos(theta)
    y = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2

    table.insert(points, xOffset + x)
    table.insert(points, yOffset - y)
    t = t + tDelta

    if yOffset - y > WINDOW_HEIGHT then
      break
    end
  end

  return points
end

function PlayState:fire()
  self.trajectory = self:getTrajectory(self.player)

  local index = 1

  local indexStart

  for i = 1, #self.terrain, 2 do
    if self.terrain[i] >= self.trajectory[1] then
      indexStart = i
      break
    end
  end

  Timer:every(
    2 / #self.trajectory / 2,
    function()
      local hasCollided = false

      self.player.cannonball.x = self.trajectory[index]
      self.player.cannonball.y = self.trajectory[index + 1]

      if self.trajectory[index + 1] > self.terrain[indexStart + index + 2] then
        hasCollided = true

        local xStart = self.player.cannonball.x - self.player.cannonball.r
        local xEnd = self.player.cannonball.x + self.player.cannonball.r
        local angle = math.pi
        local dAngle = math.pi / (self.player.cannonball.r * 2) * WINDOW_WIDTH / POINTS
        for i = 1, #self.terrain, 2 do
          if self.terrain[i] >= xStart and self.terrain[i] <= xEnd then
            self.terrain[i + 1] = self.terrain[i + 1] + math.sin(angle) * self.player.cannonball.r
            angle = math.max(0, angle - dAngle)
          end
        end

        self.isFiring = false
        self.player.cannonball.x = self.player.x + self.player.offsetWidth / 2
        self.player.cannonball.y = self.player.y - 18
        Timer:reset()
      end

      if not hasCollided then
        index = index + 2
        if not self.trajectory[index] then
          self.isFiring = false
          self.player.cannonball.x = self.player.x + self.player.offsetWidth / 2
          self.player.cannonball.y = self.player.y - 18
          Timer:reset()
        end
      end
    end
  )
end
