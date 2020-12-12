Maze = {}
Maze.__index = Maze

function Maze:new(width, height)
  local maze = Maze:create(width, height)
  maze:recursiveBacktracker()
  return maze
end

function Maze:create(width, height)
  local columns = COLUMNS
  local rows = ROWS

  local cellWidth = math.floor(width / columns)
  local cellHeight = math.floor(height / rows)

  local grid = {}

  for column = 1, columns do
    grid[column] = {}
    for row = 1, rows do
      local neighbors = {}
      if row > 1 then
        table.insert(
          neighbors,
          {
            ["column"] = column,
            ["row"] = row - 1,
            ["gates"] = {"up", "down"}
          }
        )
      end

      if row < rows then
        table.insert(
          neighbors,
          {
            ["column"] = column,
            ["row"] = row + 1,
            ["gates"] = {"down", "up"}
          }
        )
      end

      if column < columns then
        table.insert(
          neighbors,
          {
            ["column"] = column + 1,
            ["row"] = row,
            ["gates"] = {"right", "left"}
          }
        )
      end

      if column > 1 then
        table.insert(
          neighbors,
          {
            ["column"] = column - 1,
            ["row"] = row,
            ["gates"] = {"left", "right"}
          }
        )
      end

      grid[column][row] = Cell:new(column, row, neighbors, cellWidth, cellHeight)
    end
  end

  this = {
    ["columns"] = columns,
    ["rows"] = rows,
    ["width"] = width,
    ["height"] = height,
    ["grid"] = grid
  }

  setmetatable(this, self)

  return this
end

function Maze:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(3)

  for column = 1, self.columns do
    for row = 1, self.rows do
      self.grid[column][row]:render()
    end
  end
end

function Maze:recursiveBacktracker()
  local randomColumn = love.math.random(self.columns)
  local randomRow = love.math.random(self.rows)
  local randomCell = self.grid[randomColumn][randomRow]
  randomCell.visited = true

  local stack = {randomCell}

  while #stack > 0 do
    local cell = stack[#stack]
    local connection = cell.neighbors[love.math.random(#cell.neighbors)]
    local neighboringCell = self.grid[connection.column][connection.row]

    if not neighboringCell.visited then
      neighboringCell.gates[connection.gates[2]] = nil
      cell.gates[connection.gates[1]] = nil
      neighboringCell.visited = true
      table.insert(stack, neighboringCell)
    else
      while #stack > 0 do
        local candidate = table.remove(stack)
        local connections = candidate.neighbors
        local candidateConnections = {}
        for i, candidateConnection in ipairs(connections) do
          if not self.grid[candidateConnection.column][candidateConnection.row].visited then
            table.insert(candidateConnections, candidateConnection)
          end
        end

        if #candidateConnections > 0 then
          local candidateConnection = candidateConnections[love.math.random(#candidateConnections)]
          local candidateNeighbor = self.grid[candidateConnection.column][candidateConnection.row]

          candidate.gates[candidateConnection.gates[1]] = nil
          candidateNeighbor.gates[candidateConnection.gates[2]] = nil
          candidateNeighbor.visited = true
          table.insert(stack, candidate)
          table.insert(stack, candidateNeighbor)
        end
      end
    end
  end
end
