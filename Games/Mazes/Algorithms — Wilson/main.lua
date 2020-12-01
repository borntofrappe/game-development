require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Algorithms — Wilson")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()

  unvisited = {}
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      table.insert(
        unvisited,
        {
          ["column"] = column,
          ["row"] = row,
          ["gates"] = {}
        }
      )
    end
  end

  local visitedCell = table.remove(unvisited, love.math.random(#unvisited))
  grid.cells[visitedCell.column][visitedCell.row].visited = true

  wilson()
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

--[[ wilson algorithm
  
  prep:
  - pick a cell at random and mark it as visited (above)

  random walk:
  - pick an unvisited cell, and take note of its position

  - pick a neighbor at random. Note its position while moving to the new cell

  - continue picking neighboring cells until you reach a visited cell

  - when you reach a visited cell, remove the gates of the noted cells in the manner described by the path

  - if the noted cells create a loop, erase said loop. 

  - repeat the random walk until every cell has been visited
]]
function wilson()
  local cell = unvisited[love.math.random(#unvisited)]
  -- cell might hold the value of a gate from a previous iteration
  cell.gates = {}
  local visited = {cell}

  while not grid.cells[cell.column][cell.row].visited do
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

    table.insert(visited[#visited].gates, connection.gates[1])

    local neighboringCell = {
      ["column"] = cell.column + connection.dc,
      ["row"] = cell.row + connection.dr,
      ["gates"] = {connection.gates[2]}
    }

    for i, visitedCell in ipairs(visited) do
      if visitedCell.column == neighboringCell.column and visitedCell.row == neighboringCell.row then
        visited = {}
        neighboringCell.gates = {}
        break
      end
    end

    table.insert(visited, neighboringCell)
    cell = neighboringCell
  end

  for i, visitedCell in ipairs(visited) do
    grid.cells[visitedCell.column][visitedCell.row].visited = true
    for j, gate in ipairs(visitedCell.gates) do
      grid.cells[visitedCell.column][visitedCell.row].gates[gate] = nil
    end

    for j = #unvisited, 1, -1 do
      if unvisited[j].column == visitedCell.column and unvisited[j].row == visitedCell.row then
        table.remove(unvisited, j)
      end
    end
  end

  if #unvisited > 0 then
    wilson()
  end
end
