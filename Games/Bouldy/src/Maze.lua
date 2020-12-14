Maze = {}
Maze.__index = Maze

function Maze:new()
  local maze = Maze:create()
  maze:recursiveBacktracker()
  return maze
end

function Maze:create()
  local size = MAZE_SIZE
  local dimension = MAZE_DIMENSION

  local cellSize = math.floor(size / dimension)

  local grid = {}

  for column = 1, dimension do
    grid[column] = {}
    for row = 1, dimension do
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

      if row < dimension then
        table.insert(
          neighbors,
          {
            ["column"] = column,
            ["row"] = row + 1,
            ["gates"] = {"down", "up"}
          }
        )
      end

      if column < dimension then
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

      grid[column][row] = Cell:new(column, row, neighbors, cellSize)
    end
  end

  this = {
    ["dimension"] = dimension,
    ["cellSize"] = cellSize,
    ["size"] = size,
    ["grid"] = grid
  }

  setmetatable(this, self)

  return this
end

function Maze:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(3)

  for column = 1, self.dimension do
    for row = 1, self.dimension do
      self.grid[column][row]:render()
    end
  end
end

function Maze:recursiveBacktracker()
  local randomColumn = love.math.random(self.dimension)
  local randomRow = love.math.random(self.dimension)
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
