Tetriminos = {}
Tetriminos.__index = Tetriminos

function Tetriminos:new(def)
  local def =
    def or
    {
      ["column"] = TILE_SIZE,
      ["row"] = 0
    }

  this = {
    ["column"] = def.column,
    ["row"] = def.row,
    ["tiles"] = {
      {1, 1},
      {2, 1},
      {3, 1},
      {2, 2}
    },
    ["color"] = math.random(#gFrames["tiles"] - 1)
  }

  setmetatable(this, self)
  return this
end

function Tetriminos:render()
  love.graphics.setColor(1, 1, 1)
  for i, tile in ipairs(self.tiles) do
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][self.color],
      (self.column + tile[1] - 1) * TILE_SIZE,
      (self.row + tile[2] - 1) * TILE_SIZE
    )
  end
end
