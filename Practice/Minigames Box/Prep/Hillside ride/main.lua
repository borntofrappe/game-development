WINDOW_WIDTH = 820
WINDOW_HEIGHT = 360
METER = 100

function love.load()
  love.window.setTitle("Hillside ride")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  love.physics.setMeter(METER)

  world = love.physics.newWorld(0, 9.81 * METER, true)
  world:setCallbacks(beginContact)

  -- edges
  border = {}
  edges = {
    {
      x1 = 0,
      y1 = 0,
      x2 = WINDOW_WIDTH,
      y2 = 0
    },
    {
      x1 = WINDOW_WIDTH,
      y1 = 0,
      x2 = WINDOW_WIDTH,
      y2 = WINDOW_HEIGHT
    },
    {
      x1 = WINDOW_WIDTH,
      y1 = WINDOW_HEIGHT,
      x2 = 0,
      y2 = WINDOW_HEIGHT
    },
    {
      x1 = 0,
      y1 = WINDOW_HEIGHT,
      x2 = 0,
      y2 = 0
    }
  }
  for i, edge in ipairs(edges) do
    local body = love.physics.newBody(world, edge.x1, edge.y1)
    local shape = love.physics.newEdgeShape(0, 0, edge.x2 - edge.x1, edge.y2 - edge.y1)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setUserData("Edge")
  end

  -- terrain
  terrain = {
    ["y"] = WINDOW_HEIGHT * 3 / 4
  }

  terrain.body = love.physics.newBody(world, 0, terrain.y)

  local points = {}

  for i = 1, 300 do
    local x = -10 + (i - 1) * (WINDOW_WIDTH + 20) / 300
    local y = math.sin(i / 14) * 10
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

  -- vehicle
  car = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT * 3 / 4 - 30,
    ["direction"] = 1
  }

  wheelLeft = {}
  wheelLeft.body = love.physics.newBody(world, car.x - 15, car.y + 10, "dynamic")
  wheelLeft.shape = love.physics.newCircleShape(8)
  wheelLeft.fixture = love.physics.newFixture(wheelLeft.body, wheelLeft.shape)
  wheelLeft.fixture:setFriction(1)
  wheelLeft.fixture:setUserData("Wheel")

  wheelRight = {}
  wheelRight.body = love.physics.newBody(world, car.x + 15, car.y + 10, "dynamic")
  wheelRight.shape = love.physics.newCircleShape(8)
  wheelRight.fixture = love.physics.newFixture(wheelRight.body, wheelRight.shape)
  wheelRight.fixture:setFriction(1)
  wheelRight.fixture:setUserData("Wheel")

  car.body = love.physics.newBody(world, car.x, car.y, "dynamic")
  car.shape = love.physics.newRectangleShape(60, 15)
  car.fixture = love.physics.newFixture(car.body, car.shape)
  car.fixture:setFriction(0.1)
  car.fixture:setUserData("Car")

  revoluteJointLeft =
    love.physics.newRevoluteJoint(car.body, wheelLeft.body, wheelLeft.body:getX(), wheelLeft.body:getY())
  revoluteJointLeft:setMotorSpeed(math.pi * 10 * car.direction)
  revoluteJointLeft:setMaxMotorTorque(500)
  revoluteJointLeft:setMotorEnabled(true)

  revoluteJointRight =
    love.physics.newRevoluteJoint(car.body, wheelRight.body, wheelRight.body:getX(), wheelRight.body:getY())
  revoluteJointRight:setMotorSpeed(math.pi * 10 * car.direction)
  revoluteJointRight:setMaxMotorTorque(500)
  revoluteJointRight:setMotorEnabled(true)
end

function changeDirection(dir)
  car.direction = dir or car.direction * -1
  revoluteJointLeft:setMotorSpeed(math.pi * 10 * car.direction)
  revoluteJointRight:setMotorSpeed(math.pi * 10 * car.direction)
end

function speedUp()
  car.body:applyForce(700 * car.direction, 0)
  wheelLeft.body:applyForce(500 * car.direction, 0)
  wheelRight.body:applyForce(500 * car.direction, 0)
end

function beginContact(fixture1, fixture2)
  local userData = {}
  local userData1 = fixture1:getUserData()
  local userData2 = fixture2:getUserData()
  userData[userData1] = true
  userData[userData2] = true

  if userData["Edge"] and userData["Car"] then
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

  if key == "space" then
    speedUp()
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

  love.graphics.circle("line", wheelLeft.body:getX(), wheelLeft.body:getY(), wheelLeft.shape:getRadius())
  love.graphics.circle("line", wheelRight.body:getX(), wheelRight.body:getY(), wheelRight.shape:getRadius())
  love.graphics.polygon("line", car.body:getWorldPoints(car.shape:getPoints()))
end
