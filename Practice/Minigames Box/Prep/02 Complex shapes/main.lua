WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500
RADIUS = 8
METER = 80

function addObject(x, y)
  local body = love.physics.newBody(world, x, y, "dynamic")

  local shape1 = love.physics.newCircleShape(RADIUS * 2, 0, RADIUS)
  local shape2 = love.physics.newCircleShape(-RADIUS * 2, 0, RADIUS)
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
  love.window.setTitle("Complex shapes")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 9.81 * METER, true)
  objects = {}

  platform = {}
  platform.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4)
  platform.shape = love.physics.newRectangleShape(WINDOW_WIDTH / 3, 16)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape)

  terrain = {}
  terrain.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT)
  terrain.shape =
    love.physics.newChainShape(
    false,
    -WINDOW_WIDTH / 2,
    -WINDOW_HEIGHT,
    -WINDOW_WIDTH / 2,
    -50,
    0,
    0,
    WINDOW_WIDTH / 2,
    -100,
    WINDOW_WIDTH / 2,
    -WINDOW_HEIGHT
  )
  terrain.fixture = love.physics.newFixture(terrain.body, terrain.shape)
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

  love.graphics.polygon("fill", platform.body:getWorldPoints(platform.shape:getPoints()))
  love.graphics.polygon("line", terrain.body:getWorldPoints(terrain.shape:getPoints()))
end
