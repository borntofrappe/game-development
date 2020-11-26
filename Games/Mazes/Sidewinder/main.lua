require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Sidewinder")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()

  player = {
    ["column"] = love.math.random(COLUMNS),
    ["row"] = love.math.random(ROWS)
  }

  sidewinder()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "up" then
    if not grid.cells[player.column][player.row].gates.up and player.row > 1 then
      player.row = player.row - 1
    end
  elseif key == "right" then
    if not grid.cells[player.column][player.row].gates.right and player.column < COLUMNS then
      player.column = player.column + 1
    end
  elseif key == "down" then
    if not grid.cells[player.column][player.row].gates.down and player.row < ROWS then
      player.row = player.row + 1
    end
  elseif key == "left" then
    if not grid.cells[player.column][player.row].gates.left and player.column > 1 then
      player.column = player.column - 1
    end
  end
end

function love.draw()
  love.graphics.translate(PADDING, PADDING)
  grid:render()

  love.graphics.circle(
    "fill",
    (player.column - 1) * grid.cellWidth + grid.cellWidth / 2,
    (player.row - 1) * grid.cellHeight + grid.cellHeight / 2,
    math.min(grid.cellWidth, grid.cellHeight) / 4
  )
end

--[[ sidewinder algorithm
  - visit every cell, traversing each row left to right

  - pick a gate 
    east 
      OR
    north of one of the visited, available cells in the current row

  - do not create any exit
]]
function sidewinder()
  for row = ROWS, 1, -1 do
    local visited = {}
    for column = 1, COLUMNS do
      visited[#visited + 1] = column

      local openEast = love.math.random(2) == 1
      if openEast then
        if column < COLUMNS then
          grid.cells[column][row].gates.right = nil
          grid.cells[column + 1][row].gates.left = nil
        else
          if row > 1 then
            local index = love.math.random(#visited)
            grid.cells[visited[index]][row - 1].gates.down = nil
            grid.cells[visited[index]][row].gates.up = nil
            visited = {}
          end
        end
      else
        if row > 1 then
          local index = love.math.random(#visited)
          grid.cells[visited[index]][row - 1].gates.down = nil
          grid.cells[visited[index]][row].gates.up = nil
          visited = {}
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
