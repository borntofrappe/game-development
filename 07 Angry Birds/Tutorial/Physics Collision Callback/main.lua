WINDOW_WIDTH = 720
WINDOW_HEIGHT = 560

function love.load()
  love.window.setTitle("Physics")

  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81 * 64, true)
  objects = {}

  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT - 100 / 2)
  objects.ground.shape = love.physics.newRectangleShape(WINDOW_WIDTH, 100)
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  objects.ball.shape = love.physics.newCircleShape(20)
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
  objects.ball.fixture:setRestitution(0.95)
  objects.ball.fixture:setUserData("ball")

  objects.block = {}
  objects.block.body = love.physics.newBody(world, WINDOW_WIDTH / 4, WINDOW_HEIGHT / 2, "dynamic")
  objects.block.shape = love.physics.newRectangleShape(40, 160)
  objects.block.fixture = love.physics.newFixture(objects.block.body, objects.block.shape)
  objects.block.fixture:setUserData("block")

  love.graphics.setBackgroundColor(0.15, 0.15, 0.15)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  contactPoints = {}
  contactCounter = 0
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    objects.ball.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    objects.block.body:setPosition(WINDOW_WIDTH / 4, WINDOW_HEIGHT / 2)
    objects.ball.body:setLinearVelocity(0, 0)
    objects.block.body:setLinearVelocity(0, 0)
  end
end

function love.update(dt)
  world:update(dt)
  world:setCallbacks(beginContact, endContact)

  if love.keyboard.isDown("left") then
    objects.ball.body:applyForce(-150, 0)
  elseif love.keyboard.isDown("right") then
    objects.ball.body:applyForce(150, 0)
  elseif love.keyboard.isDown("up") then
    objects.ball.body:applyForce(0, -300)
  end
end

function beginContact(f1, f2, contact)
  if
    (f1:getUserData() == "ball" or f1:getUserData() == "block") and
      (f2:getUserData() == "ball" or f2:getUserData() == "block")
   then
    contactCounter = contactCounter + 1
    local x, y = contact:getPositions()
    table.insert(
      contactPoints,
      {
        x = x,
        y = y
      }
    )
  end
end

function love.draw()
  love.graphics.setColor(0.5, 0.15, 0.08)
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

  love.graphics.setColor(0.75, 0.35, 0.12)
  love.graphics.polygon("fill", objects.block.body:getWorldPoints(objects.block.shape:getPoints()))

  love.graphics.setColor(0.9, 0.2, 0)
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

  love.graphics.setColor(0.1, 1, 0.1)
  love.graphics.print("Contact counter: " .. contactCounter, 8, 8)

  love.graphics.print("Contact points", 8, 24)
  for i, v in ipairs(contactPoints) do
    love.graphics.print("(" .. v.x .. ", " .. v.y .. ")", 8, 40 + 16 * (i - 1))
  end
end
