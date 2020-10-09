Level = Class {}

function Level:init()
  self.baseTiles = {}
  self.tallGrassTiles = {}

  self.columns = COLUMNS
  self.rows = ROWS
  self.tallGrassRows = ROWS - ROWS_GRASS

  for column = 1, self.columns do
    self.baseTiles[column] = {}
    self.tallGrassTiles[column] = {}
    for row = 1, self.rows do
      self.baseTiles[column][row] = Tile(column, row, TILE_IDS["background"])
      self.tallGrassTiles[column][row] =
        row > self.tallGrassRows and Tile(column, row, TILE_IDS["tall-grass"]) or Tile(column, row, TILE_IDS["empty"])
    end
  end
end

function Level:render()
  for column = 1, self.columns do
    for row = 1, self.rows do
      self.baseTiles[column][row]:render()
      self.tallGrassTiles[column][row]:render()
    end
  end
end
