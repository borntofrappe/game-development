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

  self.matches = {}
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
        Timer.tween(0.1, {
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

    self:calculateMatches()
    self:removeMatches()
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
  for y = 1, #self.tiles do
    -- 8 columns
    for x = 1, #self.tiles[y] do
      if self.tiles[y][x] then
        self.tiles[y][x]:render()
      end
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

-- function calculating matches from the board
function Board:calculateMatches()
  -- initialize a variable in which to store all possible matches
  local matches = {}
  local colorMatches = 1

  -- loop through the rows
  for y = 1, 8 do
    -- initialize a variable describing the current color
    local colorToMatch = self.tiles[y][1].color

    -- initialize the counter to keep track of the matching color
    colorMatches = 1

    -- consider every tile following the first one
    for x = 2, 8 do
      -- increment the counter if the colorToMatch matches the color of the newly identified tile
      if self.tiles[y][x].color == colorToMatch then
        colorMatches = colorMatches + 1
      else
        -- set colorToMatch to the color of the new tile
        colorToMatch = self.tiles[y][x].color

        -- check if colorMatches is greater than or equal to 3
        if colorMatches >= 3 then
          -- include the tiles with the matching color in a table describing matches
          local match = {}
          -- ! the color is described by the tiles **preceding** the one with the different color
          for x2 = x - 1, x - colorMatches, -1 do
            table.insert(match, self.tiles[y][x2])
          end

          -- add the match table to the overarching table of matches
          table.insert(matches, match)

        end

        -- reset colorMatches to 1
        colorMatches = 1

        -- pre emptively go to the following row if there are only two tiles left
        if x >= 7 then
          break
        end


      end
    end

    -- check for a match considering tthe last tile in the row
    if colorMatches >= 3 then
      -- add the matching tiles to a local table and add the table to the overarching data structure
      local match = {}
      for x = 8, 8 - colorMatches + 1, -1 do
        table.insert(match, self.tiles[y][x])
      end

      table.insert(matches, match)
    end

  end

  -- loop through the columns
  for x = 1, 8 do
    -- initialize a variable describing the current color
    local colorToMatch = self.tiles[1][x].color

    -- initialize the counter to keep track of the matching color
    colorMatches = 1

    -- consider every tile following the first one
    for y = 2, 8 do
      -- increment the counter if the colorToMatch matches the color of the newly identified tile
      if self.tiles[y][x].color == colorToMatch then
        colorMatches = colorMatches + 1
      else
        -- set colorToMatch to the color of the new tile
        colorToMatch = self.tiles[y][x].color

        -- check if colorMatches is greater than or equal to 3
        if colorMatches >= 3 then
          -- include the tiles with the matching color in a table describing matches
          local match = {}
          -- ! the color is described by the tiles **preceding** the one with the different color
          for y2 = y - 1, y - colorMatches, -1 do
            table.insert(match, self.tiles[y2][x])
          end

          -- add the match table to the overarching table of matches
          table.insert(matches, match)

        end

        -- reset colorMatches to 1
        colorMatches = 1

        -- pre emptively go to the following row if there are only two tiles left
        if y >= 7 then
          break
        end


      end

    end
    -- check for a match considering tthe last tile in the column
    if colorMatches >= 3 then
      -- add the matching tiles to a local table and add the table to the overarching data structure
      local match = {}
      for y = 8, 8 - colorMatches + 1, -1 do
        table.insert(match, self.tiles[y][x])
      end

      table.insert(matches, match)
    end
  end

  -- include matches in the respective variable of the board
  self.matches = matches

  -- return the matches, or false if no match is stored in the table
  return #self.matches > 0 and self.matches or false
end


-- function removing matches from the grid
function Board:removeMatches()
  if self:calculateMatches() then
    -- loop through the table of matches
    for k, match in pairs(self.matches) do
      -- loop through the tiles of each match
      for j, tile in pairs(match) do
        -- set the tiles in self.tiles which match the tiles' own coordinates to nil
        self.tiles[tile.gridY][tile.gridX] = nil
      end
    end

    -- reset matches to nil
    self.matches = nil

    -- call the function to update the board in light of the matches being removed
    self:updateBoard()
  end
end


-- function updating the appearance of the board
function Board:updateBoard()
  -- for every column
  for x = 1, 8 do
    -- variables to identify a space and its position in the grid
    local space = false
    local spaceY = 0
    -- variable to consider each tile in the column, starting from the bottom
    local y = 8

    -- until y describes the first row
    -- ! remember to change y as to inevitably be less than 1, and exit the loop
    while y >= 1 do
    -- identify the current tile
      local tile = self.tiles[y][x]

      -- check if a space has been found, **before** the current tile
      if space then
        -- if the tile is not nil set space to false
        -- a tile has been found
        if tile then
          -- set the tile identifying the space to refer to the instance of the tile class found with the if statement
          -- spaceY keeps track of the vertical position of the space
          self.tiles[spaceY][x] = tile
          -- update the vertical position of the tile to match the coordinate identified for the space, to have the tile effectively moved in the grid
          tile.gridY = spaceY

          -- set the current tile, which previously described the instance of the class tile, to nil
          -- this because the tile is moved downwards creating a space
          self.tiles[y][x] = nil
          -- modify the vertical coordinate to visually have the tile move downwards
          -- tile.y = (tile.gridY - 1) * 32 + self.offsetY
          -- use the tween function on the Timer object to transition the tiles to their values
          Timer.after(0.1, function()
            Timer.tween(0.2, {
              [tile] = { y = (tile.gridY - 1) * 32 + self.offsetY}
            })
          end)

          -- set space to false, as a tile has been found
          space = false
          -- update the vertical coordinate to start from where the space has been found
          y = spaceY

          -- reset spaceY back to 0
          -- this identifies the coordinate of a space, and is updated when a space is indeed found
          spaceY = 0
        end

      -- if space is not true, check if the current tile is nil (meaning a space)
      elseif tile == nil then
        -- set space to true
        -- a space has been found
        space = true

        -- assign the current vertical coordinate to spaceY
        -- ! only if spaceY has not been already initialized
        -- this to have spaceY refer to the first space found on the way up
        if spaceY == 0 then
          spaceY = y
        end
      end

      -- go to the row above
      y = y - 1
    end
  end

  -- once every existing tile has been moved to account for gravity include new tiles
  -- loop through each column
  for x = 1, 8 do
    -- starting from the last row and until the first one
    for y = 8, 1, -1 do
      -- consider the tile found at the precise coordinates
      local tile = self.tiles[y][x]
      -- if nil, it represents a space
      if tile == nil then
        -- create a new tile, much alike when making up the board in the first place
        local tile = Tile(x, y, self.offsetX, self.offsetY, math.random(18), math.random(6))
        -- position the tile to its rightful place, but starting 32px above, to give the impression of a falling tile
        tile.y = -32
        -- include the tile in the table of tile
        self.tiles[y][x] = tile
        -- ! transition the tile with the tween function with the same delay applied in the first for loop
        Timer.after(0.15, function()
          Timer.tween(0.2, {
            [tile] = { y = (tile.gridY - 1) * 32 + self.offsetY}
          })
        end)

      end
    end
  end
end