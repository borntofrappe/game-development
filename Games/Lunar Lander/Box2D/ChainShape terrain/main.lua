WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500

METER = 20

GRAVITY = 9.81
RESTITUTION = 0.5
RADIUS = 8

function love.load()
  love.window.setTitle("ChainShape terrain")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  love.physics.setMeter(METER)

  world = love.physics.newWorld(0, GRAVITY * METER, true)

  objects = {}
  addObject(WINDOW_WIDTH / 2, 16)

  terrain = {}
  terrain.body = love.physics.newBody(world, 0, WINDOW_HEIGHT)

  local points = makeTerrain()
  table.insert(points, WINDOW_WIDTH)
  table.insert(points, 0)
  table.insert(points, 0)
  table.insert(points, 0)

  terrain.shape = love.physics.newChainShape(false, points)
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
  end
end

function love.update(dt)
  if love.mouse.isDown(1) then
    addObject(love.mouse.getPosition())
  end

  world:update(dt)
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.polygon("line", terrain.body:getWorldPoints(terrain.shape:getPoints()))

  for i, object in ipairs(objects) do
    love.graphics.circle("line", object.body:getX(), object.body:getY(), object.shape:getRadius())
  end
end

function addObject(x, y)
  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newCircleShape(RADIUS)
  local fixture = love.physics.newFixture(body, shape)
  fixture:setRestitution(0.5)
  table.insert(
    objects,
    {
      ["body"] = body,
      ["shape"] = shape,
      ["fixture"] = fixture
    }
  )
end

-- borrowed from LunarLander/src/Utils
function makeTerrain()
  local terrain = {}
  local offset = love.math.random(1000)
  local increment = 0.1
  local points = 50
  local terrainHeightRandom = love.math.random(15, 30)
  local terrainHeightNoise = WINDOW_HEIGHT / 2 - terrainHeightRandom

  for i = 0, points do
    local x = i * WINDOW_WIDTH / points
    local y = (love.math.noise(offset) * terrainHeightNoise + love.math.random() * terrainHeightRandom) * -1

    table.insert(terrain, x)
    table.insert(terrain, y)

    offset = offset + increment
  end

  return terrain
end
