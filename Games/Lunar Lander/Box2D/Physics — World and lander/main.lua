WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500

VELOCITY = 100
IMPULSE = 40
METER = 10
GRAVITY = 1.62

function love.load()
  love.window.setTitle("Physics")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * METER, true)

  lander = {}
  lander.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  lander.core = {}
  lander.core.shape = love.physics.newCircleShape(10)
  lander.core.fixture = love.physics.newFixture(lander.body, lander.core.shape)

  lander.landingGear = {}
  lander.landingGear[1] = {}
  lander.landingGear[1].shape = love.physics.newPolygonShape(-11, 13, -8, 9, -6, 9, -3, 13)
  lander.landingGear[1].fixture = love.physics.newFixture(lander.body, lander.landingGear[1].shape)

  lander.landingGear[2] = {}
  lander.landingGear[2].shape = love.physics.newPolygonShape(11, 13, 8, 9, 6, 9, 3, 13)
  lander.landingGear[2].fixture = love.physics.newFixture(lander.body, lander.landingGear[2].shape)

  lander.landingGear[3] = {}
  lander.landingGear[3].shape = love.physics.newRectangleShape(0, 8.5, 16, 2)
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

  if key == "up" then
    lander.body:applyLinearImpulse(0, -IMPULSE)
  end
  if key == "right" then
    lander.body:applyLinearImpulse(math.floor(IMPULSE / 2), 0)
  elseif key == "left" then
    lander.body:applyLinearImpulse(-math.floor(IMPULSE / 2), 0)
  end
end

function love.update(dt)
  world:update(dt)

  if love.keyboard.isDown("up") then
    lander.body:applyForce(0, -VELOCITY)
  end
  if love.keyboard.isDown("right") then
    lander.body:applyForce(VELOCITY, 0)
  elseif love.keyboard.isDown("left") then
    lander.body:applyForce(-VELOCITY, 0)
  end
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)

  love.graphics.setLineWidth(2)
  love.graphics.circle("line", lander.body:getX(), lander.body:getY(), lander.core.shape:getRadius())
  for i, gear in ipairs(lander.landingGear) do
    love.graphics.polygon("line", lander.body:getWorldPoints(gear.shape:getPoints()))
  end

  local x, y = lander.body:getLinearVelocity()
  love.graphics.print("x velocity: " .. formatVelocity(x), 8, 8)
  love.graphics.print("y velocity: " .. formatVelocity(y), 8, 32)

  if love.keyboard.isDown("up") then
    love.graphics.polygon(
      "line",
      lander.body:getX() - 9,
      lander.body:getY() + 13,
      lander.body:getX() - 7,
      lander.body:getY() + 16,
      lander.body:getX() - 5,
      lander.body:getY() + 13
    )
    love.graphics.polygon(
      "line",
      lander.body:getX() + 9,
      lander.body:getY() + 13,
      lander.body:getX() + 7,
      lander.body:getY() + 16,
      lander.body:getX() + 5,
      lander.body:getY() + 13
    )
  end
  if love.keyboard.isDown("right") then
    love.graphics.polygon(
      "line",
      lander.body:getX() - 8,
      lander.body:getY() + 5.5,
      lander.body:getX() - 12.5,
      lander.body:getY() + 8,
      lander.body:getX() - 8,
      lander.body:getY() + 10.5
    )
  elseif love.keyboard.isDown("left") then
    love.graphics.polygon(
      "line",
      lander.body:getX() + 8,
      lander.body:getY() + 5.5,
      lander.body:getX() + 12.5,
      lander.body:getY() + 8,
      lander.body:getX() + 8,
      lander.body:getY() + 10.5
    )
  end
end

function formatVelocity(velocity)
  return math.floor(velocity)
end
