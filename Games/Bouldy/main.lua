require "src/Dependencies"

function love.load()
  love.window.setTitle("Maze")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  maze = Maze:create()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    maze = Maze:create()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    maze = Maze:create()
  end
end

function love.draw()
  maze:render()
end
