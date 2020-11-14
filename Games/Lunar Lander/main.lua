require "src/Dependencies"

function love.load()
  love.window.setTitle("Lunar Lander")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  font = love.graphics.newFont("res/font.ttf", 14)
  love.graphics.setFont(font)

  data = {
    ["score"] = 0,
    ["time"] = 0,
    ["fuel"] = 1000,
    ["altitude"] = 0,
    ["horizontal speed"] = 0,
    ["vertical speed"] = 0
  }

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * METER, true)

  lander = {}
  lander.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  lander.core = {}
  lander.core.shape = love.physics.newCircleShape(9)
  lander.core.fixture = love.physics.newFixture(lander.body, lander.core.shape)

  lander.landingGear = {}
  lander.landingGear[1] = {}
  lander.landingGear[1].shape = love.physics.newPolygonShape(-10, 12, -7, 8, -5, 8, -2, 12)
  lander.landingGear[1].fixture = love.physics.newFixture(lander.body, lander.landingGear[1].shape)

  lander.landingGear[2] = {}
  lander.landingGear[2].shape = love.physics.newPolygonShape(10, 12, 7, 8, 5, 8, 2, 12)
  lander.landingGear[2].fixture = love.physics.newFixture(lander.body, lander.landingGear[2].shape)

  lander.landingGear[3] = {}
  lander.landingGear[3].shape = love.physics.newRectangleShape(0, 8, 8, 2)
  lander.landingGear[3].fixture = love.physics.newFixture(lander.body, lander.landingGear[3].shape)
  lander.landingGear[3].fixture:setSensor(true)

  lander.signifiers = {}
  lander.signifiers[1] = {}
  lander.signifiers[1].shape = love.physics.newPolygonShape(-9, 13, -7, 16, -5, 13)
  lander.signifiers[1].fixture = love.physics.newFixture(lander.body, lander.signifiers[1].shape)
  lander.signifiers[1].fixture:setSensor(true)

  lander.signifiers[2] = {}
  lander.signifiers[2].shape = love.physics.newPolygonShape(9, 13, 7, 16, 5, 13)
  lander.signifiers[2].fixture = love.physics.newFixture(lander.body, lander.signifiers[2].shape)
  lander.signifiers[2].fixture:setSensor(true)

  lander.signifiers[3] = {}
  lander.signifiers[3].shape = love.physics.newPolygonShape(-8, 6, -12, 8, -8, 10)
  lander.signifiers[3].fixture = love.physics.newFixture(lander.body, lander.signifiers[3].shape)
  lander.signifiers[3].fixture:setSensor(true)

  lander.signifiers[4] = {}
  lander.signifiers[4].shape = love.physics.newPolygonShape(8, 6, 12, 8, 8, 10)
  lander.signifiers[4].fixture = love.physics.newFixture(lander.body, lander.signifiers[4].shape)
  lander.signifiers[4].fixture:setSensor(true)

  terrain = {}
  terrain.body = love.physics.newBody(world, 0, WINDOW_HEIGHT)

  local terrainPoints = getTerrainPoints()
  table.insert(terrainPoints, WINDOW_WIDTH)
  table.insert(terrainPoints, 0)
  table.insert(terrainPoints, 0)
  table.insert(terrainPoints, 0)

  terrain.shape = love.physics.newChainShape(false, terrainPoints)
  terrain.fixture = love.physics.newFixture(terrain.body, terrain.shape)

  love.keyboard.keyPressed = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key:lower() == "r" then
    lander.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    lander.body:setLinearVelocity(0, 0)
    lander.body:setAngularVelocity(0)
    lander.body:setAngle(0)
  end

  if key == "up" then
    lander.body:applyLinearImpulse(0, -IMPULSE)
  end
  if key == "right" then
    lander.body:applyLinearImpulse(math.floor(IMPULSE / 2), 0)
  elseif key == "left" then
    lander.body:applyLinearImpulse(-math.floor(IMPULSE / 2), 0)
  end
end

function love.update(dt)
  world:update(dt)

  local vx, vy = lander.body:getLinearVelocity()
  data["horizontal speed"] = math.floor(vx)
  data["vertical speed"] = math.floor(vy)

  if love.keyboard.isDown("up") then
    lander.body:applyForce(0, -VELOCITY)
    data["fuel"] = data["fuel"] - 1
  end
  if love.keyboard.isDown("right") then
    data["fuel"] = data["fuel"] - 0.5
    lander.body:applyForce(VELOCITY, 0)
  elseif love.keyboard.isDown("left") then
    data["fuel"] = data["fuel"] - 0.5
    lander.body:applyForce(-VELOCITY, 0)
  end
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.setLineWidth(1)
  love.graphics.polygon("line", terrain.body:getWorldPoints(terrain.shape:getPoints()))

  love.graphics.setLineWidth(2)
  love.graphics.circle("line", lander.body:getX(), lander.body:getY(), lander.core.shape:getRadius())
  for i, gear in ipairs(lander.landingGear) do
    love.graphics.polygon("line", lander.body:getWorldPoints(gear.shape:getPoints()))
  end

  if love.keyboard.isDown("up") then
    love.graphics.polygon("line", lander.body:getWorldPoints(lander.signifiers[1].shape:getPoints()))
    love.graphics.polygon("line", lander.body:getWorldPoints(lander.signifiers[2].shape:getPoints()))
  end

  if love.keyboard.isDown("right") then
    love.graphics.polygon("line", lander.body:getWorldPoints(lander.signifiers[3].shape:getPoints()))
  elseif love.keyboard.isDown("left") then
    love.graphics.polygon("line", lander.body:getWorldPoints(lander.signifiers[4].shape:getPoints()))
  end

  displayData()
end

function displayData()
  displayKeyValuePairs(
    {"score", "time", "fuel"},
    {formatNumber, formatTime, formatNumber},
    WINDOW_WIDTH / 6 + 8,
    8,
    font:getWidth("score  "),
    font:getHeight() * 0.9
  )

  displayKeyValuePairs(
    {"altitude", "horizontal speed", "vertical speed"},
    {nil, formatHorizontalSpeed, formatVerticalSpeed},
    WINDOW_WIDTH / 2 + 16,
    8,
    font:getWidth("horizontal speed  "),
    font:getHeight() * 0.9
  )
end

function displayKeyValuePairs(keys, formattingFunctions, startX, startY, gapX, gapY)
  for i, key in ipairs(keys) do
    local formattingFunction = formattingFunctions[i]
    local value = formattingFunction and formattingFunction(data[key]) or data[key]
    local y = startY + (i - 1) * gapY
    local xKey = startX
    local xValue = startX + gapX

    love.graphics.print(key:upper(), xKey, y)
    love.graphics.print(value, xValue, y)
  end
end