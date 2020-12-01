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

--[[ binary tree algorithm
  - visit every cell

  - remove a gate north or east

  - do not create any exit
]]
function Grid:binaryTree()
  for column = 1, self.columns do
    for row = self.rows, 1, -1 do
      local openEast = love.math.random(2) == 1
      if openEast then
        if column < self.columns then
          self.cells[column][row].gates.right = nil
          self.cells[column + 1][row].gates.left = nil
        else
          if row > 1 then
            self.cells[column][row - 1].gates.down = nil
            self.cells[column][row].gates.up = nil
          end
        end
      else
        if row > 1 then
          self.cells[column][row - 1].gates.down = nil
          self.cells[column][row].gates.up = nil
        else
          if column < self.columns then
            self.cells[column][row].gates.right = nil
            self.cells[column + 1][row].gates.left = nil
          end
        end
      end
    end
  end
end
