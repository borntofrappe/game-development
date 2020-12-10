Player = {}
Player.__index = Player

function Player:create(terrain)
  local index = love.math.random(10) * 2 + 1

  local x = terrain[index]
  local y = terrain[index + 1]

  local sprite = 2
  local angle = 45
  local velocity = 80

  local offsetHeight = gTextures["cannon"]:getHeight()
  local offsetWidth = gTextures["cannon"]:getWidth() / #gQuads["cannon"]

  local isDestroyed = false
  local cannonball = {
    ["x"] = x + offsetWidth / 2,
    ["y"] = y - 18,
    ["r"] = CANNONBALL_SIZE / 2
  }

  this = {
    x = x,
    y = y,
    angle = angle,
    velocity = velocity,
    sprite = sprite,
    isDestroyed = isDestroyed,
    offsetHeight = offsetHeight,
    offsetWidth = offsetWidth,
    cannonball = cannonball,
    terrain = terrain,
    trajectory = {}
  }

  setmetatable(this, self)

  return this
end

function Player:render()
  love.graphics.setColor(1, 1, 1, 1)
  if self.isDestroyed then
    love.graphics.draw(
      gTextures["gameover"],
      self.x + self.offsetWidth / 2 - gTextures["gameover"]:getWidth() / 2,
      self.y - gTextures["gameover"]:getHeight()
    )
  else
    love.graphics.draw(
      gTextures["cannonball"],
      self.cannonball.x,
      self.cannonball.y,
      0,
      1,
      1,
      self.cannonball.r,
      self.cannonball.r
    )

    love.graphics.draw(
      gTextures["cannon"],
      gQuads["cannon"][self.sprite],
      self.x + self.offsetWidth / 2,
      self.y - 18,
      math.rad(90 - self.angle),
      1,
      1,
      self.offsetWidth / 2,
      self.offsetHeight - 18
    )
    love.graphics.draw(gTextures["cannon"], gQuads["cannon"][1], self.x, self.y - self.offsetHeight)
  end
end

function Player:getTrajectory()
  local xOffset = self.x + self.offsetWidth / 2
  local yOffset = self.y - 18
  local a = self.angle
  local v = self.velocity

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

function Player:fire()
  self.trajectory = self:getTrajectory()

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

      self.cannonball.x = self.trajectory[index]
      self.cannonball.y = self.trajectory[index + 1]

      if self.trajectory[index + 1] > self.terrain[indexStart + index + 2] then
        hasCollided = true

        local xStart = self.cannonball.x - self.cannonball.r
        local xEnd = self.cannonball.x + self.cannonball.r
        local angle = math.pi
        local dAngle = math.pi / (self.cannonball.r * 2) * WINDOW_WIDTH / POINTS
        for i = 1, #self.terrain, 2 do
          if self.terrain[i] >= xStart and self.terrain[i] <= xEnd then
            self.terrain[i + 1] = self.terrain[i + 1] + math.sin(angle) * self.cannonball.r
            angle = math.max(0, angle - dAngle)
          end
        end

        self.isFiring = false
        self.cannonball.x = self.x + self.offsetWidth / 2
        self.cannonball.y = self.y - 18
        Timer:reset()
      end

      if not hasCollided then
        index = index + 2
        if not self.trajectory[index] then
          self.isFiring = false
          self.cannonball.x = self.x + self.offsetWidth / 2
          self.cannonball.y = self.y - 18
          Timer:reset()
        end
      end
    end
  )
end
