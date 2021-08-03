WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

local world
local lander
local walls

function love.load()
  love.window.setTitle("Box2D Module")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  world = love.physics.newWorld(0, 20)

  lander = {}
  lander.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")

  lander.core = {}
  lander.core.shape = love.physics.newCircleShape(9)
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
  lander.landingGear[3].shape = love.physics.newRectangleShape(0, 7, 14, 3)
  lander.landingGear[3].fixture = love.physics.newFixture(lander.body, lander.landingGear[3].shape)
  lander.landingGear[3].fixture:setSensor(true)

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
end

function love.update(dt)
  -- world:update(dt)
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
end
