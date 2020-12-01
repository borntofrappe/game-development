require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Algorithms — Aldous Broder")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()

  local cell = {
    ["column"] = love.math.random(COLUMNS),
    ["row"] = love.math.random(ROWS)
  }

  grid.cells[cell.column][cell.row].visited = true
  aldousBroder(cell.column, cell.row)
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

--[[ aldous broder algorithm
  - pick a cell in the grid

  - choose a neighbor at random

  - if not visited, link to it by removing the connecting border

  - if visited, do nothing

  - move to the neighboring cell and repeat from step 2

  - repeat until every cell has been visited
]]
function aldousBroder(column, row)
  local allVisited = true
  for c = 1, COLUMNS do
    if allVisited then
      for r = 1, ROWS do
        if not grid.cells[c][r].visited then
          allVisited = false
          break
        end
      end
    else
      break
    end
  end

  if not allVisited then
    local cell = grid.cells[column][row]

    local connections = {
      {
        ["gates"] = {"up", "down"},
        ["dc"] = 0,
        ["dr"] = -1
      },
      {
        ["gates"] = {"right", "left"},
        ["dc"] = 1,
        ["dr"] = 0
      },
      {
        ["gates"] = {"down", "up"},
        ["dc"] = 0,
        ["dr"] = 1
      },
      {
        ["gates"] = {"left", "right"},
        ["dc"] = -1,
        ["dr"] = 0
      }
    }

    for i = #connections, 1, -1 do
      if
        cell.column + connections[i].dc < 1 or cell.column + connections[i].dc > COLUMNS or
          cell.row + connections[i].dr < 1 or
          cell.row + connections[i].dr > ROWS
       then
        table.remove(connections, i)
      end
    end

    local connection = connections[love.math.random(#connections)]
    local neighboringCell = grid.cells[cell.column + connection.dc][cell.row + connection.dr]

    if not neighboringCell.visited then
      cell.gates[connection.gates[1]] = nil
      neighboringCell.gates[connection.gates[2]] = nil
      neighboringCell.visited = true
    end

    aldousBroder(neighboringCell.column, neighboringCell.row)
  end
end
