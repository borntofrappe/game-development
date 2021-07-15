local WINDOW_WIDTH = 580
local WINDOW_HEIGHT = 460

local world
local box
local ground

function love.load()
  love.window.setTitle("Angry Birds")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.08, 0.08, 0.08)

  world = love.physics.newWorld(0, 300)

  box = {}
  box.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  box.shape = love.physics.newRectangleShape(20, 20)
  box.fixture = love.physics.newFixture(box.body, box.shape)
  box.fixture:setRestitution(0.5)

  ground = {}
  ground.body = love.physics.newBody(world, 0, WINDOW_HEIGHT - 5, "static")
  ground.shape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  ground.fixture = love.physics.newFixture(ground.body, ground.shape)

  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    box.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    box.body:setLinearVelocity(0, 0)
    box.body:setAngle(0)
    box.body:setAngularVelocity(0)
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
    box.body:setLinearVelocity(0, -200)
    world:setGravity(0, 0)
  end
  if love.mouse.wasReleased(1) then
    world:setGravity(0, 300)
  end

  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", box.body:getWorldPoints(box.shape:getPoints()))

  love.graphics.setColor(0.9, 0.1, 0.5)
  love.graphics.setLineWidth(10)
  love.graphics.line(ground.body:getWorldPoints(ground.shape:getPoints()))
end
