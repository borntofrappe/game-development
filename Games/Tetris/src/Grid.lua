Grid = {}
Grid.__index = Grid

function Grid:new(def)
  local def =
    def or
    {
      ["columns"] = COLUMNS,
      ["rows"] = ROWS
    }

  local bricks = {}
  for row = 1, def.rows do
    bricks[row] = {}
    for column = 1, def.columns do
      bricks[row][column] = ""
    end
  end

  this = {
    ["columns"] = def.columns,
    ["rows"] = def.rows,
    ["bricks"] = bricks
  }

  setmetatable(this, self)
  return this
end

function Grid:render()
  for row = 1, self.rows do
    for column = 1, self.columns do
      if self.bricks[row][column] ~= "" then
        self.bricks[row][column]:render()
      end
    end
  end
end

function Grid:reset()
  for row = 1, self.rows do
    for column = 1, self.columns do
      self.bricks[row][column] = ""
    end
  end
end
