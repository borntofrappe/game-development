Tetromino = {}

local OFFSET_COLUMNS = math.floor(GRID_COLUMNS / 2) - 1
local TETROMINOS = {
  {
    {
      {-1, 0},
      {0, 0},
      {1, 0},
      {2, 0}
    },
    {
      {0, -1},
      {0, 0},
      {0, 1},
      {0, 2}
    }
  },
  {
    {
      {-1, 0},
      {-1, 1},
      {0, 1},
      {1, 1}
    },
    {
      {1, 0},
      {0, 0},
      {0, 1},
      {0, 2}
    },
    {
      {1, 2},
      {1, 1},
      {0, 1},
      {-1, 1}
    },
    {
      {0, 0},
      {0, 1},
      {0, 2},
      {-1, 2}
    }
  },
  {
    {
      {1, 0},
      {1, 1},
      {0, 1},
      {-1, 1}
    },
    {
      {0, 0},
      {0, 1},
      {0, 2},
      {1, 2}
    },
    {
      {1, 1},
      {0, 1},
      {-1, 1},
      {-1, 2}
    },
    {
      {-1, 0},
      {0, 0},
      {0, 1},
      {0, 2}
    }
  },
  {
    {
      {0, 0},
      {1, 0},
      {0, 1},
      {1, 1}
    }
  },
  {
    {
      {1, 0},
      {0, 0},
      {0, 1},
      {-1, 1}
    },
    {
      {-1, -1},
      {-1, 0},
      {0, 0},
      {0, 1}
    }
  },
  {
    {
      {-1, 0},
      {0, 0},
      {1, 0},
      {0, 1}
    },
    {
      {-1, 0},
      {0, -1},
      {0, 0},
      {0, 1}
    },
    {
      {-1, 0},
      {0, 0},
      {1, 0},
      {0, -1}
    },
    {
      {1, 0},
      {0, -1},
      {0, 0},
      {0, 1}
    }
  },
  {
    {
      {-1, 0},
      {0, 0},
      {0, 1},
      {1, 1}
    },
    {
      {0, -1},
      {0, 0},
      {-1, 0},
      {-1, 1}
    }
  }
}

function Tetromino:new()
  local frame = math.random(5)
  local columnStart = PADDING_COLUMNS + BORDER_COLUMNS + OFFSET_COLUMNS

  local tetromino = TETROMINOS[#TETROMINOS]

  local bricks = {}
  for k, coords in pairs(tetromino[1]) do
    local column = coords[1]
    local row = coords[2]
    table.insert(bricks, Brick:new(columnStart + column, row, frame))
  end

  local this = {
    ["bricks"] = bricks
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Tetromino:update()
  for k, brick in pairs(tetromino.bricks) do
    brick.row = math.min(GRID_ROWS, brick.row + 1)
  end
end

function Tetromino:render()
  for k, brick in pairs(self.bricks) do
    brick:render()
  end
end
