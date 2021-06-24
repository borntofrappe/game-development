Gamedata = {}

local ROWS_DATA = 3
local ROWS_TETRIMINO = 6
local COLUMNS = GAME_DATA_COLUMNS - 2
local COLUMN_START = 1
local ROW_START = 0.5
local ROW_SEPARATION = 0.5

function Gamedata:new()
  local level = 1
  local score = 0
  local lines = 0

  local rowStart = ROW_START

  local boxes = {}
  for i = 1, 3 do
    local box = Box:new(COLUMN_START, rowStart, COLUMNS, ROWS_DATA)
    rowStart = rowStart + ROWS_DATA + ROW_SEPARATION

    table.insert(boxes, box)
  end

  rowStart = rowStart + ROW_SEPARATION

  local box = Box:new(COLUMN_START, rowStart, COLUMNS, ROWS_TETRIMINO)
  table.insert(boxes, box)

  local tetrominoOffset = {
    ["column"] = COLUMN_START + math.floor(COLUMNS / 2),
    ["row"] = rowStart + math.floor(ROWS_TETRIMINO / 2)
  }

  local tetromino =
    Tetromino:new(
    {
      ["columnStart"] = tetrominoOffset.collides,
      ["rowStart"] = tetrominoOffset.row,
      ["isCentered"] = true
    }
  )

  local this = {
    ["level"] = level,
    ["score"] = score,
    ["lines"] = lines,
    ["tetromino"] = tetromino,
    ["tetrominoOffset"] = tetrominoOffset,
    ["boxes"] = boxes,
    ["padding"] = {
      ["x"] = 5,
      ["y"] = 4
    }
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Gamedata:setNewTetromino()
  self.tetromino =
    Tetromino:new(
    {
      ["columnStart"] = self.tetrominoOffset.collides,
      ["rowStart"] = self.tetrominoOffset.row,
      ["isCentered"] = true
    }
  )
end

function Gamedata:reset()
  self.level = 1
  self.score = 0
  self.lines = 0
end

function Gamedata:render()
  for i, box in ipairs(self.boxes) do
    box:render()
  end

  love.graphics.setColor(gColors[1].r, gColors[1].g, gColors[1].b)
  love.graphics.print("SCORE", self.boxes[1].x + self.padding.x, self.boxes[1].y + self.padding.y)

  love.graphics.printf(
    self.score,
    self.boxes[1].x - self.padding.x,
    self.boxes[1].y + self.boxes[1].height - self.padding.y - gFont:getHeight(),
    self.boxes[1].width,
    "right"
  )

  love.graphics.print("LEVEL", self.boxes[2].x + self.padding.x, self.boxes[2].y + self.padding.y)
  love.graphics.printf(
    self.level,
    self.boxes[2].x - self.padding.x,
    self.boxes[2].y + self.boxes[2].height - self.padding.y - gFont:getHeight(),
    self.boxes[2].width,
    "right"
  )

  love.graphics.print("LINES", self.boxes[3].x + self.padding.x, self.boxes[3].y + self.padding.y)
  love.graphics.printf(
    self.lines,
    self.boxes[3].x - self.padding.x,
    self.boxes[3].y + self.boxes[3].height - self.padding.y - gFont:getHeight(),
    self.boxes[3].width,
    "right"
  )

  self.tetromino:render()
end
