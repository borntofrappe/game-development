require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 10
RINGS = 8
RINGS_COUNT = 6

function love.load()
  love.window.setTitle("Polar Maze")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()
  stack = {grid.cells[1][1]}

  recursiveBacktracker()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.translate(math.floor(WINDOW_WIDTH / 2), math.floor(WINDOW_HEIGHT / 2))
  grid:render()
end

function recursiveBacktracker()
  if #stack > 0 then
    local cell = stack[#stack]

    local connections = {
      {
        ["gates"] = {"up", "down"},
        ["dr"] = 1,
        ["dc"] = 0
      },
      {
        ["gates"] = {"right", "left"},
        ["dr"] = 0,
        ["dc"] = 1
      },
      {
        ["gates"] = {"down", "up"},
        ["dr"] = -1,
        ["dc"] = 0
      },
      {
        ["gates"] = {"left", "right"},
        ["dr"] = 0,
        ["dc"] = -1
      }
    }

    if cell.ring % 2 ~= 0 then
      table.insert(
        connections,
        {
          ["gates"] = {"up", "down"},
          ["dr"] = 1,
          ["dc"] = -1
        }
      )
    end

    for i = #connections, 1, -1 do
      local ring = cell.ring + connections[i].dr
      if not grid.cells[ring] then
        table.remove(connections, i)
      end
    end

    local connection = connections[love.math.random(#connections)]
    local ring = cell.ring + connection.dr
    local ringCount = cell.ringCount + connection.dc

    if cell.ring % 2 ~= 0 and connection.dr == 1 then
      ringCount = cell.ringCount * 2 + connection.dc
    end

    if cell.ring % 2 == 0 and connection.dr == -1 then
      ringCount = math.ceil(cell.ringCount / 2) + connection.dc
    end

    if ringCount < 1 then
      ringCount = #grid.cells[ring]
    elseif ringCount > #grid.cells[ring] then
      ringCount = 1
    end

    local neighboringCell = grid.cells[ring][ringCount]

    if not neighboringCell.visited then
      cell.gates[connection.gates[1]] = false
      neighboringCell.gates[connection.gates[2]] = false
      neighboringCell.visited = true

      table.insert(stack, neighboringCell)
      recursiveBacktracker()
    else
      while #stack > 0 do
        local cell = table.remove(stack)
        local connections = {
          {
            ["gates"] = {"up", "down"},
            ["dr"] = 1,
            ["dc"] = 0
          },
          {
            ["gates"] = {"right", "left"},
            ["dr"] = 0,
            ["dc"] = 1
          },
          {
            ["gates"] = {"down", "up"},
            ["dr"] = -1,
            ["dc"] = 0
          },
          {
            ["gates"] = {"left", "right"},
            ["dr"] = 0,
            ["dc"] = -1
          }
        }

        if cell.ring % 2 ~= 0 then
          table.insert(
            connections,
            {
              ["gates"] = {"up", "down"},
              ["dr"] = 1,
              ["dc"] = 1
            }
          )
        end

        for i = #connections, 1, -1 do
          local ring = (cell.ring + connections[i].dr)
          if not grid.cells[ring] then
            table.remove(connections, i)
          end
        end

        local possibleNeighbors = {}
        local possibleGates = {}
        for i, connection in ipairs(connections) do
          local ring = cell.ring + connection.dr
          local ringCount = cell.ringCount + connection.dc

          if cell.ring % 2 ~= 0 and connection.dr == 1 then
            ringCount = cell.ringCount * 2 + connection.dc
          end

          if cell.ring % 2 == 0 and connection.dr == -1 then
            ringCount = math.ceil(cell.ringCount / 2) + connection.dc
          end

          if ringCount < 1 then
            ringCount = #grid.cells[ring]
          elseif ringCount > #grid.cells[ring] then
            ringCount = 1
          end

          local neighboringCell = grid.cells[ring][ringCount]
          if not neighboringCell.visited then
            table.insert(possibleNeighbors, neighboringCell)
            table.insert(possibleGates, connection.gates)
          end
        end

        if #possibleNeighbors > 0 then
          local index = love.math.random(#possibleNeighbors)
          local neighboringCell = possibleNeighbors[index]
          local gates = possibleGates[index]

          cell.gates[gates[1]] = false
          neighboringCell.gates[gates[2]] = false
          neighboringCell.visited = true

          table.insert(stack, cell)
          table.insert(stack, neighboringCell)
          break
        end
      end
    end
    recursiveBacktracker()
  end
end
