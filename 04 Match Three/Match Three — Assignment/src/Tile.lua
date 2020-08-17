Tile = Class {}

function Tile:init(x, y, level)
  self.x = x
  self.y = y
  self.level = level
  self.isShiny = math.random(18) == 1
  self.color = math.random(8)
  self.variety = math.random(math.min(self.level, #gFrames["tiles"][1]))
end

function Tile:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(
    gTextures["match3"],
    gFrames["tiles"][self.color][self.variety],
    (self.x - 1) * TILE_WIDTH,
    (self.y - 1) * TILE_HEIGHT
  )

  if self.isShiny then
    love.graphics.setColor(0.9, 0.8, 0.2, 1)
    love.graphics.polygon(
      "fill",
      (self.x - 1) * TILE_WIDTH + TILE_WIDTH * 3 / 4,
      (self.y - 1) * TILE_HEIGHT + TILE_HEIGHT / 4 - 4,
      (self.x - 1) * TILE_WIDTH + TILE_WIDTH * 3 / 4 + 4,
      (self.y - 1) * TILE_HEIGHT + TILE_HEIGHT / 4,
      (self.x - 1) * TILE_WIDTH + TILE_WIDTH * 3 / 4,
      (self.y - 1) * TILE_HEIGHT + TILE_HEIGHT / 4 + 4,
      (self.x - 1) * TILE_WIDTH + TILE_WIDTH * 3 / 4 - 4,
      (self.y - 1) * TILE_HEIGHT + TILE_HEIGHT / 4
    )
  end
end
