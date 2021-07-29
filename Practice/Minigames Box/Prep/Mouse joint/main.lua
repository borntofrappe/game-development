WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500
SIZE = 50
METER = 50

function love.load()
  love.window.setTitle("Mouse joint")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 9.81 * METER, true)
  object = {}

  object.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  object.shape = love.physics.newRectangleShape(SIZE, SIZE)
  object.fixture = love.physics.newFixture(object.body, object.shape)

  frame = {}
  frame.body = love.physics.newBody(world, 0, 0)
  frame.shape =
    love.physics.newChainShape(false, 0, 0, 0, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, 0, 0, 0)
  frame.fixture = love.physics.newFixture(frame.body, frame.shape)

  mouseJoint = nil
end

function love.mousepressed(x, y)
  mouseJoint = love.physics.newMouseJoint(object.body, x, y)
end

function love.mousereleased()
  mouseJoint:destroy()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  if love.mouse.isDown(1) then
    mouseJoint:setTarget(love.mouse.getPosition())
  end
  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))

  if mouseJoint and not mouseJoint:isDestroyed() then
    local x1 = object.body:getX()
    local y1 = object.body:getY()

    local x2, y2 = mouseJoint:getAnchors()
    love.graphics.line(x1, y1, x2, y2)
  end
end
