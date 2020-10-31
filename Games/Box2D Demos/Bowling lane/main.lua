WINDOW_WIDTH = 340
WINDOW_HEIGHT = 520

function love.load()
  love.window.setTitle("Bowling lane")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  world = love.physics.newWorld(0, 0, true)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  -- world:update(dt)
end

function love.draw()
end
