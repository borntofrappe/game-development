Lander = {}

function Lander:new(world)
  local body = love.physics.newBody(gWorld, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, "dynamic")

  local core = {}
  core.shape = love.physics.newCircleShape(10)
  core.fixture = love.physics.newFixture(body, core.shape)
  core.fixture:setUserData("core")

  local landingGear = {}
  landingGear[1] = {}
  landingGear[1].shape = love.physics.newPolygonShape(-10, 13, -8, 10, -5, 10, -3, 13)
  landingGear[1].fixture = love.physics.newFixture(body, landingGear[1].shape)
  landingGear[1].fixture:setRestitution(0.1)

  landingGear[2] = {}
  landingGear[2].shape = love.physics.newPolygonShape(10, 13, 8, 10, 5, 10, 3, 13)
  landingGear[2].fixture = love.physics.newFixture(body, landingGear[2].shape)
  landingGear[2].fixture:setRestitution(0.1)

  landingGear[3] = {}
  landingGear[3].shape = love.physics.newRectangleShape(0, 7, 16, 3)
  landingGear[3].fixture = love.physics.newFixture(body, landingGear[3].shape)
  landingGear[3].fixture:setSensor(true)

  for _, landingGear in pairs(landingGear) do
    landingGear.fixture:setUserData("landing-gear")
  end

  local thrusters = {}
  thrusters[1] = {}
  thrusters[1].shape = love.physics.newPolygonShape(-10, 13, -6.5, 17, -3, 13)

  thrusters[2] = {}
  thrusters[2].shape = love.physics.newPolygonShape(10, 13, 6.5, 17, 3, 13)

  thrusters[3] = {}
  thrusters[3].shape = love.physics.newPolygonShape(-8, 4, -14, 7, -8, 10)

  thrusters[4] = {}
  thrusters[4].shape = love.physics.newPolygonShape(8, 4, 14, 7, 8, 10)

  for _, thruster in pairs(thrusters) do
    thruster.fixture = love.physics.newFixture(body, thruster.shape)
    thruster.fixture:setSensor(true)
    thruster.fixture:setUserData("thruster")
  end

  local this = {
    ["body"] = body,
    ["core"] = core,
    ["landingGear"] = landingGear,
    ["thrusters"] = thrusters
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Lander:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.core.shape:getRadius())

  for _, gear in pairs(self.landingGear) do
    love.graphics.polygon("line", self.body:getWorldPoints(gear.shape:getPoints()))
  end
end
