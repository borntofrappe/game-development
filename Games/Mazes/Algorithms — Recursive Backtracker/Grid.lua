Grid = {}
Grid.__index = Grid

function Grid:new()
  local columns = COLUMNS
  local rows = ROWS
  local width = WINDOW_WIDTH - PADDING * 2
  local height = WINDOW_HEIGHT - PADDING * 2

  local cellWidth = math.floor(width / columns)
  local cellHeight = math.floor(height / rows)

  local cells = {}

  for column = 1, columns do
    cells[column] = {}
    for row = 1, rows do
      cells[column][row] = Cell:new(column, row, cellWidth, cellHeight)
    end
  end

  this = {
    ["columns"] = columns,
    ["rows"] = rows,
    ["width"] = width,
    ["height"] = height,
    ["cells"] = cells
  }

  setmetatable(this, self)
  return this
end

function Grid:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(4)

  for column = 1, self.columns do
    for row = 1, self.rows do
      self.cells[column][row]:render()
    end
  end
end

function Grid:recursiveBacktracker()
  local stack = {}

  local randomColumn = love.math.random(self.columns)
  local randomRow = love.math.random(self.rows)
  local randomCell = self.cells[randomColumn][randomRow]

  randomCell.visited = true
  stack = {randomCell}

  while #stack > 0 do
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
    local neighboringCell = self.cells[cell.column + connection.dc][cell.row + connection.dr]

    if not neighboringCell.visited then
      cell.gates[connection.gates[1]] = nil
      neighboringCell.gates[connection.gates[2]] = nil
      neighboringCell.visited = true
      table.insert(stack, neighboringCell)
    else
      while #stack > 0 do
        local candidate = table.remove(stack)
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
            candidate.column + connections[i].dc < 1 or candidate.column + connections[i].dc > self.columns or
              candidate.row + connections[i].dr < 1 or
              candidate.row + connections[i].dr > self.rows
           then
            table.remove(connections, i)
          end
        end

        local candidateNeighbors = {}
        local candidateConnections = {}
        for i, candidateConnection in ipairs(connections) do
          local candidateNeighbor =
            self.cells[candidate.column + candidateConnection.dc][candidate.row + candidateConnection.dr]
          if not candidateNeighbor.visited then
            table.insert(candidateNeighbors, candidateNeighbor)
            table.insert(candidateConnections, candidateConnection)
          end
        end

        if #candidateNeighbors > 0 then
          local index = love.math.random(#candidateNeighbors)
          local candidateNeighbor = candidateNeighbors[index]
          local candidateConnection = candidateConnections[index]

          candidate.gates[candidateConnection.gates[1]] = nil
          candidateNeighbor.gates[candidateConnection.gates[2]] = nil
          candidateNeighbor.visited = true
          table.insert(stack, candidate)
          table.insert(stack, candidateNeighbor)
          break
        end
      end
    end
  end
end
