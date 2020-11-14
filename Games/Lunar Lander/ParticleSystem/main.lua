WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

function love.load()
  love.window.setTitle("ParticleSystem")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)
end

function love.mousepressed(x, y, button)
  -- show particles in the x, y coordinates
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  -- update particle system
end

function love.draw()
  -- draw particles
end
