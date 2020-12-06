WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440

function love.load()
  love.window.setTitle("Bang bang")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 0.95, 1)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.printf("Good luck", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
