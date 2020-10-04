WINDOW_WIDTH = 580
WINDOW_HEIGHT = 460

function love.load()
  love.window.setTitle("Angry Birds")

  world = love.physics.newWorld(0, 300)

  boxBody = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  boxShape = love.physics.newRectangleShape(20, 20)
  boxFixture = love.physics.newFixture(boxBody, boxShape)
  boxFixture:setRestitution(0.9)

  groundBody = love.physics.newBody(world, 0, WINDOW_HEIGHT - 5, "static")
  groundShape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  groundFixture = love.physics.newFixture(groundBody, groundShape)

  kinematicObjects = {}
  numObjects = 4
  kinematicShape = love.physics.newRectangleShape(30, 30)
  for i = 5, numObjects do
    kinematicObjects[i] = {
      body = love.physics.newBody(
        world,
        WINDOW_WIDTH / 2 + (i - (numObjects + 1) / 2) * 75,
        WINDOW_HEIGHT / 2 + 150,
        "kinematic"
      ),
      shape = kinematicShape
    }
    kinematicObjects[i].fixture = love.physics.newFixture(kinematicObjects[i].body, kinematicObjects[i].shape)
    local angularVelocity = i % 2 == 0 and math.pi or -math.pi
    kinematicObjects[i].body:setAngularVelocity(angularVelocity)
  end

  love.graphics.setBackgroundColor(0.08, 0.08, 0.08)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    boxBody:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    boxBody:setLinearVelocity(0, 0)
    boxBody:setAngle(0)
    boxBody:setAngularVelocity(0)
  end
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", boxBody:getWorldPoints(boxShape:getPoints()))

  love.graphics.setColor(0.9, 0.1, 0.5)
  love.graphics.setLineWidth(10)
  love.graphics.line(groundBody:getWorldPoints(groundShape:getPoints()))

  love.graphics.setColor(0.25, 0.25, 1)
  for k, kinematicObject in pairs(kinematicObjects) do
    love.graphics.polygon("fill", kinematicObject.body:getWorldPoints(kinematicObject.shape:getPoints()))
  end
end
