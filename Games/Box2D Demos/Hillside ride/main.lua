WINDOW_WIDTH = 640
WINDOW_HEIGHT = 400
METER = 100

function love.load()
  love.window.setTitle("Hillside ride")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 9.81 * METER, true)
  world:setCallbacks(beginContact)

  border = {}
  border.body = love.physics.newBody(world, 0, 0)
  border.shape = love.physics.newChainShape(true, 0, 0, 0, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, 0)
  border.fixture = love.physics.newFixture(border.body, border.shape)
  border.fixture:setUserData("Border")

  terrain = {
    ["y"] = WINDOW_HEIGHT * 3 / 4
  }

  terrain.body = love.physics.newBody(world, 0, terrain.y)

  local points = {}

  for i = 1, 300 do
    local x = -10 + (i - 1) * (WINDOW_WIDTH + 20) / 300
    local y = math.sin(i / 20) * 10
    table.insert(points, x)
    table.insert(points, y)
  end

  table.insert(points, WINDOW_WIDTH)
  table.insert(points, WINDOW_HEIGHT)

  table.insert(points, 0)
  table.insert(points, WINDOW_HEIGHT)

  terrain.shape = love.physics.newChainShape(false, points)
  terrain.fixture = love.physics.newFixture(terrain.body, terrain.shape)
  terrain.fixture:setUserData("Terrain")
  terrain.fixture:setFriction(0.1)

  car = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT * 3 / 4 - 30
  }

  direction = 1

  wheel1 = {}
  wheel1.body = love.physics.newBody(world, car.x - 15, car.y + 10, "dynamic")
  wheel1.shape = love.physics.newCircleShape(8)
  wheel1.fixture = love.physics.newFixture(wheel1.body, wheel1.shape)
  wheel1.fixture:setFriction(0.3)
  wheel1.fixture:setUserData("Wheel")

  wheel2 = {}
  wheel2.body = love.physics.newBody(world, car.x + 15, car.y + 10, "dynamic")
  wheel2.shape = love.physics.newCircleShape(8)
  wheel2.fixture = love.physics.newFixture(wheel2.body, wheel2.shape)
  wheel2.fixture:setFriction(0.3)
  wheel2.fixture:setUserData("Wheel")

  square = {}
  square.body = love.physics.newBody(world, car.x, car.y, "dynamic")
  square.shape = love.physics.newRectangleShape(60, 15)
  square.fixture = love.physics.newFixture(square.body, square.shape)
  square.fixture:setFriction(0.1)
  square.fixture:setUserData("Car")

  wheel1joint = love.physics.newRevoluteJoint(square.body, wheel1.body, wheel1.body:getX(), wheel1.body:getY())
  wheel1joint:setMotorSpeed(math.pi * 100 * direction)
  wheel1joint:setMaxMotorTorque(500)
  wheel1joint:setMotorEnabled(true)

  wheel2joint = love.physics.newRevoluteJoint(square.body, wheel2.body, wheel2.body:getX(), wheel2.body:getY())
  wheel2joint:setMotorSpeed(math.pi * 100 * direction)
  wheel2joint:setMaxMotorTorque(500)
  wheel2joint:setMotorEnabled(true)

  speedUp()
end

function changeDirection(dir)
  direction = dir or direction * -1
  wheel1joint:setMotorSpeed(math.pi * 30 * direction)
  wheel2joint:setMotorSpeed(math.pi * 30 * direction)
end

function speedUp()
  square.body:applyForce(1200 * direction, 0)
end

function beginContact(fixture1, fixture2)
  local userData = {}
  local userData1 = fixture1:getUserData()
  local userData2 = fixture2:getUserData()
  userData[userData1] = true
  userData[userData2] = true

  if userData["Border"] and userData["Car"] then
    changeDirection()
    speedUp()
  end
end

function love.mousepressed()
  changeDirection()
  speedUp()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "right" then
    changeDirection(1)
    speedUp()
  elseif key == "left" then
    changeDirection(-1)
    speedUp()
  end
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.polygon("line", terrain.body:getWorldPoints(terrain.shape:getPoints()))

  love.graphics.circle("line", wheel1.body:getX(), wheel1.body:getY(), wheel1.shape:getRadius())
  love.graphics.circle("line", wheel2.body:getX(), wheel2.body:getY(), wheel2.shape:getRadius())
  love.graphics.polygon("line", square.body:getWorldPoints(square.shape:getPoints()))
end
