Ball = {}
Ball.__index = Ball

function Ball:new(world, cx, cy, r)
  local body = love.physics.newBody(world, cx, cy, "dynamic")
  local shape = love.physics.newCircleShape(r)
  local fixture = love.physics.newFixture(body, shape)
  this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture
  }

  setmetatable(this, self)
  return this
end

function Ball:render()
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end
