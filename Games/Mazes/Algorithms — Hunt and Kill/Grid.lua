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

function Grid:huntAndKill()
  local randomColumn = love.math.random(self.columns)
  local randomRow = love.math.random(self.rows)

  local cell = self.cells[randomColumn][randomRow]
  cell.visited = true

  while true do
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
        cell.column + connections[i].dc < 1 or cell.column + connections[i].dc > self.columns or
          cell.row + connections[i].dr < 1 or
          cell.row + connections[i].dr > self.rows
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

      cell = neighboringCell
    else
      for row = 1, self.rows do
        for column = 1, self.columns do
          local candidate = self.cells[column][row]
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
              if candidateNeighbor.visited then
                table.insert(candidateNeighbors, candidateNeighbor)
                table.insert(candidateConnections, candidateConnection)
              end
            end
            if #candidateNeighbors > 0 then
              local index = love.math.random(#candidateNeighbors)
              local neighboringCell = candidateNeighbors[index]
              local connection = candidateConnections[index]

              cell = candidate
              cell.gates[connection.gates[1]] = nil
              neighboringCell.gates[connection.gates[2]] = nil
              cell.visited = true
              goto continue
            end
          end
        end
      end
      ::continue::
    end

    local allVisited = true
    for column = 1, self.columns do
      if allVisited then
        for row = 1, self.rows do
          if not self.cells[column][row].visited then
            allVisited = false
            break
          end
        end
      else
        break
      end
    end

    if allVisited then
      break
    end
  end
end
