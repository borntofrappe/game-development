-- good luck
WINDOW_WIDTH = 620
WINDOW_HEIGHT = 480

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
end

function love.draw()
  love.graphics.printf("Good luck", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
