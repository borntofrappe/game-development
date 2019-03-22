-- initialize a class for the Tile
Tile = Class{}

--[[
  in the :init function set up the tile
  - gridX and gridY, describing the position in the board
  - x and y, computed on the basis of gridX and gridY, to account for the size of the tiles
  - color
  - variety
  these last two are used to clear matches of the same color and account for the different shapes when awarding points
  - shiny, dictating the peculiar tile highlighted through a small glow

  - tiles, in which to store the table of quads sorted per color and variety
]]

function Tile:init(gridX, gridY, offsetX, offsetY, color, variety, shiny)
  self.gridX = gridX
  self.gridY = gridY
  self.x = (gridX - 1) * 32 + offsetX
  self.y = (gridY - 1) * 32 + offsetY
  self.shiny = shiny

  self.color = color
  self.variety = variety

  self.tiles = self:arrange()
end

-- in the :render function render the tiles according to the initialized values
function Tile:render()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(gTextures['spritesheet'], self.tiles[self.color][self.variety], self.x, self.y)


  -- if shiny superimpose a translucent white overlay atop a slightly more opaque, but still white border
  if self.shiny then
    love.graphics.setColor(1, 1, 1, 0.1)
    love.graphics.rectangle('fill', self.x, self.y, 32, 32, 8)

    love.graphics.setLineWidth(4)
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle('line', self.x + 2, self.y + 2, 28, 28, 8)
  end
end

-- in the :arrange() function take the table of quads and re-arrange the tiles according to their color and variety
--[[
  there exist 18 colors and 6 varieties
  the tiles are originally displayed color after color, variety after variety
  { y1 y2 y3 y4 y5 y6 p1 p2 p3 ... and so forth }

  the desired structure is
  {
    { y1 y2 y3 y4 y5 y6 }
    { p1 p2 p3 ... and so forth}
  }
]]
function Tile:arrange()
  -- overarching table
  local tiles = {}
  for color = 1, 18 do
    -- table for each different color
    table.insert(tiles, {})
    for variety = 1, 6 do
      -- tile of each variety and for the specified color
      table.insert(tiles[color], gFrames['tiles'][variety + (color - 1) * 6])
    end
  end

  -- return the table
  return tiles
end