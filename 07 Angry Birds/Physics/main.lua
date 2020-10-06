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

  objects.block1 = {}
  objects.block1.body = love.physics.newBody(world, WINDOW_WIDTH / 4, WINDOW_HEIGHT / 2, "dynamic")
  objects.block1.shape = love.physics.newRectangleShape(20, 160)
  objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 0.25)

  objects.block2 = {}
  objects.block2.body = love.physics.newBody(world, WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT / 2, "dynamic")
  objects.block2.shape = love.physics.newRectangleShape(20, 160)
  objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape)

  love.graphics.setBackgroundColor(0.15, 0.15, 0.15)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    objects.ball.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    objects.block1.body:setPosition(WINDOW_WIDTH / 4, WINDOW_HEIGHT / 2)
    objects.block2.body:setPosition(WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT / 2)
    objects.ball.body:setLinearVelocity(0, 0)
    objects.block1.body:setLinearVelocity(0, 0)
    objects.block2.body:setLinearVelocity(0, 0)
  end
end

function love.update(dt)
  world:update(dt)
  if love.keyboard.isDown("left") then
    objects.ball.body:applyForce(-150, 0)
  elseif love.keyboard.isDown("right") then
    objects.ball.body:applyForce(150, 0)
  elseif love.keyboard.isDown("up") then
    objects.ball.body:applyForce(0, -300)
  end
end

function love.draw()
  love.graphics.setColor(0.5, 0.15, 0.08)
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

  love.graphics.setColor(0.75, 0.35, 0.12)
  love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
  love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))

  love.graphics.setColor(0.9, 0.2, 0)
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
end
