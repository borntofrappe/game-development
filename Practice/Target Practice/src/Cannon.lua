Cannon = {}
Cannon.__index = Cannon

function Cannon:new(terrain)
  local radiusWheel = 14

  local r = 14

  local x = PLATFORM_WIDTH / 2
  local y = terrain and terrain.points[2] or WINDOW_HEIGHT

  local wheel = {
    ["x"] = x,
    ["y"] = y - radiusWheel,
    ["r"] = radiusWheel
  }

  local radiusBody = 20
  local offsetBody = 10
  local yBody = y - radiusWheel - offsetBody
  local width = 30
  local inset = 5

  local body = {
    ["x"] = x,
    ["y"] = yBody,
    ["r"] = radiusBody,
    ["width"] = width,
    ["points"] = {0, -radiusBody, width, -radiusBody + inset, width, radiusBody - inset, 0, radiusBody}
  }

  local this = {
    ["wheel"] = wheel,
    ["body"] = body,
    ["angle"] = love.math.random(math.floor(ANGLE.max / ANGLE.increments)) * ANGLE.increments + ANGLE.min,
    ["velocity"] = love.math.random(math.floor(VELOCITY.max / VELOCITY.increments)) * VELOCITY.increments + VELOCITY.min
  }

  setmetatable(this, self)
  return this
end

function Cannon:render()
  love.graphics.setColor(0.15, 0.16, 0.22)

  love.graphics.push()
  love.graphics.translate(self.body.x, self.body.y)
  love.graphics.circle("fill", 0, 0, self.body.r)
  love.graphics.rotate(math.rad(self.angle * -1))
  love.graphics.polygon("fill", self.body.points)
  love.graphics.pop()

  love.graphics.setColor(0.71, 0.44, 0.24)
  love.graphics.circle("fill", self.wheel.x, self.wheel.y, self.wheel.r)
end
