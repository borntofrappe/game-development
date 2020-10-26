Tetriminos = {}
Tetriminos.__index = Tetriminos

function Tetriminos:new(def)
  local type = def.type or math.random(#TETRIMINOS)
  local color = def.color or math.random(#gFrames["tiles"] - 1)
  local column = def.column or 1
  local row = def.row or 1
  local grid = def.grid or {}

  local tetriminos = TETRIMINOS[type]
  local bricks = tetriminos.bricks
  local shape = 1

  local center = def.center or false
  if center then
    column = column + tetriminos.offset[1]
    row = row + tetriminos.offset[2]
  end

  this = {
    ["type"] = type,
    ["color"] = color,
    ["column"] = column,
    ["row"] = row,
    ["grid"] = grid,
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
    for i, offset in pairs(self.bricks[self.shape]) do
      if self.row + offset[2] >= self.grid.rows then
        isRowAvailable = false
        break
      end
    end

    if isRowAvailable then
      self.row = self.row + 1
    else
      self.inPlay = false
    end
  elseif direction == "right" then
    local isColumnAvailable = true
    for i, offset in pairs(self.bricks[self.shape]) do
      if self.column + offset[1] >= self.grid.columns then
        isColumnAvailable = false
        break
      end
    end

    if isColumnAvailable then
      self.column = self.column + 1
    end
  elseif direction == "left" then
    local isColumnAvailable = true
    for i, offset in pairs(self.bricks[self.shape]) do
      if self.column + offset[1] <= 1 then
        isColumnAvailable = false
        break
      end
    end

    if isColumnAvailable then
      self.column = self.column - 1
    end
  end
end

function Tetriminos:rotate()
  if #self.bricks > 1 then
    local shape = self.shape == #self.bricks and 1 or self.shape + 1
    local canRotate = true
    for i, offset in pairs(self.bricks[shape]) do
      if
        self.row + offset[2] < 1 or self.row + offset[2] >= self.grid.rows or
          self.column + offset[1] > self.grid.columns or
          self.column + offset[1] < 1
       then
        canRotate = false
        break
      end
    end

    if canRotate then
      self.shape = shape
    end
  end
end

function Tetriminos:render()
  love.graphics.setColor(1, 1, 1)
  for i, offset in ipairs(self.bricks[self.shape]) do
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][self.color],
      (self.column - 1) * TILE_SIZE + offset[1] * TILE_SIZE,
      (self.row - 1) * TILE_SIZE + offset[2] * TILE_SIZE
    )
  end
end
