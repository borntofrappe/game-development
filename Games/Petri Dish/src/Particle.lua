Particle = {}
Particle.__index = Particle

function Particle:new(x, y, r)
  local offset = love.math.random(OFFSET_INITIAL_MAX)
  local points, noises = self:getShape(x, y, r, offset)

  local angleChange = love.math.random(ANGLE_CHANGE_MIN, ANGLE_CHANGE_MAX)
  if love.math.random(2) == 1 then
    angleChange = angleChange * -1
  end

  local lineWidth = math.floor(r ^ 0.3)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = r,
    ["points"] = points,
    ["noises"] = noises,
    ["offset"] = offset,
    ["offsetInitial"] = offset,
    ["angle"] = 0,
    ["angleChange"] = angleChange,
    ["lineWidth"] = lineWidth
  }

  setmetatable(this, self)
  return this
end

function Particle:update(dt)
  -- ensure a smooth transition between iterations with 2D noise
  self.angle = self.angle + self.angleChange
  local offsetX = math.cos(self.angle)
  local offsetY = math.sin(self.angle)
  self.offset = self.offsetInitial + love.math.noise(offsetX, offsetY)
  if math.abs(self.angle) > math.pi * 2 then
    self.angle = self.angle % math.pi * 2
  end
  self.points, self.noises = self:getShape(self.x, self.y, self.r, self.offset)
end

function Particle:render()
  love.graphics.setColor(0.4, 0.89, 0.98, 0.2)
  love.graphics.polygon("fill", self.points)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.setColor(0, 0.7, 0.91)
  love.graphics.polygon("line", self.points)
end

function Particle:collides(particle)
  return (math.abs(self.x - particle.x) ^ 2 + math.abs(self.y - particle.y) ^ 2) ^ 0.5 <
    self.r + particle.r - math.floor(particle.r / PARTICLE_OVERLAP_FRACTION)
end

function Particle:getShape(x, y, r, offset)
  -- points describes the coordinates of the polygon
  -- noise describes the change applied to the regular radius
  local points = {}
  local noises = {}
  for i = 0, math.pi * 2, math.pi * 2 / POINTS do
    local offsetX = offset + math.cos(i)
    local offsetY = offset + math.sin(i)

    local noise = love.math.noise(offsetX, offsetY) * r / PARTICLE_NOISE_FRACTION
    local r = r + noise
    local x = x + r * math.cos(i)
    local y = y + r * math.sin(i)

    table.insert(points, x)
    table.insert(points, y)
    -- add two copies of the same value to describe the x and y coordinate
    table.insert(noises, noise)
    table.insert(noises, noise)
  end

  return points, noises
end

function Particle:assimilates(particle)
  -- maxNoise to increment the radius of the particle by the greatest noise amount
  local maxNoise = 0

  for i = 1, #self.points do
    -- update points and noise
    Timer:tween(
      0.2,
      {
        [self.points] = {[i] = self.points[i] + particle.noises[i]},
        [self.noises] = {[i] = self.noises[i] + particle.noises[i]}
      }
    )

    if particle.noises[i] > maxNoise then
      maxNoise = particle.noises[i]
    end
  end

  -- update radius (and in so doing the game's scale)
  Timer:tween(
    0.2,
    {
      [self] = {["r"] = self.r + maxNoise, ["lineWidth"] = math.floor((self.r + maxNoise) ^ 0.3)}
    }
  )
end
