TileMap = Class {}

function TileMap:init(width, height)
  self.width = width
  self.height = height

  self.tiles = {}
end

function TileMap:render()
  for x = 1, self.width do
    for y = 1, self.height do
      self.tiles[x][y]:render()
    end
  end
end
