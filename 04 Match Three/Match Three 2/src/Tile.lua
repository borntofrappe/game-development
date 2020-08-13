Tile = Class {}

function Tile:init(x, y)
  self.x = x
  self.y = y
  self.color = math.random(#gFrames["tiles"])
  self.variety = math.random(#gFrames["tiles"][1])
end

function Tile:render()
  love.graphics.draw(
    gTextures["match3"],
    gFrames["tiles"][self.color][self.variety],
    (self.x - 1) * TILE_WIDTH,
    (self.y - 1) * TILE_HEIGHT
  )
end
