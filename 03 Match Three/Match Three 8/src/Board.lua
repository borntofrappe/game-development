Board = Class {}

function Board:init(centerX, centerY)
  self.centerX = centerX or VIRTUAL_WIDTH / 2
  self.centerY = centerY or VIRTUAL_HEIGHT / 2

  self.tiles = {}

  for y = 1, ROWS do
    table.insert(self.tiles, {})
    for x = 1, COLUMNS do
      table.insert(self.tiles[y], Tile(x, y))
    end
  end

  self.selectedTile = nil

  self.highlightedTile = nil

  self.isUpdating = false
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
    if not self.isUpdating then
      if self.highlightedTile then
        tile1 = self.tiles[self.selectedTile.y][self.selectedTile.x]
        tile2 = self.tiles[self.highlightedTile.y][self.highlightedTile.x]

        if math.abs(tile1.x - tile2.x) + math.abs(tile1.y - tile2.y) == 1 then
          tempX, tempY = tile1.x, tile1.y

          Timer.tween(
            0.15,
            {
              [tile1] = {x = tile2.x, y = tile2.y},
              [tile2] = {x = tempX, y = tempY}
            }
          ):finish(
            function()
              if self:updateMatches() then
                self:updateBoard()
              end
            end
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
  end

  Timer.update(dt)
end

function Board:render()
  love.graphics.push()

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

  love.graphics.pop()
end

function Board:updateMatches()
  local matches = {}
  for y = 1, ROWS do
    local color = nil
    local colorMatches = 1
    for x = 1, COLUMNS do
      if color == self.tiles[y][x].color then
        colorMatches = colorMatches + 1
      else
        if colorMatches >= 3 then
          local match = {}
          for x2 = x - 1, x - colorMatches, -1 do
            table.insert(match, self.tiles[y][x2])
          end
          table.insert(matches, match)
        end

        color = self.tiles[y][x].color
        colorMatches = 1

        if x > COLUMNS - 2 then
          break
        end
      end
    end
    if colorMatches >= 3 then
      local match = {}
      for x = COLUMNS, COLUMNS - (colorMatches - 1), -1 do
        table.insert(match, self.tiles[y][x])
      end
      table.insert(matches, match)
    end
  end

  for x = 1, COLUMNS do
    local color = nil
    local colorMatches = 1
    for y = 1, ROWS do
      if color == self.tiles[y][x].color then
        colorMatches = colorMatches + 1
      else
        if colorMatches >= 3 then
          local match = {}
          for y2 = y - 1, y - colorMatches, -1 do
            table.insert(match, self.tiles[y2][x])
          end
          table.insert(matches, match)
        end

        color = self.tiles[y][x].color
        colorMatches = 1

        if y > ROWS - 2 then
          break
        end
      end
    end
    if colorMatches >= 3 then
      local match = {}
      for y = ROWS, ROWS - (colorMatches - 1), -1 do
        table.insert(match, self.tiles[y][x])
      end
      table.insert(matches, match)
    end
  end

  self.matches = matches
  return #matches > 0
end

function Board:removeMatches()
  for k, match in pairs(self.matches) do
    for j, tile in pairs(match) do
      self.tiles[tile.y][tile.x] = nil
    end
  end

  self.matches = {}
end

function Board:updateTiles()
  for x = 1, COLUMNS do
    local yNil = nil
    local y = ROWS
    while y > 0 do
      if yNil then
        if self.tiles[y][x] then
          self.tiles[yNil][x] = self.tiles[y][x]
          Timer.tween(
            0.2,
            {
              [self.tiles[yNil][x]] = {y = yNil}
            }
          )
          self.tiles[y][x] = nil
          y = yNil
          yNil = nil
        end
      else
        if not self.tiles[y][x] then
          yNil = y
        end
      end

      y = y - 1
    end
  end

  Timer.after(
    0.2,
    function()
      for x = 1, COLUMNS do
        for y = ROWS, 1, -1 do
          if not self.tiles[y][x] then
            self.tiles[y][x] = Tile(x, y)
            self.tiles[y][x].y = -1
            Timer.tween(
              0.2,
              {
                [self.tiles[y][x]] = {y = y}
              }
            )
          end
        end
      end
    end
  )
end

function Board:updateBoard()
  if self:updateMatches() then
    self.isUpdating = true
    self:removeMatches()
    self:updateTiles()

    Timer.after(
      0.5,
      function()
        self:updateBoard()
      end
    )
  else
    self.isUpdating = false
  end
end
