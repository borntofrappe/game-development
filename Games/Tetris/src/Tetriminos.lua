Tetriminos = {}
Tetriminos.__index = Tetriminos

function Tetriminos:new()
  this = {
    ["tiles"] = {
      {1, 1},
      {2, 1},
      {3, 1},
      {2, 2}
    },
    ["color"] = math.random(#gFrames["tiles"])
  }

  setmetatable(this, self)
  return this
end

function Tetriminos:render()
  for i, tile in ipairs(self.tiles) do
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][self.color],
      (tile[1] - 1) * TILE_SIZE,
      (tile[2] - 1) * TILE_SIZE
    )
  end
end
