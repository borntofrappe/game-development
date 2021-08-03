WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

local world
local lander
local walls

function love.load()
  love.window.setTitle("Box2D Module")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  world = love.physics.newWorld(0, 400)

  lander = {}
  lander.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  lander.shape = love.physics.newCircleShape(10)
  lander.fixture = love.physics.newFixture(lander.body, lander.shape)
  lander.fixture:setRestitution(0.6)

  walls = {}
  walls.body = love.physics.newBody(world, 0, 0)
  walls.shape = love.physics.newChainShape(true, 0, 0, WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0, WINDOW_HEIGHT)
  walls.fixture = love.physics.newFixture(walls.body, walls.shape)
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
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setLineWidth(2)
  love.graphics.line(walls.body:getWorldPoints(walls.shape:getPoints()))

  love.graphics.circle("fill", lander.body:getX(), lander.body:getY(), lander.shape:getRadius())
end
