WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500
RADIUS = 8
METER = 80
RADIUS_BRIDGE = 10

function addObject(x, y)
  local body = love.physics.newBody(world, x, y, "dynamic")

  local shape1 = love.physics.newCircleShape(RADIUS * 1.5, 0, RADIUS)
  local shape2 = love.physics.newCircleShape(-RADIUS * 1.5, 0, RADIUS)
  local shape3 = love.physics.newRectangleShape(RADIUS * 4, RADIUS * 2 / 3)

  local fixture1 = love.physics.newFixture(body, shape1)
  local fixture2 = love.physics.newFixture(body, shape2)
  local fixture3 = love.physics.newFixture(body, shape3)

  table.insert(
    objects,
    {
      ["body"] = body,
      ["shapes"] = {
        shape1,
        shape2,
        shape3
      },
      ["fixtures"] = {
        fixture1,
        fixture2,
        fixture3
      }
    }
  )
end

function love.load()
  love.window.setTitle("Distance joint")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 9.81 * METER, true)
  objects = {}

  objectsBridge = {}
  objectsBridgeNumber = math.floor(WINDOW_WIDTH / (RADIUS_BRIDGE * 2)) + 1

  for i = 1, objectsBridgeNumber do
    local x = (i - 1) * RADIUS_BRIDGE * 2
    local y = WINDOW_HEIGHT / 2
    local type = i == 1 or i == objectsBridgeNumber and "static" or "dynamic"
    local body = love.physics.newBody(world, x, y, type)
    local shape = love.physics.newCircleShape(RADIUS_BRIDGE)
    local fixture = love.physics.newFixture(body, shape)
    table.insert(
      objectsBridge,
      {
        ["body"] = body,
        ["shapes"] = shape,
        ["fixtures"] = fixture
      }
    )
  end

  for i = 1, objectsBridgeNumber - 1 do
    local body1 = objectsBridge[i].body
    local body2 = objectsBridge[i + 1].body

    local x1 = body1:getX()
    local y1 = body1:getY()

    local x2 = body2:getX()
    local y2 = body2:getY()

    love.physics.newDistanceJoint(body1, body2, x1, y1, x2, y2)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    addObject(x, y)
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
  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    addObject(x, y)
  end

  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  for i, object in ipairs(objects) do
    local cx1, cy1 = object.body:getWorldPoints(object.shapes[1]:getPoint())
    love.graphics.circle("fill", cx1, cy1, object.shapes[1]:getRadius())

    local cx2, cy2 = object.body:getWorldPoints(object.shapes[2]:getPoint())
    love.graphics.circle("fill", cx2, cy2, object.shapes[2]:getRadius())

    love.graphics.polygon("fill", object.body:getWorldPoints(object.shapes[3]:getPoints()))
  end

  for i, circle in ipairs(objectsBridge) do
    local cx1 = circle.body:getX()
    local cy1 = circle.body:getY()

    if i ~= #objectsBridge then
      local cx2 = objectsBridge[i + 1].body:getX()
      local cy2 = objectsBridge[i + 1].body:getY()
      love.graphics.line(cx1, cy1, cx2, cy2)
    end
    love.graphics.circle("fill", cx1, cy1, circle.shapes:getRadius())
  end
end
