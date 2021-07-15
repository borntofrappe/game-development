local WINDOW_WIDTH = 580
local WINDOW_HEIGHT = 460

local world
local box
local ground
local kinematicObjects
local KINEMATIC_OBJECTS = 5

function love.load()
  love.window.setTitle("Angry Birds")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.08, 0.08, 0.08)

  world = love.physics.newWorld(0, 300)

  box = {}
  box.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  box.shape = love.physics.newRectangleShape(20, 20)
  box.fixture = love.physics.newFixture(box.body, box.shape)
  box.fixture:setRestitution(0.9)

  ground = {}
  ground.body = love.physics.newBody(world, 0, WINDOW_HEIGHT - 5, "static")
  ground.shape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  ground.fixture = love.physics.newFixture(ground.body, ground.shape)

  kinematicObjects = {}
  for i = 1, KINEMATIC_OBJECTS do
    local body =
      love.physics.newBody(
      world,
      WINDOW_WIDTH / 2 + (i - (KINEMATIC_OBJECTS + 1) / 2) * 75,
      WINDOW_HEIGHT / 2 + 150,
      "kinematic"
    )
    local shape = love.physics.newRectangleShape(30, 30)
    local fixture = love.physics.newFixture(body, shape)

    local angularVelocity = i % 2 == 0 and math.pi or -math.pi
    body:setAngularVelocity(angularVelocity)

    table.insert(
      kinematicObjects,
      {
        ["body"] = body,
        ["shape"] = shape,
        ["fixture"] = fixture
      }
    )
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    box.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    box.body:setLinearVelocity(0, 0)
    box.body:setAngle(0)
    box.body:setAngularVelocity(0)
  end
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", box.body:getWorldPoints(box.shape:getPoints()))

  love.graphics.setColor(0.9, 0.1, 0.5)
  love.graphics.setLineWidth(10)
  love.graphics.line(ground.body:getWorldPoints(ground.shape:getPoints()))

  love.graphics.setColor(0.25, 0.25, 1)
  for k, kinematicObject in pairs(kinematicObjects) do
    love.graphics.polygon("fill", kinematicObject.body:getWorldPoints(kinematicObject.shape:getPoints()))
  end
end
