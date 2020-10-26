Tetriminos = {}
Tetriminos.__index = Tetriminos

function Tetriminos:new(def)
  local type = def.type or math.random(#TETRIMINOS_OFFSETS)
  local color = def.color or math.random(#gFrames["tiles"] - 1)
  local column = def.column or 1
  local row = def.row or 1
  local grid = def.grid or {}

  local offset = TETRIMINOS_OFFSETS[type]
  local offsetBricks = offset.bricks
  local offsetCenter = offset.center
  local shape = 1

  local center = def.center or false
  if center then
    column = column + offsetCenter[1]
    row = row + offsetCenter[2]
  end

  local bricks = {}
  for i, offsetBrick in ipairs(offsetBricks[shape]) do
    table.insert(
      bricks,
      Brick:new(
        {
          ["column"] = column + offsetBrick[1],
          ["row"] = row + offsetBrick[2],
          ["color"] = color
        }
      )
    )
  end

  this = {
    ["type"] = type,
    ["color"] = color,
    ["column"] = column,
    ["row"] = row,
    ["grid"] = grid,
    ["offsetBricks"] = offsetBricks,
    ["bricks"] = bricks,
    ["shape"] = shape,
    ["inPlay"] = true
  }

  setmetatable(this, self)
  return this
end

function Tetriminos:move(direction)
  if direction == "down" then
    local isRowAvailable = true
    for i, brick in ipairs(self.bricks) do
      if brick.row >= self.grid.rows then
        isRowAvailable = false
        break
      end
    end

    if isRowAvailable then
      self.row = self.row + 1
      for i, brick in ipairs(self.bricks) do
        brick.row = brick.row + 1
      end
    else
      self.inPlay = false
    end
  elseif direction == "right" then
    local isColumnAvailable = true

    for i, brick in ipairs(self.bricks) do
      if brick.column >= self.grid.columns then
        isColumnAvailable = false
        break
      end
    end

    if isColumnAvailable then
      self.column = self.column + 1
      for i, brick in ipairs(self.bricks) do
        brick.column = brick.column + 1
      end
    end
  elseif direction == "left" then
    local isColumnAvailable = true

    for i, brick in ipairs(self.bricks) do
      if brick.column <= 1 then
        isColumnAvailable = false
        break
      end
    end

    if isColumnAvailable then
      self.column = self.column - 1
      for i, brick in ipairs(self.bricks) do
        brick.column = brick.column - 1
      end
    end
  end
end

function Tetriminos:rotate()
  if #self.offsetBricks > 1 then
    local shape = self.shape == #self.offsetBricks and 1 or self.shape + 1
    local canRotate = true

    local bricks = {}
    for i, offsetBrick in ipairs(self.offsetBricks[shape]) do
      if
        self.row + offsetBrick[2] < 1 or self.row + offsetBrick[2] > self.grid.rows or
          self.column + offsetBrick[1] > self.grid.columns or
          self.column + offsetBrick[1] < 1
       then
        canRotate = false
        break
      end

      table.insert(
        bricks,
        Brick:new(
          {
            ["column"] = self.column + offsetBrick[1],
            ["row"] = self.row + offsetBrick[2],
            ["color"] = self.color
          }
        )
      )
    end

    if canRotate then
      self.bricks = bricks
      self.shape = shape
    end
  end
end

function Tetriminos:render()
  love.graphics.setColor(1, 1, 1)

  for i, brick in ipairs(self.bricks) do
    brick:render()
  end
end
