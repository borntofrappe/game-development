Level = {}
Level.__index = Level

function Level:create()
  local terrain = Terrain:create()

  local indexCannon = love.math.random(CANNON_POINTS) * 2 + 1
  local xCannon = terrain.points[indexCannon]
  local yCannon = terrain.points[indexCannon + 1]
  local cannon = Cannon:create(xCannon, yCannon)

  local xCannonball =
    cannon.x + cannon.width / 2 + math.cos(math.rad(cannon.angle)) * (cannon.height - CANNON_OFFSET_HEIGHT)
  local yCannonball =
    cannon.y - CANNON_OFFSET_HEIGHT - cannon.width / 2 +
    math.sin(math.rad(cannon.angle)) * (cannon.height - CANNON_OFFSET_HEIGHT)
  local cannonball = Cannonball:create(xCannonball, yCannonball)

  local indexTarget = #terrain.points - love.math.random(TARGET_POINTS) * 2 + 1
  local xTarget = terrain.points[indexTarget]
  local yTarget = terrain.points[indexTarget + 1]
  local target = Target:create(xTarget, yTarget)

  this = {
    terrain = terrain,
    cannon = cannon,
    cannonball = cannonball,
    target = target,
    isFiring = false
  }

  setmetatable(this, self)

  return this
end

function Level:update(dt)
  Timer:update(dt)
end

function Level:render()
  if self.isFiring then
    self.cannonball:render()
  end

  self.cannon:render()
  self.target:render()
  self.terrain:render()
end

function Level:getTrajectory()
  local xOffset =
    self.cannon.x + self.cannon.width / 2 +
    math.cos(math.rad(self.cannon.angle)) * (self.cannon.height - CANNON_OFFSET_HEIGHT)
  local yOffset =
    self.cannon.y - CANNON_OFFSET_HEIGHT -
    math.sin(math.rad(self.cannon.angle)) * (self.cannon.height - CANNON_OFFSET_HEIGHT)
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
  if not self.isFiring and not self.cannon.isDestroyed then
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
        local resetCannonball = false

        self.cannonball.x = trajectory[index]
        self.cannonball.y = trajectory[index + 1]

        --[[
          collision detection
          when checking the terrain consider if the ball hits the cannon/target
          if so destroy the cannon/target        
          ]]
        if
          self.terrain.points[indexStart + index + 2] and
            self.cannonball.y + self.cannonball.r - CANNONBALL_BORDER > self.terrain.points[indexStart + index + 2]
         then
          -- consider only the x coordinate for the cannon/target
          if
            not (self.cannonball.x + self.cannonball.r < self.cannon.x or
              self.cannonball.x - self.cannonball.r > self.cannon.x + self.cannon.width)
           then
            self.cannon.isDestroyed = true
          elseif
            not (self.cannonball.x + self.cannonball.r < self.target.x or
              self.cannonball.x - self.cannonball.r > self.target.x + self.target.width)
           then
            self.target.isDestroyed = true
          else
            local xStart = self.cannonball.x - self.cannonball.r
            local xEnd = self.cannonball.x + self.cannonball.r
            local angle = math.pi
            local dAngle = math.pi / (self.cannonball.r * 2) * WINDOW_WIDTH / TERRAIN_POINTS
            for i = 1, #self.terrain.points, 2 do
              if self.terrain.points[i] >= xStart and self.terrain.points[i] <= xEnd then
                self.terrain.points[i + 1] = self.terrain.points[i + 1] + math.sin(angle) * self.cannonball.r
                angle = math.max(0, angle - dAngle)
              end
            end
          end

          resetCannonball = true
        end

        index = index + 2
        if not trajectory[index] then
          resetCannonball = true
        end

        if resetCannonball then
          Timer:reset()
          if self.cannon.isDestroyed or self.target.isDestroyed then
            self.cannonball.isDestroyed = true
            Timer:after(
              PLAYSTATE_DELAY,
              function()
                gStateMachine:change("play")
              end
            )
          else
            self.cannonball.x =
              self.cannon.x + self.cannon.width / 2 +
              math.cos(math.rad(self.cannon.angle)) * (self.cannon.height - CANNON_OFFSET_HEIGHT)
            self.cannonball.y =
              self.cannon.y - CANNON_OFFSET_HEIGHT -
              math.sin(math.rad(self.cannon.angle)) * (self.cannon.height - CANNON_OFFSET_HEIGHT)
            self.isFiring = false
          end
        end
      end
    )
  end
end
