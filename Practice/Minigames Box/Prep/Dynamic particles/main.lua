WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500
RADIUS = 10
METER = 80

function love.load()
  love.window.setTitle("Dynamic particles")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 9.81 * METER, true)
  objects = {}
end

function love.mousepressed(x, y, button)
  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newCircleShape(RADIUS)
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

    local body = love.physics.newBody(world, x, y, "dynamic")
    local shape = love.physics.newCircleShape(RADIUS)
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

  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  for i, object in ipairs(objects) do
    love.graphics.circle("fill", object.body:getX(), object.body:getY(), object.shape:getRadius())
  end
end
