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

--[[ wilson algorithm
  prep:
  - pick a cell at random and visit it

  random walk:
  - pick an unvisited cell, and take note of its position

  - pick a neighbor at random. Note its position while moving to the new cell

  - continue picking neighboring cells until you reach a visited cell

  - when you reach a visited cell, remove the gates of the noted cells in the manner described by the random walk

  - if the noted cells create a loop, erase said loop

  - repeat the random walk until every cell has been visited
]]
function Grid:wilson()
  local unvisited = {}
  for column = 1, self.columns do
    for row = 1, self.rows do
      table.insert(
        unvisited,
        {
          ["column"] = column,
          ["row"] = row,
          ["gates"] = {}
        }
      )
    end
  end

  local visitedCell = table.remove(unvisited, love.math.random(#unvisited))
  self.cells[visitedCell.column][visitedCell.row].visited = true

  while #unvisited > 0 do
    local cell = unvisited[love.math.random(#unvisited)]
    local walked = {cell}

    while not self.cells[cell.column][cell.row].visited do
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

      table.insert(walked[#walked].gates, connection.gates[1])

      local neighboringCell = {
        ["column"] = cell.column + connection.dc,
        ["row"] = cell.row + connection.dr,
        ["gates"] = {connection.gates[2]}
      }

      for i, walkedCell in ipairs(walked) do
        if walkedCell.column == neighboringCell.column and walkedCell.row == neighboringCell.row then
          walked = {}
          neighboringCell.gates = {}
          break
        end
      end

      table.insert(walked, neighboringCell)
      cell = neighboringCell
    end

    for i, walkedCell in ipairs(walked) do
      self.cells[walkedCell.column][walkedCell.row].visited = true
      for j, gate in ipairs(walkedCell.gates) do
        self.cells[walkedCell.column][walkedCell.row].gates[gate] = nil
      end

      for j = #unvisited, 1, -1 do
        if unvisited[j].column == walkedCell.column and unvisited[j].row == walkedCell.row then
          table.remove(unvisited, j)
        end
      end
    end
  end
end
