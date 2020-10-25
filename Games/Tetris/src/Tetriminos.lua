Tetriminos = {}
Tetriminos.__index = Tetriminos

function Tetriminos:new(def)
  local tetriminos = TETRIMINOS[math.random(#TETRIMINOS)]
  local bricks = tetriminos.bricks
  local variant = 1
  local color = math.random(#gFrames["tiles"] - 1)
  local column = def.column or 1
  local row = def.row or 1
  local grid = def.grid or {}

  local center = def.center or false
  if center then
    column = column + tetriminos.offset[1]
    row = row + tetriminos.offset[2]
  end

  this = {
    ["column"] = column,
    ["row"] = row,
    ["bricks"] = bricks,
    ["variant"] = variant,
    ["color"] = color,
    ["grid"] = grid,
    ["inPlay"] = true
  }

  setmetatable(this, self)
  return this
end

function Tetriminos:move(direction)
  if direction == "down" then
    local isRowAvailable = true
    for i, brickCoor in pairs(self.bricks[self.variant]) do
      if self.row + brickCoor[2] >= self.grid.rows then
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
    for i, brickCoor in pairs(self.bricks[self.variant]) do
      if self.column + brickCoor[1] >= self.grid.columns then
        isColumnAvailable = false
        break
      end
    end

    if isColumnAvailable then
      self.column = self.column + 1
    end
  elseif direction == "left" then
    local isColumnAvailable = true
    for i, brickCoor in pairs(self.bricks[self.variant]) do
      if self.column + brickCoor[1] <= 1 then
        isColumnAvailable = false
        break
      end
    end

    if isColumnAvailable then
      self.column = self.column - 1
    end
  end
end

function Tetriminos:render()
  love.graphics.setColor(1, 1, 1)
  for i, brickCoor in ipairs(self.bricks[self.variant]) do
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][self.color],
      (self.column - 1) * TILE_SIZE + brickCoor[1] * TILE_SIZE,
      (self.row - 1) * TILE_SIZE + brickCoor[2] * TILE_SIZE
    )
  end
end
