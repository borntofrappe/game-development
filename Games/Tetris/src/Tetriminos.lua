Tetriminos = {}
Tetriminos.__index = Tetriminos

function Tetriminos:new(def)
  local def =
    def or
    {
      ["x"] = TILE_SIZE,
      ["y"] = 0
    }

  this = {
    ["x"] = def.x,
    ["y"] = def.y,
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
      self.x + (tile[1] - 1) * TILE_SIZE,
      self.y + (tile[2] - 1) * TILE_SIZE
    )
  end
end
