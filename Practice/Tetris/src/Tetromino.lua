Tetromino = {}

local CONFIGS = {
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
      {0, 0},
      {1, 0},
      {0, 1},
      {1, 1}
    }
  }
}

local FRAMES = {
  {1},
  {2},
  {3, 4},
  {5, 6},
  {7}
}

local OFFSET_CENTER = {
  {0.5, 0},
  {0, 0.5},
  {0.5, 0},
  {0.5, 0},
  {0.5, 0},
  {0.5, 0},
  {0, 0}
}

function Tetromino:new(def)
  local def = def or {}

  local frame = def.frame or math.random(#FRAMES)
  local type = def.type or FRAMES[frame][math.random(#FRAMES[frame])]

  local config = CONFIGS[type]
  local configIndex = 1

  local columnStart = def.column or math.floor(COLUMNS_GRID / 2)
  local rowStart = def.row or 1

  local bricks = {}
  for k, coords in pairs(config[configIndex]) do
    local column = columnStart + coords[1]
    local row = rowStart + coords[2]

    if def.isCentered then
      column = column + OFFSET_CENTER[type][1]
      row = row + OFFSET_CENTER[type][2]
    end

    local brick = Brick:new(column, row, frame)
    table.insert(bricks, brick)
  end

  local this = {
    ["frame"] = frame,
    ["type"] = type,
    ["config"] = config,
    ["configIndex"] = configIndex,
    ["column"] = columnStart,
    ["row"] = rowStart,
    ["bricks"] = bricks,
    ["isHidden"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Tetromino:rotate(grid)
  if #self.config == 1 then
    return false
  end

  local canRotate = true
  local configIndex = self.configIndex == #self.config and 1 or self.configIndex + 1
  local bricks = {}

  for k, coords in pairs(self.config[configIndex]) do
    local column = self.column + coords[1]
    local row = self.row + coords[2]

    if column < 1 or column > grid.columns or row < 1 or row > grid.rows or grid.bricks[column][row] then
      canRotate = false
      break
    end

    local brick = Brick:new(column, row, self.frame)
    table.insert(bricks, brick)
  end

  if canRotate then
    self.configIndex = configIndex
    self.bricks = bricks
  end
end

function Tetromino:move(direction, grid)
  if direction == "right" then
    local canMoveRight = true

    for k, brick in pairs(self.bricks) do
      if brick.column + 1 > grid.columns then
        canMoveRight = false
        break
      end

      if canMoveRight and grid.bricks[brick.column + 1][brick.row] then
        canMoveRight = false
        break
      end
    end

    if canMoveRight then
      self.column = self.column + 1
      for k, brick in pairs(self.bricks) do
        brick.column = brick.column + 1
      end
    end
  elseif direction == "down" then
    local canMoveDown = true

    for k, brick in pairs(self.bricks) do
      if brick.row + 1 > grid.rows then
        canMoveDown = false
        break
      end

      if canMoveDown and grid.bricks[brick.column][brick.row + 1] then
        canMoveDown = false
        break
      end
    end

    if canMoveDown then
      self.row = self.row + 1
      for k, brick in pairs(self.bricks) do
        brick.row = brick.row + 1
      end
    end
  elseif direction == "left" then
    local canMoveLeft = true

    for k, brick in pairs(self.bricks) do
      if brick.column - 1 < 1 then
        canMoveLeft = false
        break
      end

      if canMoveLeft and grid.bricks[brick.column - 1][brick.row] then
        canMoveLeft = false
        break
      end
    end

    if canMoveLeft then
      self.column = self.column - 1
      for k, brick in pairs(self.bricks) do
        brick.column = brick.column - 1
      end
    end
  end
end

function Tetromino:collides(grid)
  for k, brick in pairs(self.bricks) do
    if brick.row + 1 > grid.rows then
      return true
    end

    if grid.bricks[brick.column][brick.row + 1] then
      return true
    end
  end

  return false
end

function Tetromino:overlaps(grid)
  for k, brick in pairs(self.bricks) do
    if grid.bricks[brick.column][brick.row] then
      return true
    end
  end

  return false
end

function Tetromino:update()
  self.row = self.row + 1
  for k, brick in pairs(self.bricks) do
    brick.row = brick.row + 1
  end
end

function Tetromino:hide()
  self.isHidden = true
end

function Tetromino:render()
  if not self.isHidden then
    love.graphics.setColor(1, 1, 1)
    for k, brick in pairs(self.bricks) do
      brick:render()
    end
  end
end
