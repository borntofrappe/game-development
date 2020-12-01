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

  for row = 1, rows do
    cells[row] = {}
    for column = 1, columns do
      cells[row][column] = Cell:new(column, row, cellWidth, cellHeight)
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

  for row = 1, self.rows do
    for column = 1, self.columns do
      self.cells[column][row]:render()
    end
  end
end

--[[ sidewinder algorithm
  - visit every cell, traversing each row left to right

  - pick a gate 
    east 
      OR
    north of one of the visited, available cells in the current row

  - do not create any exit
]]
function Grid:sidewinder()
  for row = self.rows, 1, -1 do
    local visited = {}
    for column = 1, self.columns do
      visited[#visited + 1] = column

      local openEast = love.math.random(2) == 1
      if openEast then
        if column < self.columns then
          self.cells[row][column].gates.right = nil
          self.cells[row][column + 1].gates.left = nil
        else
          if row > 1 then
            local index = love.math.random(#visited)
            self.cells[row - 1][visited[index]].gates.down = nil
            self.cells[row][visited[index]].gates.up = nil
            visited = {}
          end
        end
      else
        if row > 1 then
          local index = love.math.random(#visited)
          self.cells[row - 1][visited[index]].gates.down = nil
          self.cells[row][visited[index]].gates.up = nil
          visited = {}
        else
          if column < self.columns then
            self.cells[row][column].gates.right = nil
            self.cells[row][column + 1].gates.left = nil
          end
        end
      end
    end
  end
end
