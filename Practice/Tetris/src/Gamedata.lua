Gamedata = {}

function Gamedata:new()
  local level = 1
  local score = 0
  local lines = 0

  local columnStart = 0
  local rowStart = ROWS_WHITESPACE
  local columns = COLUMNS_GAMEDATA
  local rowsData = math.floor(ROWS_DATA / 3)
  local rowsGap = (ROWS_DATA - rowsData * 3) / 3

  local boxes = {}
  for i = 1, 3 do
    local box = Box:new(columnStart, rowStart * CELL_SIZE, columns * CELL_SIZE, rowsData * CELL_SIZE)

    rowStart = rowStart + rowsData + rowsGap
    table.insert(boxes, box)
  end

  local box =
    Box:new(0, (ROWS_WHITESPACE * 2 + ROWS_DATA) * CELL_SIZE, columns * CELL_SIZE, ROWS_NEXT_TETROMINO * CELL_SIZE)
  table.insert(boxes, box)

  local tetrominoCoords = {
    ["column"] = COLUMNS_GAMEDATA / 2,
    ["row"] = ROWS_WHITESPACE * 2 + ROWS_DATA + ROWS_NEXT_TETROMINO / 2
  }

  local tetromino =
    Tetromino:new(
    {
      ["column"] = tetrominoCoords.column,
      ["row"] = tetrominoCoords.row,
      ["isCentered"] = true
    }
  )

  local this = {
    ["boxes"] = boxes,
    ["level"] = level,
    ["score"] = score,
    ["lines"] = lines,
    ["textPadding"] = {
      ["x"] = 5,
      ["y"] = 4
    },
    ["tetromino"] = tetromino,
    ["tetrominoCoords"] = tetrominoCoords
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Gamedata:setNewTetromino()
  self.tetromino =
    Tetromino:new(
    {
      ["column"] = self.tetrominoCoords.column,
      ["row"] = self.tetrominoCoords.row,
      ["isCentered"] = true
    }
  )
end

function Gamedata:reset()
  self.level = 1
  self.score = 0
  self.lines = 0
  self.tetromino =
    Tetromino:new(
    {
      ["column"] = self.tetrominoCoords.column,
      ["row"] = self.tetrominoCoords.row,
      ["isCentered"] = true
    }
  )
end

function Gamedata:render()
  for i, box in ipairs(self.boxes) do
    box:render()
  end

  love.graphics.setColor(gColors[1].r, gColors[1].g, gColors[1].b)

  love.graphics.print("SCORE", self.boxes[1].x + self.textPadding.x, self.boxes[1].y + self.textPadding.y)
  love.graphics.printf(
    self.score,
    self.boxes[1].x - self.textPadding.x,
    self.boxes[1].y + self.boxes[1].height - self.textPadding.y - gFont:getHeight(),
    self.boxes[1].width,
    "right"
  )

  love.graphics.print("LEVEL", self.boxes[2].x + self.textPadding.x, self.boxes[2].y + self.textPadding.y)
  love.graphics.printf(
    self.level,
    self.boxes[2].x - self.textPadding.x,
    self.boxes[2].y + self.boxes[2].height - self.textPadding.y - gFont:getHeight(),
    self.boxes[2].width,
    "right"
  )

  love.graphics.print("LINES", self.boxes[3].x + self.textPadding.x, self.boxes[3].y + self.textPadding.y)
  love.graphics.printf(
    self.lines,
    self.boxes[3].x - self.textPadding.x,
    self.boxes[3].y + self.boxes[3].height - self.textPadding.y - gFont:getHeight(),
    self.boxes[3].width,
    "right"
  )

  self.tetromino:render()
end
