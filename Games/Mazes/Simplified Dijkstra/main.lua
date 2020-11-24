require "Grid"
require "Cell"
Timer = require "Timer"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Simplified Dijkstra")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()

  --[[ sidewinder algorithm ]]
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

  -- selected cell
  cell = {
    ["column"] = 1,
    ["row"] = 1
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "up" then
    if cell.row > 1 then
      cell.row = cell.row - 1
    end
  elseif key == "right" then
    if cell.column < COLUMNS then
      cell.column = cell.column + 1
    end
  elseif key == "down" then
    if cell.row < ROWS then
      cell.row = cell.row + 1
    end
  elseif key == "left" then
    if cell.column > 1 then
      cell.column = cell.column - 1
    end
  end

  if key == "return" then
    for c = 1, COLUMNS do
      for r = 1, ROWS do
        grid.cells[c][r].distance = nil
      end
    end

    Timer:reset()

    dijkstra(grid.cells[cell.column][cell.row], 0)
  end
end

function love.update(dt)
  Timer:update(dt)
end

function love.draw()
  love.graphics.translate(PADDING, PADDING)
  grid:render()

  love.graphics.setColor(1, 1, 1, 0.2)
  love.graphics.rectangle(
    "fill",
    (cell.column - 1) * grid.cellWidth,
    (cell.row - 1) * grid.cellHeight,
    grid.cellWidth,
    grid.cellHeight
  )
end

--[[ Dijkstra algorithm
- mark the current cell with a "distance" value
- call the function for any accessible neighbor and with an incremented "distance" value 
]]
function dijkstra(cell, distance)
  grid.cells[cell.column][cell.row].distance = distance

  local connections = {
    {
      ["gate"] = "up",
      ["dc"] = 0,
      ["dr"] = -1
    },
    {
      ["gate"] = "right",
      ["dc"] = 1,
      ["dr"] = 0
    },
    {
      ["gate"] = "down",
      ["dc"] = 0,
      ["dr"] = 1
    },
    {
      ["gate"] = "left",
      ["dc"] = -1,
      ["dr"] = 0
    }
  }

  for i, connection in ipairs(connections) do
    if
      not grid.cells[cell.column][cell.row].gates[connection.gate] and
        not grid.cells[cell.column + connection.dc][cell.row + connection.dr].distance
     then
      Timer:after(
        0.5,
        function()
          dijkstra(grid.cells[cell.column + connection.dc][cell.row + connection.dr], distance + 1)
        end
      )
    end
  end
end
