require "Grid"
require "Cell"
Timer = require "Timer"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Hunt and Kill")
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

  huntAndKill(highlight.column, highlight.row)
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

function love.update(dt)
  Timer:update(dt)
end

--[[ Hunt and Kill algorithm
  

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
    highlight = {
      ["column"] = neighboringCell.column,
      ["row"] = neighboringCell.row
    }

    if not neighboringCell.visited then
      cell.gates[connection.gates[1]] = nil
      neighboringCell.gates[connection.gates[2]] = nil
      neighboringCell.visited = true

      Timer:after(
        0.2,
        function()
          huntAndKill(neighboringCell.column, neighboringCell.row)
        end
      )
    else
      local cell, neighboringCell, gates
      -- hunt once
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
      highlight = {
        ["column"] = cell.column,
        ["row"] = cell.row
      }

      Timer:after(
        0.2,
        function()
          huntAndKill(cell.column, cell.row)
        end
      )
    end
  else
    highlight = nil
  end
end
