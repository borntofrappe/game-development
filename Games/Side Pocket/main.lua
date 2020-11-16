require "src/Dependencies"

function love.load()
  love.window.setTitle("Side Pocket")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.95, 0.95, 0.95)

  launcher = Launcher:new()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
end

function love.draw()
  launcher:render()
end
