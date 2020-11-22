Particle = {}
Particle.__index = Particle

function Particle:new(x, y, r)
  local offset = love.math.random(OFFSET_INITIAL_MAX)
  local angleChange = love.math.random(50, 100) / 100 * ANGLE_CHANGE_MAX

  local points, noises = self:getPoints(x, y, r, offset)

  this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = r,
    ["points"] = points,
    ["noises"] = noises,
    ["offset"] = offset,
    ["offsetInitial"] = offset,
    ["angle"] = 0,
    ["angleChange"] = love.math.random(2) == 1 and angleChange or angleChange * -1,
    ["lineWidth"] = math.floor(r ^ 0.3)
  }

  setmetatable(this, self)
  return this
end

function Particle:update(dt)
  self.angle = self.angle + self.angleChange
  self.offset = self.offsetInitial + love.math.noise(math.cos(self.angle), math.sin(self.angle))
  if math.abs(self.angle) > math.pi * 2 then
    self.angle = self.angle % math.pi * 2
  end
  self.points = self:getPoints(self.x, self.y, self.r, self.offset)
end

function Particle:render()
  love.graphics.setColor(0.4, 0.89, 0.98, 0.25)
  love.graphics.polygon("fill", self.points)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.setColor(0, 0.7, 0.91)
  love.graphics.polygon("line", self.points)
end

function Particle:collides(particle)
  return (math.abs(self.x - particle.x) ^ 2 + math.abs(self.y - particle.y) ^ 2) ^ 0.5 <
    self.r + particle.r - COLLISION_OVERLAP
end

function Particle:getPoints(x, y, r, offset)
  local points = {}
  local noises = {}
  for i = 0, math.pi * 2, math.pi * 2 / POINTS do
    local offsetX = offset + math.cos(i)
    local offsetY = offset + math.sin(i)

    local noise = love.math.noise(offsetX, offsetY) * r / 7
    local r = r + noise
    local x = x + r * math.cos(i)
    local y = y + r * math.sin(i)

    table.insert(noises, noise)
    table.insert(noises, noise)
    table.insert(points, x)
    table.insert(points, y)
  end

  return points, noises
end

function Particle:assimilates(particle)
  local maxNoise = 0
  for i = 1, #self.points do
    Timer:tween(
      0.2,
      {
        [self.points] = {[i] = self.points[i] + particle.noises[i]}
      }
    )

    if particle.noises[i] > maxNoise then
      maxNoise = particle.noises[i]
    end
  end

  Timer:tween(
    0.2,
    {
      [self] = {["r"] = self.r + maxNoise, ["lineWidth"] = (self.r + maxNoise) ^ 0.3}
    }
  )
  -- self.r = self.r + maxNoise
end
