Tetriminos = {}
Tetriminos.__index = Tetriminos

function Tetriminos:new(def)
  local tetriminos = TETRIMINOS[math.random(#TETRIMINOS)]
  local bricks = tetriminos.bricks
  local variant = 1
  local color = math.random(#gFrames["tiles"] - 1)

  local column = def.column or 1
  local row = def.row or 1

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
    ["color"] = color
  }

  setmetatable(this, self)
  return this
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
