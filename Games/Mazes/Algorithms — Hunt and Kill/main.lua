require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Algorithms — Hunt and Kill")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()

  local cell = {
    ["column"] = love.math.random(COLUMNS),
    ["row"] = love.math.random(ROWS)
  }

  huntAndKill(cell.column, cell.row)
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

--[[ Hunt and Kill algorithm
  - pick a cell and mark it as visited

  - pick a neighbor at random

  - if the neighbor has not already been visited, connect the two and visit the cell

  - if the neighbor has already been visited, "hunt" for an unvisited cell

    - loop through the grid top to bottom, left to right

    - look for the first unvisited cell with a visited neighbor

    - connect the cell with the neighbor, and visit the same cell

    - resume the random walk picking a neighbor at random
]]
function huntAndKill(column, row)
  grid.cells[column][row].visited = true

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

      huntAndKill(neighboringCell.column, neighboringCell.row)
    else
      local cell, neighboringCell, gates
      for r = 1, ROWS do
        for c = 1, COLUMNS do
          local candidate = grid.cells[c][r]
          if not candidate.visited then
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
                candidate.column + connections[i].dc < 1 or candidate.column + connections[i].dc > COLUMNS or
                  candidate.row + connections[i].dr < 1 or
                  candidate.row + connections[i].dr > ROWS
               then
                table.remove(connections, i)
              end
            end

            local possibleNeighbors = {}
            local possibleGates = {}
            for i, connection in ipairs(connections) do
              local candidateNeighbor = grid.cells[candidate.column + connection.dc][candidate.row + connection.dr]
              if candidateNeighbor.visited then
                table.insert(possibleNeighbors, candidateNeighbor)
                table.insert(possibleGates, connection.gates)
              end
            end
            if #possibleNeighbors > 0 then
              cell = candidate
              local index = love.math.random(#possibleNeighbors)
              neighboringCell = possibleNeighbors[index]
              gates = possibleGates[index]
              goto continue
            end
          end
        end
      end

      ::continue::
      cell.visited = true
      cell.gates[gates[1]] = nil
      neighboringCell.gates[gates[2]] = nil

      huntAndKill(cell.column, cell.row)
    end
  end
end
