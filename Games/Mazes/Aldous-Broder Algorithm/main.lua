require "Grid"
require "Cell"
Timer = require "Timer"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Aldous Broder")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()

  highlight = {
    ["column"] = love.math.random(COLUMNS),
    ["row"] = love.math.random(ROWS)
  }

  player = {
    ["column"] = highlight.column,
    ["row"] = highlight.row
  }

  aldousBroder(highlight.column, highlight.row)
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

function love.update(dt)
  Timer:update(dt)
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

  if highlight then
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle(
      "fill",
      (highlight.column - 1) * grid.cellWidth,
      (highlight.row - 1) * grid.cellHeight,
      grid.cellWidth,
      grid.cellHeight
    )
  end
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
    if not cell.visited then
      cell.visited = true
    end

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
    highlight = {
      ["column"] = neighboringCell.column,
      ["row"] = neighboringCell.row
    }

    if not neighboringCell.visited then
      cell.gates[connection.gates[1]] = nil
      neighboringCell.gates[connection.gates[2]] = nil
    end
    Timer:after(
      0.1,
      function()
        aldousBroder(neighboringCell.column, neighboringCell.row)
      end
    )
  else
    highlight = nil
  end
end
