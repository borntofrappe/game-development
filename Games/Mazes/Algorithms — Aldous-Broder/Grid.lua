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

--[[ aldous broder algorithm
  - visit a cell at random

  - choose a neighbor at random

    - if not visited, visit and remove the connecting border

    - if visited, do nothing

  - move to the neighboring cell and repeat from step 2

  - repeat until every cell has been visited
]]
function Grid:aldousBroder()
  local randomColumn = love.math.random(self.columns)
  local randomRow = love.math.random(self.rows)

  local cell = self.cells[randomColumn][randomRow]
  cell.visited = true

  -- ! remember to exit the loop with a break statement
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
    else
      cell = neighboringCell
    end
  end
end
