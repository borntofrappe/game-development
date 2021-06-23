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

function Tetromino:new(grid)
  local frame = math.random(#FRAMES)
  local config = CONFIGS[FRAMES[frame][math.random(#FRAMES[frame])]]
  local index = 1

  local columnStart = math.floor(grid.columns / 2)
  local rowStart = 1

  local bricks = {}
  for k, coords in pairs(config[index]) do
    local column = columnStart + coords[1]
    local row = rowStart + coords[2]
    local brick = Brick:new(column, row, frame)
    table.insert(bricks, brick)
  end

  local this = {
    ["config"] = config,
    ["index"] = index,
    ["column"] = columnStart,
    ["row"] = rowStart,
    ["frame"] = frame,
    ["bricks"] = bricks
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

  local index = self.index == #self.config and 1 or self.index + 1
  local startConfig = self.config[self.index]
  local endConfig = self.config[index]

  local bricks = {}

  for k, coords in pairs(self.config[index]) do
    local column = self.column + coords[1]
    local row = self.row + coords[2]

    -- check if the column and row are available before creating the brick
    if column < 1 or column > grid.columns or row < 1 or row > grid.rows or grid.bricks[column][row] then
      canRotate = false
      break
    end

    local brick = Brick:new(column, row, self.frame)
    table.insert(bricks, brick)
  end

  if canRotate then
    self.index = index
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

function Tetromino:update()
  self.row = self.row + 1
  for k, brick in pairs(tetromino.bricks) do
    brick.row = brick.row + 1
  end
end

function Tetromino:render()
  love.graphics.setColor(1, 1, 1)
  for k, brick in pairs(self.bricks) do
    brick:render()
  end
end
