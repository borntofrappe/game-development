require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Algorithms — Sidewinder")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  grid = Grid:new()
  grid:sidewinder()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    grid = Grid:new()
    grid:sidewinder()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    grid = Grid:new()
    grid:sidewinder()
  end
end

function love.draw()
  love.graphics.translate(PADDING, PADDING)
  grid:render()
end
