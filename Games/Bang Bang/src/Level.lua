Level = {}
Level.__index = Level

function Level:create()
  local terrain = Terrain:create()

  local index = love.math.random(10) * 2 + 1
  local xCannon = terrain.points[index]
  local yCannon = terrain.points[index + 1]
  local cannon = Cannon:create(xCannon, yCannon)

  local xCannonball = cannon.x + cannon.width / 2 + math.cos(math.rad(cannon.angle)) * (cannon.height - OFFSET_HEIGHT)
  local yCannonball =
    cannon.y - OFFSET_HEIGHT - cannon.width / 2 + math.sin(math.rad(cannon.angle)) * (cannon.height - OFFSET_HEIGHT)
  local cannonball = Cannonball:create(xCannonball, yCannonball)

  this = {
    terrain = terrain,
    cannon = cannon,
    cannonball = cannonball,
    isFiring = false
  }

  setmetatable(this, self)

  return this
end

function Level:render()
  if self.isFiring then
    self.cannonball:render()
  end

  self.cannon:render()
  self.terrain:render()
end

function Level:getTrajectory()
  local xOffset =
    self.cannon.x + self.cannon.width / 2 + math.cos(math.rad(self.cannon.angle)) * (self.cannon.height - OFFSET_HEIGHT)
  local yOffset =
    self.cannon.y - OFFSET_HEIGHT - math.sin(math.rad(self.cannon.angle)) * (self.cannon.height - OFFSET_HEIGHT)
  local a = self.cannon.angle
  local v = self.cannon.velocity

  local points = {}
  local theta = math.rad(a)

  local t = 0
  local tDelta = (self.terrain.points[3] - self.terrain.points[1]) / (v * math.cos(theta))

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

function Level:fire()
  if not self.isFiring then
    self.isFiring = true
    local trajectory = self:getTrajectory()

    local index = 1
    self.cannonball.x = trajectory[index]
    self.cannonball.y = trajectory[index + 1]

    local indexStart

    for i = 1, #self.terrain.points, 2 do
      if self.terrain.points[i] >= trajectory[1] then
        indexStart = i
        break
      end
    end

    Timer:every(
      2 / #trajectory / 2,
      function()
        local hasCollided = false

        self.cannonball.x = trajectory[index]
        self.cannonball.y = trajectory[index + 1]

        if trajectory[index + 1] + self.cannonball.r > self.terrain.points[indexStart + index + 2] then
          hasCollided = true

          local xStart = self.cannonball.x - self.cannonball.r
          local xEnd = self.cannonball.x + self.cannonball.r
          local angle = math.pi
          local dAngle = math.pi / (self.cannonball.r * 2) * WINDOW_WIDTH / POINTS
          for i = 1, #self.terrain.points, 2 do
            if self.terrain.points[i] >= xStart and self.terrain.points[i] <= xEnd then
              self.terrain.points[i + 1] = self.terrain.points[i + 1] + math.sin(angle) * self.cannonball.r
              angle = math.max(0, angle - dAngle)
            end
          end

          self.isFiring = false
          self.cannonball.x =
            self.cannon.x + self.cannon.width / 2 +
            math.cos(math.rad(self.cannon.angle)) * (self.cannon.height - OFFSET_HEIGHT)
          self.cannonball.y =
            self.cannon.y - OFFSET_HEIGHT - math.sin(math.rad(self.cannon.angle)) * (self.cannon.height - OFFSET_HEIGHT)
          Timer:reset()
        end

        if not hasCollided then
          index = index + 2
          if not trajectory[index] then
            self.isFiring = false
            self.cannonball.x =
              self.cannon.x + self.cannon.width / 2 +
              math.cos(math.rad(self.cannon.angle)) * (self.cannon.height - OFFSET_HEIGHT)
            self.cannonball.y =
              self.cannon.y - OFFSET_HEIGHT -
              math.sin(math.rad(self.cannon.angle)) * (self.cannon.height - OFFSET_HEIGHT)

            Timer:reset()
          end
        end
      end
    )
  end
end
