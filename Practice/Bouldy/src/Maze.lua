Maze = {}

local COLUMNS = MAZE_DIMENSION
local ROWS = MAZE_DIMENSION

local ACCELERATION_DIRECTION = {
  ["up"] = {-150, -50, 150, -250},
  ["right"] = {50, -150, 250, 150},
  ["down"] = {-150, 50, 150, 250},
  ["left"] = {-50, -150, -250, 150}
}

function Maze:newGrid()
  local grid = {}

  for column = 1, COLUMNS do
    grid[column] = {}
    for row = 1, ROWS do
      local neighbors = {}
      if row > 1 then
        table.insert(neighbors, Neighbor:new(column, row - 1, {"up", "down"}))
      end
      if row < ROWS then
        table.insert(neighbors, Neighbor:new(column, row + 1, {"down", "up"}))
      end

      if column > 1 then
        table.insert(neighbors, Neighbor:new(column - 1, row, {"left", "right"}))
      end
      if column < COLUMNS then
        table.insert(neighbors, Neighbor:new(column + 1, row, {"right", "left"}))
      end

      grid[column][row] = Cell:new(column, row, neighbors)
    end
  end

  local randomColumn = math.random(COLUMNS)
  local randomRow = math.random(ROWS)
  local randomCell = grid[randomColumn][randomRow]
  randomCell.visited = true

  local stack = {randomCell}
  while #stack > 0 do
    local cell = stack[#stack]
    local neighbor = cell.neighbors[math.random(#cell.neighbors)]
    local neighboringCell = grid[neighbor.column][neighbor.row]

    if neighboringCell.visited then
      while #stack > 0 do
        local stackCell = table.remove(stack)
        local connections = {}
        for k, connection in pairs(stackCell.neighbors) do
          if not grid[connection.column][connection.row].visited then
            table.insert(connections, connection)
          end
        end

        if #connections >= 1 then
          local connection = connections[math.random(#connections)]
          local neighboringCell = grid[connection.column][connection.row]

          stackCell.gates[connection.gates[1]] = nil
          neighboringCell.gates[connection.gates[2]] = nil

          neighboringCell.visited = true

          table.insert(stack, stackCell)
          table.insert(stack, neighboringCell)
        end
      end
    else
      cell.gates[neighbor.gates[1]] = nil
      neighboringCell.gates[neighbor.gates[2]] = nil
      neighboringCell.visited = true
      table.insert(stack, neighboringCell)
    end
  end

  return grid
end

local debris = Debris:new()

function Maze:new()
  local this = {
    ["grid"] = self:newGrid(),
    ["columns"] = COLUMNS,
    ["rows"] = ROWS,
    ["debris"] = debris
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Maze:animateDestruction(x, y, direction)
  local acceleration = direction and ACCELERATION_DIRECTION[direction] or {-80, -80, 80, 80}
  self.debris:emit(x, y, acceleration)
end

function Maze:update(dt)
  self.debris:update(dt)
end

function Maze:render()
  love.graphics.setColor(1, 1, 1)
  self.debris:render()

  love.graphics.setColor(COLORS.maze.r, COLORS.maze.g, COLORS.maze.b)
  for k, column in pairs(self.grid) do
    for j, cell in pairs(column) do
      cell:render()
    end
  end
end
