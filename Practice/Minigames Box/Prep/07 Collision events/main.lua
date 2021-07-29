WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500
MAX_SIZE = 20
METER = 50
VELOCITY = 200

function addObject()
  local x = math.random(MAX_SIZE, WINDOW_WIDTH - MAX_SIZE)
  local y = math.random(WINDOW_HEIGHT / 4) * -1
  local size = math.random(math.floor(MAX_SIZE / 2), MAX_SIZE)
  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newRectangleShape(size, size)
  local fixture = love.physics.newFixture(body, shape)
  fixture:setUserData("Object")

  table.insert(
    objects,
    {
      ["body"] = body,
      ["shape"] = shape,
      ["fixture"] = fixture
    }
  )
end

function beginContact(fixture1, fixture2)
  local userData = {}
  local userData1 = fixture1:getUserData()
  local userData2 = fixture2:getUserData()
  userData[userData1] = true
  userData[userData2] = true

  if userData["Player"] and userData["Object"] then
    if userData1 == "Object" then
      fixture1:getBody():destroy()
    else
      fixture2:getBody():destroy()
    end
  end
end

function love.load()
  love.window.setTitle("Collision events")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 9.81 * METER, true)
  world:setCallbacks(beginContact)

  platformBottom = {}
  platformBottom.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT)
  platformBottom.shape = love.physics.newRectangleShape(WINDOW_WIDTH, 10)
  platformBottom.fixture = love.physics.newFixture(platformBottom.body, platformBottom.shape)
  platformBottom.fixture:setUserData("Platform")

  player = {}
  player.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4, "kinematic")
  player.shape = love.physics.newCircleShape(MAX_SIZE)
  player.fixture = love.physics.newFixture(player.body, player.shape)
  player.fixture:setUserData("Player")

  objects = {}
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

  if key == "up" then
    player.body:setLinearVelocity(0, -VELOCITY)
  elseif key == "right" then
    player.body:setLinearVelocity(VELOCITY, 0)
  elseif key == "down" then
    player.body:setLinearVelocity(0, VELOCITY)
  elseif key == "left" then
    player.body:setLinearVelocity(-VELOCITY, 0)
  end
end

function love.update(dt)
  if math.random(4) == 1 then
    addObject()
  end

  for i, object in ipairs(objects) do
    if object.body:isDestroyed() then
      table.remove(objects, i)
    elseif object.body:getY() > WINDOW_HEIGHT then
      object.body:destroy()
      table.remove(objects, i)
    end
  end

  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  for i, object in ipairs(objects) do
    if not object.body:isDestroyed() then
      love.graphics.polygon("line", object.body:getWorldPoints(object.shape:getPoints()))
    end
  end

  love.graphics.setColor(0.87, 0.26, 0.75)
  love.graphics.circle("fill", player.body:getX(), player.body:getY(), player.shape:getRadius())

  love.graphics.print(#objects, 8, 8)
end
