require "src/Dependencies"

function love.load()
  love.window.setTitle("Snake")

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.clear(0.035, 0.137, 0.298, 1)
end
