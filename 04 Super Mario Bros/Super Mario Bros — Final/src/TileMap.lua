TileMap = Class {}

function TileMap:init(width, height)
  self.width = width
  self.height = height

  self.tiles = {}
end

TileMap = Class {}

function TileMap:init(width, height)
  self.width = width
  self.height = height

  self.tiles = {}
end

function TileMap:pointToTile(x, y)
  if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
    return nil
  end

  local column = 1 + math.floor(x / TILE_SIZE)
  local row = 1 + math.floor(y / TILE_SIZE)
  return self.tiles[column][row]
end

function TileMap:render()
  for x = 1, self.width do
    for y = 1, self.height do
      self.tiles[x][y]:render()
    end
  end
end
