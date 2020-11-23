-- good luck
WINDOW_WIDTH = 520
WINDOW_HEIGHT = 380

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Bang bang")
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.printf("Bang bang\nYou shot me down", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
