WINDOW_WIDTH = 580
WINDOW_HEIGHT = 460

function love.load()
  love.window.setTitle("Angry Birds")

  world = love.physics.newWorld(0, 300)

  boxBody = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT - 10 - 20, "dynamic")
  boxShape = love.physics.newRectangleShape(20, 20)
  boxFixture = love.physics.newFixture(boxBody, boxShape)
  boxFixture:setRestitution(0.5)

  groundBody = love.physics.newBody(world, 0, WINDOW_HEIGHT - 5, "static")
  groundShape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  groundFixture = love.physics.newFixture(groundBody, groundShape)

  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}

  love.graphics.setBackgroundColor(0.08, 0.08, 0.08)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    boxBody:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    boxBody:setLinearVelocity(0, 0)
    boxBody:setAngle(0)
    boxBody:setAngularVelocity(0)
  end
end

function love.mousepressed(x, y, button)
  love.mouse.buttonPressed[button] = true
end

function love.mousereleased(x, y, button)
  love.mouse.buttonReleased[button] = true
end

function love.mouse.wasPressed(key)
  return love.mouse.buttonPressed[key]
end

function love.mouse.wasReleased(key)
  return love.mouse.buttonReleased[key]
end

function love.update(dt)
  world:update(dt)

  if love.mouse.wasPressed(1) then
    boxBody:setLinearVelocity(0, -200)
    world:setGravity(0, 0)
  end
  if love.mouse.wasReleased(1) then
    boxBody:setLinearVelocity(0, 0)
    world:setGravity(0, 300)
  end

  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", boxBody:getWorldPoints(boxShape:getPoints()))

  love.graphics.setColor(0.9, 0.1, 0.5)
  love.graphics.setLineWidth(10)
  love.graphics.line(groundBody:getWorldPoints(groundShape:getPoints()))
end
