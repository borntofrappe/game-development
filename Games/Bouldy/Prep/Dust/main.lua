WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400

function love.load()
  love.window.setTitle("Particle System — Dust")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
end
