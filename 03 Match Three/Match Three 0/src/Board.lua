Board = Class {}

function Board:init(rows, columns)
  self.tiles = {}

  for y = 1, rows do
    table.insert(self.tiles, {})
    for x = 1, columns do
      table.insert(self.tiles[y], Tile(x, y))
    end
  end

  self.selectedTile = {
    x = math.random(columns),
    y = math.random(rows)
  }

  self.highlightedTile = nil
end

function Board:update(dt)
  if love.keyboard.waspressed("right") then
    self.selectedTile.x = math.min(COLUMNS, self.selectedTile.x + 1)
  end

  if love.keyboard.waspressed("left") then
    self.selectedTile.x = math.max(1, self.selectedTile.x - 1)
  end

  if love.keyboard.waspressed("up") then
    self.selectedTile.y = math.max(1, self.selectedTile.y - 1)
  end

  if love.keyboard.waspressed("down") then
    self.selectedTile.y = math.min(ROWS, self.selectedTile.y + 1)
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    if self.highlightedTile then
      tile1 = self.tiles[self.selectedTile.y][self.selectedTile.x]
      tile2 = self.tiles[self.highlightedTile.y][self.highlightedTile.x]

      if math.abs(tile1.x - tile2.x) + math.abs(tile1.y - tile2.y) == 1 then
        tempX, tempY = tile1.x, tile1.y

        Timer.tween(
          0.2,
          {
            [tile1] = {x = tile2.x, y = tile2.y},
            [tile2] = {x = tempX, y = tempY}
          }
        )

        self.tiles[tile1.y][tile1.x], self.tiles[tile2.y][tile2.x] =
          self.tiles[tile2.y][tile2.x],
          self.tiles[tile1.y][tile1.x]
      end

      self.highlightedTile = nil
    else
      self.highlightedTile = {
        x = self.selectedTile.x,
        y = self.selectedTile.y
      }
    end
  end

  Timer.update(dt)
end

function Board:render()
  for y, row in ipairs(self.tiles) do
    for x, tile in ipairs(row) do
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
