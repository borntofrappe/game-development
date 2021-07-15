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
  box.fixture:setRestitution(0.9)

  ground = {}
  ground.body = love.physics.newBody(world, 0, WINDOW_HEIGHT - 5, "static")
  ground.shape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  ground.fixture = love.physics.newFixture(ground.body, ground.shape)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", box.body:getWorldPoints(box.shape:getPoints()))

  love.graphics.setColor(0.9, 0.1, 0.5)
  love.graphics.setLineWidth(10)
  love.graphics.line(ground.body:getWorldPoints(ground.shape:getPoints()))
end
