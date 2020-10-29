WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500
MAX_SIZE = 24
METER = 50
FORCE = 50

function addObjects()
  for i = 1, 20 do
    local x = math.random(MAX_SIZE, WINDOW_WIDTH - MAX_SIZE)
    local y = math.random(WINDOW_HEIGHT / 4) * -1
    local size = math.random(math.floor(MAX_SIZE / 2), MAX_SIZE)
    local body = love.physics.newBody(world, x, y, "dynamic")
    local shape = love.physics.newRectangleShape(size, size)
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
end

function love.load()
  love.window.setTitle("Body force")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 9.81 * METER, true)

  platformLeft = {}
  platformLeft.body = love.physics.newBody(world, 0, WINDOW_HEIGHT / 2)
  platformLeft.shape = love.physics.newRectangleShape(10, WINDOW_HEIGHT)
  platformLeft.fixture = love.physics.newFixture(platformLeft.body, platformLeft.shape)

  platformRight = {}
  platformRight.body = love.physics.newBody(world, WINDOW_WIDTH, WINDOW_HEIGHT / 2)
  platformRight.shape = love.physics.newRectangleShape(10, WINDOW_HEIGHT)
  platformRight.fixture = love.physics.newFixture(platformRight.body, platformRight.shape)

  objects = {}
  timer = 0
  interval = 0.5
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
  timer = timer + dt
  if timer > interval then
    timer = timer % interval
    addObjects()
  end

  for i, object in ipairs(objects) do
    if object.body:getY() > WINDOW_HEIGHT then
      object.body:destroy()
      table.remove(objects, i)
    end
  end

  if love.mouse.isDown(1) then
    local x1 = love.mouse:getPosition()

    for i, object in ipairs(objects) do
      local x2 = object.body:getX()
      local direction = x1 > x2 and 1 or -1
      object.body:applyForce(FORCE * direction, 0)
    end
  end
  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  for i, object in ipairs(objects) do
    love.graphics.polygon("line", object.body:getWorldPoints(object.shape:getPoints()))
  end
end
