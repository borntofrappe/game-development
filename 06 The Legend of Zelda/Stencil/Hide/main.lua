-- good luck

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

function love.load()
  love.window.setTitle("Stencil — Hide")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
end
