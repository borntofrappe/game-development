require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Algorithms — Recursive Backtracker")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()

  local cell = {
    ["column"] = love.math.random(COLUMNS),
    ["row"] = love.math.random(ROWS)
  }

  stack = {grid.cells[cell.column][cell.row]}
  recursiveBacktracker()
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

--[[ Recursive backtracker algorithm

  - pick a cell at random and add it to the stack (above)

  - from the top of the stack, pick a neighbor at random

  - if the neighbor has not already been visited, connect the current cell to said neighbor
  
    - visit the neighbor 
    
    - add the neighbor to the stack

  - if the neighbor has already been visited, backtrack the cells in the stack

    - loop through the stack removing cells one at a time

    - look for unvisited neighbors

    - connect the already visited cell with one of its unvisited neighbors

    - add the neighbor to the stack

  - continue until the stack is empty
]]
function recursiveBacktracker()
  if #stack > 0 then
    local cell = stack[#stack]

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
      table.insert(stack, neighboringCell)

      recursiveBacktracker()
    else
      while #stack > 0 do
        local cell = table.remove(stack)
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

        local possibleNeighbors = {}
        local possibleGates = {}
        for i, connection in ipairs(connections) do
          local neighboringCell = grid.cells[cell.column + connection.dc][cell.row + connection.dr]
          if not neighboringCell.visited then
            table.insert(possibleNeighbors, neighboringCell)
            table.insert(possibleGates, connection.gates)
          end
        end

        if #possibleNeighbors > 0 then
          local index = love.math.random(#possibleNeighbors)
          local neighboringCell = possibleNeighbors[index]
          local gates = possibleGates[index]

          cell.gates[gates[1]] = nil
          neighboringCell.gates[gates[2]] = nil
          neighboringCell.visited = true
          table.insert(stack, cell)
          table.insert(stack, neighboringCell)

          break
        end
      end
      recursiveBacktracker()
    end
  end
end
