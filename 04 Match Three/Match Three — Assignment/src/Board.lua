Board = Class {}

function Board:init(level, centerX, centerY)
  self.level = level or 1
  self.centerX = centerX or VIRTUAL_WIDTH / 2
  self.centerY = centerY or VIRTUAL_HEIGHT / 2

  self.tiles = {}

  for y = 1, ROWS do
    table.insert(self.tiles, {})
    for x = 1, COLUMNS do
      local tile = Tile(x, y, self.level)
      table.insert(self.tiles[y], tile)
    end
  end

  self.selectedTile = nil
  self.highlightedTile = nil

  self.matches = {}
end

function Board:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.translate(self.centerX - COLUMNS * TILE_WIDTH / 2, self.centerY - ROWS * TILE_HEIGHT / 2)

  for y, row in pairs(self.tiles) do
    for x, tile in pairs(row) do
      tile:render()
    end
  end

  if self.highlightedTile then
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.rectangle(
      "fill",
      (self.highlightedTile.x - 1) * TILE_WIDTH,
      (self.highlightedTile.y - 1) * TILE_HEIGHT,
      TILE_WIDTH,
      TILE_HEIGHT,
      4
    )
    love.graphics.setColor(1, 1, 1, 1)
  end

  if self.selectedTile then
    love.graphics.setLineWidth(4)
    love.graphics.setColor(1, 0.1, 0.1, 1)
    love.graphics.rectangle(
      "line",
      (self.selectedTile.x - 1) * TILE_WIDTH,
      (self.selectedTile.y - 1) * TILE_HEIGHT,
      TILE_WIDTH,
      TILE_HEIGHT,
      4
    )
  end
  love.graphics.translate((self.centerX - COLUMNS * TILE_WIDTH / 2) * -1, (self.centerY - ROWS * TILE_HEIGHT / 2) * -1)
end
