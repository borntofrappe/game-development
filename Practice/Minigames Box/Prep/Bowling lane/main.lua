WINDOW_WIDTH = 360
WINDOW_HEIGHT = 520
BALL_RADIUS = 20
BALL_IMPULSE_MAX = 800
PIN_RADIUS = 15
TIMER_DELAY = 2

function love.load()
  love.window.setTitle("Bowling lane")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  font = love.graphics.newFont("font.ttf", 24)
  love.graphics.setFont(font)

  world = love.physics.newWorld(0, 0, true)

  timer = 0

  ball = {}
  ball.impulseIntensity = 0
  ball.impulseMax = BALL_IMPULSE_MAX

  ball.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4, "dynamic")
  ball.shape = love.physics.newCircleShape(BALL_RADIUS)
  ball.fixture = love.physics.newFixture(ball.body, ball.shape)
  ball.body:setMass(1)
  ball.fixture:setUserData("Ball")
  ball.fixture:setFriction(1)
  ball.fixture:setRestitution(0.5)

  pins = {}
  pinsCounter = 0

  addPins()
end

function addPins()
  rows = {4, 3, 2, 1}

  local y = PIN_RADIUS * 2 + 16
  local gapX = PIN_RADIUS * 3
  local gapY = PIN_RADIUS * 2.5

  for i, row in ipairs(rows) do
    local x = WINDOW_WIDTH / 2 - (gapX * (row - 1)) / 2
    for pin = 1, row do
      local body = love.physics.newBody(world, x, y, "dynamic")
      local shape = love.physics.newCircleShape(PIN_RADIUS)
      local fixture = love.physics.newFixture(body, shape)
      body:setMass(0.5)
      fixture:setUserData("Pin")
      fixture:setRestitution(0.75)

      table.insert(
        pins,
        {
          ["body"] = body,
          ["shape"] = shape,
          ["fixture"] = fixture
        }
      )
      x = x + gapX
    end
    y = y + gapY
  end
end

function launch()
  local impulse = ball.impulseIntensity * ball.impulseMax
  ball.body:applyLinearImpulse(0, -impulse)
  ball.impulseIntensity = 0
end

function reset()
  gameover = false
  timer = 0
  pinsCounter = 0

  ball.body:setLinearVelocity(0, 0)
  ball.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4)

  addPins()
end

function love.mousereleased()
  launch()
end

function love.keyreleased(key)
  if key == "space" then
    launch()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  if love.mouse.isDown(1) or love.keyboard.isDown("space") then
    ball.impulseIntensity = ball.impulseIntensity + dt * 0.5
  end

  for i, pin in ipairs(pins) do
    local x, y = pin.body:getPosition()
    if x > WINDOW_WIDTH + PIN_RADIUS or x < -PIN_RADIUS or y > WINDOW_HEIGHT + PIN_RADIUS or y < -PIN_RADIUS then
      pinsCounter = pinsCounter + 1
      pin.body:destroy()
      table.remove(pins, i)

      if #pins == 0 then
        gameover = true
      end
    end
  end

  if gameover then
    timer = timer + dt
    if timer >= TIMER_DELAY then
      reset()
    end
  end

  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)

  love.graphics.printf(pinsCounter, 0, WINDOW_HEIGHT * 3 / 4 - 12, WINDOW_WIDTH, "center")

  love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())

  for i, pin in ipairs(pins) do
    love.graphics.circle("fill", pin.body:getX(), pin.body:getY(), pin.shape:getRadius())
  end

  love.graphics.setColor(0.18, 0.82, 0.24)
  love.graphics.rectangle("fill", 0, WINDOW_HEIGHT - 8, WINDOW_WIDTH * ball.impulseIntensity, 8)
end
