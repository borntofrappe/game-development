WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500

METER = 20

GRAVITY = 9.81

function love.load()
  love.window.setTitle("Complex shape lander")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  love.physics.setMeter(METER)

  isUpdating = true

  world = love.physics.newWorld(0, GRAVITY * METER, true)

  lander = {}
  lander.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  lander.core = {}
  lander.core.shape = love.physics.newCircleShape(9)
  lander.core.fixture = love.physics.newFixture(lander.body, lander.core.shape)

  lander.landingGear = {}
  lander.landingGear[1] = {}
  lander.landingGear[1].shape = love.physics.newPolygonShape(-10, 12, -7, 8, -5, 8, -2, 12)
  lander.landingGear[1].fixture = love.physics.newFixture(lander.body, lander.landingGear[1].shape)
  lander.landingGear[1].fixture:setRestitution(0.5)

  lander.landingGear[2] = {}
  lander.landingGear[2].shape = love.physics.newPolygonShape(10, 12, 7, 8, 5, 8, 2, 12)
  lander.landingGear[2].fixture = love.physics.newFixture(lander.body, lander.landingGear[2].shape)
  lander.landingGear[2].fixture:setRestitution(0.5)

  lander.landingGear[3] = {}
  lander.landingGear[3].shape = love.physics.newRectangleShape(0, 8, 8, 2)
  lander.landingGear[3].fixture = love.physics.newFixture(lander.body, lander.landingGear[3].shape)
  lander.landingGear[3].fixture:setSensor(true)

  terrain = {}
  terrain.body = love.physics.newBody(world, 0, WINDOW_HEIGHT)
  terrain.shape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  terrain.fixture = love.physics.newFixture(terrain.body, terrain.shape)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key:lower() == "r" then
    lander.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    lander.body:setLinearVelocity(0, 0)
    lander.body:setAngularVelocity(0)
    lander.body:setAngle(0)
  end

  if key:lower() == "p" then
    isUpdating = not isUpdating
  end
end

function love.update(dt)
  if isUpdating then
    world:update(dt)
  end
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)

  love.graphics.setLineWidth(2)
  love.graphics.circle("line", lander.body:getX(), lander.body:getY(), lander.core.shape:getRadius())
  for i, gear in ipairs(lander.landingGear) do
    love.graphics.polygon("line", lander.body:getWorldPoints(gear.shape:getPoints()))
  end
end
