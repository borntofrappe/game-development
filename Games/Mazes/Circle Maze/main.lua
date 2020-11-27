require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 10
RINGS = 10
RINGS_COUNT = 10

function love.load()
  love.window.setTitle("Circle Maze")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()
  stack = {grid.cells[1][1]}
  player = grid.cells[1][1]
  recursiveBacktracker()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "up" then
    if not grid.cells[player.ring][player.ringCount].gates.up and player.ring < grid.rings then
      player = grid.cells[player.ring + 1][player.ringCount]
    end
  elseif key == "right" then
    if not grid.cells[player.ring][player.ringCount].gates.right then
      local ringCount = player.ringCount + 1
      if ringCount == #grid.cells[player.ring] + 1 then
        ringCount = 1
      end

      player = grid.cells[player.ring][ringCount]
    end
  elseif key == "down" then
    if not grid.cells[player.ring][player.ringCount].gates.down and player.ring > 1 then
      player = grid.cells[player.ring - 1][player.ringCount]
    end
  elseif key == "left" then
    if not grid.cells[player.ring][player.ringCount].gates.left then
      local ringCount = player.ringCount - 1
      if ringCount == 0 then
        ringCount = #grid.cells[player.ring]
      end
      player = grid.cells[player.ring][ringCount]
    end
  end
end

function love.draw()
  love.graphics.translate(math.floor(WINDOW_WIDTH / 2), math.floor(WINDOW_HEIGHT / 2))

  grid:render()

  love.graphics.setColor(0, 1, 0, 0.5)
  love.graphics.arc("line", "open", 0, 0, player.outerRadius, player.angleStart, player.angleEnd)
  love.graphics.line(player.x1, player.y1, player.x2, player.y2)
  love.graphics.arc("line", "open", 0, 0, player.innerRadius, player.angleStart, player.angleEnd)
  love.graphics.line(player.x3, player.y3, player.x4, player.y4)
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

    for i = #connections, 1, -1 do
      local ring = cell.ring + connections[i].dr
      if not grid.cells[ring] then
        table.remove(connections, i)
      end
    end

    local connection = connections[love.math.random(#connections)]
    local ring = cell.ring + connection.dr
    local ringCount = cell.ringCount + connection.dc

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
      recursiveBacktracker()
    end
  end
end
