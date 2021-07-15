local WINDOW_WIDTH = 580
local WINDOW_HEIGHT = 460

local world
local body, shape, fixture

function love.load()
  love.window.setTitle("Angry Birds")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.08, 0.08, 0.08)

  world = love.physics.newWorld(0, 300)

  body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  shape = love.physics.newRectangleShape(20, 20)
  fixture = love.physics.newFixture(body, shape)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
end
