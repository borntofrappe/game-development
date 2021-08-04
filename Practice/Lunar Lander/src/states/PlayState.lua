PlayState = BaseState:new()

function PlayState:enter()
  lander = {}
  lander.body = love.physics.newBody(gWorld, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")

  lander.core = {}
  lander.core.shape = love.physics.newCircleShape(10)
  lander.core.fixture = love.physics.newFixture(lander.body, lander.core.shape)

  lander.landingGear = {}
  lander.landingGear[1] = {}
  lander.landingGear[1].shape = love.physics.newPolygonShape(-10, 13, -8, 10, -5, 10, -3, 13)
  lander.landingGear[1].fixture = love.physics.newFixture(lander.body, lander.landingGear[1].shape)
  lander.landingGear[1].fixture:setRestitution(0.1)

  lander.landingGear[2] = {}
  lander.landingGear[2].shape = love.physics.newPolygonShape(10, 13, 8, 10, 5, 10, 3, 13)
  lander.landingGear[2].fixture = love.physics.newFixture(lander.body, lander.landingGear[2].shape)
  lander.landingGear[2].fixture:setRestitution(0.1)

  lander.landingGear[3] = {}
  lander.landingGear[3].shape = love.physics.newRectangleShape(0, 7, 16, 3)
  lander.landingGear[3].fixture = love.physics.newFixture(lander.body, lander.landingGear[3].shape)
  lander.landingGear[3].fixture:setSensor(true)

  lander.thrusters = {}
  lander.thrusters[1] = {}
  lander.thrusters[1].shape = love.physics.newPolygonShape(-10, 13, -6.5, 17, -3, 13)

  lander.thrusters[2] = {}
  lander.thrusters[2].shape = love.physics.newPolygonShape(10, 13, 6.5, 17, 3, 13)

  lander.thrusters[3] = {}
  lander.thrusters[3].shape = love.physics.newPolygonShape(-8, 4, -14, 7, -8, 10)

  lander.thrusters[4] = {}
  lander.thrusters[4].shape = love.physics.newPolygonShape(8, 4, 14, 7, 8, 10)

  for _, thruster in pairs(lander.thrusters) do
    thruster.fixture = love.physics.newFixture(lander.body, thruster.shape)
    thruster.fixture:setSensor(true)
  end

  self.lander = lander

  terrain = {}
  terrain.body = love.physics.newBody(gWorld, 0, 0)
  terrain.shape = love.physics.newChainShape(false, gTerrain)
  terrain.fixture = love.physics.newFixture(terrain.body, terrain.shape)

  self.terrain = terrain
end

function PlayState:update(dt)
  gWorld:update(dt)

  if love.keyboard.waspressed("escape") then
    self.lander.body:destroy()
    self.terrain.body:destroy()
    gStateMachine:change("start")
  end
end

function PlayState:render()
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", self.lander.body:getX(), self.lander.body:getY(), self.lander.core.shape:getRadius())
  for _, gear in pairs(self.lander.landingGear) do
    love.graphics.polygon("line", self.lander.body:getWorldPoints(gear.shape:getPoints()))
  end
end
