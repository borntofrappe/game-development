WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400
IMPULSE = 15
VELOCITY = 10
GRAVITY = 18

local world
local lander
local walls

function love.load()
  love.window.setTitle("Box2D Module")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  world = love.physics.newWorld(0, GRAVITY)

  lander = {}
  lander.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")

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

  walls = {}
  walls.body = love.physics.newBody(world, 0, 0)
  walls.shape = love.physics.newChainShape(true, 0, 0, WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0, WINDOW_HEIGHT)
  walls.fixture = love.physics.newFixture(walls.body, walls.shape)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    lander.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    lander.body:setLinearVelocity(0, 0)
    lander.body:setAngularVelocity(0)
    lander.body:setAngle(0)
  end

  if key == "up" then
    lander.body:applyLinearImpulse(0, -IMPULSE)
  end

  if key == "right" then
    lander.body:applyLinearImpulse(IMPULSE / 2, 0)
  elseif key == "left" then
    lander.body:applyLinearImpulse(-IMPULSE / 2, 0)
  end
end

function love.update(dt)
  world:update(dt)

  if love.keyboard.isDown("up") then
    lander.body:applyForce(0, -VELOCITY)
  end

  if love.keyboard.isDown("right") then
    lander.body:applyForce(VELOCITY / 2, 0)
  elseif love.keyboard.isDown("left") then
    lander.body:applyForce(-VELOCITY / 2, 0)
  end
end

function love.draw()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setLineWidth(2)
  love.graphics.line(walls.body:getWorldPoints(walls.shape:getPoints()))

  love.graphics.setLineWidth(2)
  love.graphics.circle("line", lander.body:getX(), lander.body:getY(), lander.core.shape:getRadius())
  for _, gear in pairs(lander.landingGear) do
    love.graphics.polygon("line", lander.body:getWorldPoints(gear.shape:getPoints()))
  end

  if love.keyboard.isDown("up") then
    love.graphics.polygon("fill", lander.body:getWorldPoints(lander.thrusters[1].shape:getPoints()))
    love.graphics.polygon("fill", lander.body:getWorldPoints(lander.thrusters[2].shape:getPoints()))
  end

  if love.keyboard.isDown("right") then
    love.graphics.polygon("fill", lander.body:getWorldPoints(lander.thrusters[3].shape:getPoints()))
  elseif love.keyboard.isDown("left") then
    love.graphics.polygon("fill", lander.body:getWorldPoints(lander.thrusters[4].shape:getPoints()))
  end
end
