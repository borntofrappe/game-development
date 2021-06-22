Grid = {}

function Grid:new()
  local x = CELL_SIZE * PADDING_COLUMNS
  local y = 0
  local width = GRID_WIDTH
  local height = GRID_HEIGHT

  local border = {}
  for i = 1, BORDER_COLUMNS do
    for j = 1, math.floor(height / CELL_SIZE) do
      table.insert(border, Brick:new(x + (i - 1) * CELL_SIZE, y + (j - 1) * CELL_SIZE, 8))
      table.insert(border, Brick:new(width + (i - 1) * CELL_SIZE, y + (j - 1) * CELL_SIZE, 8))
    end
  end

  local bricks = {}
  for row = 1, GRID_ROWS do
    bricks[row] = {}
    for column = 1, GRID_COLUMNS do
      if math.random(5) == 1 then
        bricks[row][column] =
          Brick:new(
          (PADDING_COLUMNS + BORDER_COLUMNS) * CELL_SIZE + (column - 1) * CELL_SIZE,
          (row - 1) * CELL_SIZE,
          math.random(7)
        )
      else
        bricks[row][column] = nil
      end
    end
  end

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["border"] = border,
    ["bricks"] = bricks
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Grid:render()
  love.graphics.setColor(gColors[4].r, gColors[4].g, gColors[4].b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  love.graphics.setColor(1, 1, 1)
  for k, row in pairs(self.bricks) do
    for l, brick in pairs(row) do
      brick:render()
    end
  end

  for k, brick in pairs(self.border) do
    brick:render()
  end
end
