Cannon = {}
Cannon.__index = Cannon

function Cannon:new(terrain)
  local r = 14

  local x = PLATFORM_WIDTH
  local y = terrain.points[2] -- y coordinate of the first platform

  local wheel = {
    ["x"] = x,
    ["y"] = y - r,
    ["r"] = r
  }

  local rBody = r * 1.4
  local yOffset = 10
  local yBody = y - r - yOffset
  local body = {
    ["x"] = x,
    ["y"] = yBody,
    ["r"] = rBody,
    ["points"] = {0, -rBody, 30, -rBody * 0.75, 30, rBody * 0.75, 0, rBody}
  }

  local this = {
    ["wheel"] = wheel,
    ["body"] = body,
    ["x"] = x,
    ["y"] = y - r - yOffset,
    ["offsetTerrain"] = wheel.r + yOffset,
    ["angle"] = love.math.random(math.floor(ANGLE.max / ANGLE.increments)) * ANGLE.increments + ANGLE.min,
    ["velocity"] = love.math.random(math.floor(VELOCITY.max / VELOCITY.increments)) * VELOCITY.increments + VELOCITY.min
  }

  setmetatable(this, self)
  return this
end

function Cannon:render()
  love.graphics.setColor(0.18, 0.19, 0.26)

  love.graphics.push()
  love.graphics.translate(self.body.x, self.body.y)
  love.graphics.circle("fill", 0, 0, self.body.r)
  love.graphics.rotate(math.rad(self.angle * -1))
  love.graphics.polygon("fill", self.body.points)
  love.graphics.pop()

  love.graphics.setColor(0.51, 0.27, 0.25)
  love.graphics.circle("fill", self.wheel.x, self.wheel.y, self.wheel.r)
end
