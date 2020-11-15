Lander = {}
Lander.__index = Lander

function Lander:new(world)
  local body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 + 16, "dynamic")
  body:setUserData("Lander")

  local core = {}
  core.shape = love.physics.newCircleShape(9)
  core.fixture = love.physics.newFixture(body, core.shape)

  local landingGear = {}
  landingGear[1] = {}
  landingGear[1].shape = love.physics.newPolygonShape(-10, 12, -7, 8, -5, 8, -2, 12)
  landingGear[1].fixture = love.physics.newFixture(body, landingGear[1].shape)

  landingGear[2] = {}
  landingGear[2].shape = love.physics.newPolygonShape(10, 12, 7, 8, 5, 8, 2, 12)
  landingGear[2].fixture = love.physics.newFixture(body, landingGear[2].shape)

  landingGear[3] = {}
  landingGear[3].shape = love.physics.newRectangleShape(0, 8, 8, 2)
  landingGear[3].fixture = love.physics.newFixture(body, landingGear[3].shape)
  landingGear[3].fixture:setSensor(true)

  local signifiers = {}
  signifiers[1] = {}
  signifiers[1].shape = love.physics.newPolygonShape(-9, 13, -7, 16, -5, 13)
  signifiers[1].fixture = love.physics.newFixture(body, signifiers[1].shape)
  signifiers[1].fixture:setSensor(true)

  signifiers[2] = {}
  signifiers[2].shape = love.physics.newPolygonShape(9, 13, 7, 16, 5, 13)
  signifiers[2].fixture = love.physics.newFixture(body, signifiers[2].shape)
  signifiers[2].fixture:setSensor(true)

  signifiers[3] = {}
  signifiers[3].shape = love.physics.newPolygonShape(-8, 6, -12, 8, -8, 10)
  signifiers[3].fixture = love.physics.newFixture(body, signifiers[3].shape)
  signifiers[3].fixture:setSensor(true)

  signifiers[4] = {}
  signifiers[4].shape = love.physics.newPolygonShape(8, 6, 12, 8, 8, 10)
  signifiers[4].fixture = love.physics.newFixture(body, signifiers[4].shape)
  signifiers[4].fixture:setSensor(true)

  this = {
    ["body"] = body,
    ["core"] = core,
    ["landingGear"] = landingGear,
    ["signifiers"] = signifiers
  }

  setmetatable(this, self)
  return this
end

function Lander:burst(direction)
  if direction == "up" then
    self.body:applyLinearImpulse(0, -IMPULSE)
  elseif direction == "right" then
    self.body:applyLinearImpulse(math.floor(IMPULSE / 2), 0)
  elseif direction == "left" then
    self.body:applyLinearImpulse(math.floor(IMPULSE / 2) * -1, 0)
  end
end

function Lander:push(direction)
  if direction == "up" then
    self.body:applyForce(0, -VELOCITY)
  elseif direction == "right" then
    self.body:applyForce(VELOCITY, 0)
  elseif direction == "left" then
    self.body:applyForce(VELOCITY * -1, 0)
  end
end

function Lander:render()
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.core.shape:getRadius())
  for i, gear in ipairs(self.landingGear) do
    love.graphics.polygon("line", self.body:getWorldPoints(gear.shape:getPoints()))
  end

  if love.keyboard.isDown("up") then
    love.graphics.polygon("line", self.body:getWorldPoints(self.signifiers[1].shape:getPoints()))
    love.graphics.polygon("line", self.body:getWorldPoints(self.signifiers[2].shape:getPoints()))
  end

  if love.keyboard.isDown("right") then
    love.graphics.polygon("line", self.body:getWorldPoints(self.signifiers[3].shape:getPoints()))
  elseif love.keyboard.isDown("left") then
    love.graphics.polygon("line", self.body:getWorldPoints(self.signifiers[4].shape:getPoints()))
  end
end
