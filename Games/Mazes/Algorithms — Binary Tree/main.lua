require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Algorithms — Binary Tree")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()

  binaryTree()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.translate(PADDING, PADDING)
  grid:render()
end

--[[ binary tree algorithm
  - visit every cell

  - remove the gate north or east

  - do not create any exit
]]
function binaryTree()
  for column = 1, COLUMNS do
    for row = ROWS, 1, -1 do
      local openEast = love.math.random(2) == 1
      if openEast then
        if column < COLUMNS then
          grid.cells[column][row].gates.right = nil
          grid.cells[column + 1][row].gates.left = nil
        else
          if row > 1 then
            grid.cells[column][row - 1].gates.down = nil
            grid.cells[column][row].gates.up = nil
          end
        end
      else
        if row > 1 then
          grid.cells[column][row - 1].gates.down = nil
          grid.cells[column][row].gates.up = nil
        else
          if column < COLUMNS then
            grid.cells[column][row].gates.right = nil
            grid.cells[column + 1][row].gates.left = nil
          end
        end
      end
    end
  end
end
