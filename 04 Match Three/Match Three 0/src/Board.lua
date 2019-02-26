-- initialize a class for the Board
Board = Class{}

--[[
  in the :init function set up the board
  - offsetX, offsetY, identifying where to draw the baord
  - tiles, a table of the different tiles making up the board (64 instances of the Tile class)

  - selectedTile, highlighted, highlightedTile to visually relate the selected and highlighted tile
]]

function Board:init(offsetX, offsetY)
  self.offsetX = offsetX
  self.offsetY = offsetY
  self.tiles = self:generateBoard()

  self.selectedTile = self.tiles[math.random(8)][math.random(8)]
  self.highlighted = false
  self.highlightedTile = self.selectedTile

end


-- in the :update(dt) function consider the arrow and enter keys, to move the selected tile, highlight the selected tile and swap the highlighted tile
function Board:update(dt)
  -- listen for a key press on the arrow keys, at which point update the reference of the selectedTile to the adjacent tile
  -- ! update the position in the [1-8] range, clamping the values to 1 and 8 respectively
  if love.keyboard.wasPressed('up') then
    self.selectedTile = self.tiles[math.max(1, self.selectedTile.gridY - 1)][self.selectedTile.gridX]
  end

  if love.keyboard.wasPressed('right') then
    self.selectedTile = self.tiles[self.selectedTile.gridY][math.min(8, self.selectedTile.gridX + 1)]

  end

  if love.keyboard.wasPressed('down') then
    self.selectedTile = self.tiles[math.min(8, self.selectedTile.gridY + 1)][self.selectedTile.gridX]
  end

  if love.keyboard.wasPressed('left') then
    self.selectedTile = self.tiles[self.selectedTile.gridY][math.max(1, self.selectedTile.gridX - 1)]
  end

  -- listen for a key press on the enter key
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    --[[
      pressing enter enables to highlight a tile or alternatively swap two tiles, if a tile has already been highlighted
    ]]
    -- if highlighted
    if self.highlighted then
      -- consider the selected and self.highlighted tile
      local tile1 = self.selectedTile
      local tile2 = self.highlightedTile

      -- proceed to swap only when the selected and highlighted tiles prove to be adjacent
      if math.abs((tile1.gridX - tile2.gridX) + (tile1.gridY - tile2.gridY)) == 1 then

        -- create temporary variables in which to store one side's coordinates
        local tempX, tempY = tile2.x, tile2.y
        local tempgridX, tempgridY = tile2.gridX, tile2.gridY
        -- create a temporary variable in which to store one side's tile
        local tempTile = tile1

        -- swap the tiles in the board
        self.tiles[tile1.gridY][tile1.gridX] = tile2
        self.tiles[tile2.gridY][tile2.gridX] = tempTile

        -- swap the tiles on the screen moving to the coordinate each tile needs to retain after the swap
        Timer.tween(0.2, {
          -- using the temporary values for the tile being modified
          [tile2] = {x = tile1.x, y = tile1.y},
          [tile1] = {x = tempX, y = tempY}
        })
        -- immediately updat gridX and gridY, as the two don't reflect on the UI
        tile2.gridX = tile1.gridX
        tile2.gridY = tile1.gridY
        tile1.gridX = tempgridX
        tile1.gridY = tempgridY

        -- change the selected tile to have the outline placed on the swapped, destination tile
        self.selectedTile = tile2


      end

      -- always set self.highlighted to false, regardless of an actual swap occurring
      self.highlighted = false

    -- else if not highlighted
    else
      -- update self.highlightedTile with the coordinate of the self.selectedTile
      self.highlightedTile = self.tiles[self.selectedTile.gridY][self.selectedTile.gridX]
      -- visualize the highlight through the semi-transparent filled rectangle
      self.highlighted = true

    end

  end

  -- update the timer to show the swap
  Timer.update(dt)
end

-- in the :render function render each tile in self.tiles as well as the highlighted and selected tiles
function Board:render()
  self:drawBoard()
end


-- function generating an 8x8 table made up of 1 table for each row, itself made up of 1 table for each column
function Board:generateBoard()
  -- create a table of tables themselves storing the different tiles
  tiles = {}
  -- 8 rows (which change in their y coordinate)
  for y = 1, 8 do
    -- include a table
    table.insert(tiles, {})

    -- 8 columns (which change in their x coordinate)
    for x = 1, 8 do
      -- in the table created for the row include instances of the Tile class
      -- specifying the necessary values
      table.insert(tiles[y], Tile(x, y, self.offsetX, self.offsetY, math.random(18), math.random(6)))
    end
  end

  -- return the table of tiles
  return tiles
end

function Board:drawBoard()
  -- draw the tiles
  -- 8 rows
  for y = 1, 8 do
    -- 8 columns
    for x = 1, 8 do
      self.tiles[y][x]:render()
    end
  end

  -- draw the highlighted tile through the semi-transparent, filled rectangle
  -- ! if an highlight is present
  if self.highlighted then
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.rectangle('fill', self.highlightedTile.x, self.highlightedTile.y, 32, 32, 4)
    -- reset the opacity
    love.graphics.setColor(1, 1, 1, 1)
  end

  -- draw the selected tile through the outline of a rectangle
  love.graphics.setColor(1, 0, 0.3, 1)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle('line', self.selectedTile.x, self.selectedTile.y, 32, 32, 4)

  -- reset the color
  love.graphics.setColor(1, 1, 1, 1)

end
