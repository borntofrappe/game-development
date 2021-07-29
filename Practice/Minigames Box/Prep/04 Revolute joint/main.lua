WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500
RADIUS = 6
METER = 40

function addObject()
  local x = WINDOW_WIDTH / 2.5 + math.random(WINDOW_WIDTH / 5)
  local y = math.random(WINDOW_HEIGHT / 8) * -1
  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newCircleShape(math.random(math.floor(RADIUS / 2), RADIUS))
  local fixture = love.physics.newFixture(body, shape)
  table.insert(
    objects,
    {
      ["body"] = body,
      ["shape"] = shape,
      ["fixture"] = fixture
    }
  )
end

function love.load()
  love.window.setTitle("Revolute joint")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 9.81 * METER, true)
  objects = {}

  platform = {}
  platform.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4)
  platform.shape = love.physics.newRectangleShape(15, 50)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape)

  rotor = {}
  rotor.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4 - 25, "dynamic")
  rotor.shape = love.physics.newRectangleShape(WINDOW_WIDTH / 5, 10)
  rotor.fixture = love.physics.newFixture(rotor.body, rotor.shape)

  revoluteJoint = love.physics.newRevoluteJoint(platform.body, rotor.body, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4 - 25)

  revoluteJoint:setMotorSpeed(math.pi * 2)
  revoluteJoint:setMaxMotorTorque(10000)
  revoluteJoint:setMotorEnabled(true)

  local x, y = revoluteJoint:getAnchors()
  anchor = {
    ["x"] = x,
    ["y"] = y
  }
end

function love.mousepressed(x, y, button)
  if button == 1 then
    revoluteJoint:setMotorEnabled(not revoluteJoint:isMotorEnabled())
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    for i, object in ipairs(objects) do
      object.body:destroy()
    end
    objects = {}
  end
end

function love.update(dt)
  if math.random(2) == 1 then
    addObject()
  end

  for i, object in ipairs(objects) do
    if object.body:getY() > WINDOW_HEIGHT then
      object.body:destroy()
      table.remove(objects, i)
    end
  end

  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  for i, object in ipairs(objects) do
    love.graphics.circle("line", object.body:getX(), object.body:getY(), object.shape:getRadius())
  end

  if revoluteJoint:isMotorEnabled() then
    love.graphics.setColor(0.25, 1, 0.5)
  else
    love.graphics.setColor(1, 0.25, 0.5)
  end
  love.graphics.polygon("fill", platform.body:getWorldPoints(platform.shape:getPoints()))
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", rotor.body:getWorldPoints(rotor.shape:getPoints()))

  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("fill", anchor.x, anchor.y, 2)
end
