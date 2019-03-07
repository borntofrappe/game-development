--[[
  utility function(s)
  - GenerateQuads() to create quads from a sprite image, given a width and a height
  - GeneratTiles() to retrieve from the tiles.png image only the quads referring to solid squares
  - GenerateTops() to retrieve from tile_tops.png graphic only the straight sections making up the top border of the tiles
]]

function GenerateQuads(atlas, tileWidth, tileHeight)
  -- retrieve the number of tiles to be created horizontally
  local sheetWidth = atlas:getWidth() / tileWidth
  -- retrieve the number of tiles to be created vertically
  local sheetHeight = atlas:getHeight() / tileHeight

  -- initialize a counter variable used for the field of each quad
  local sheetCounter = 1
  -- initialize an empty table in which to insert each quad
  local spritesheet = {}

  -- loop through the tiles of the image
  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      -- add to the table and in the field specified by sheetCounter the quad matching the coordinates specified by x and y
      spritesheet[sheetCounter] = love.graphics.newQuad(
        -- the quads have all the same height and width, but differ in the coordinate as to describe progressively the following rectangles
        x * tileWidth,
        y * tileHeight,
        tileWidth,
        tileHeight,
        atlas:getDimensions() -- object returned from the image to-be-sectioned
      )

      -- increment the counter to target the following rectangle
      sheetCounter = sheetCounter + 1

    end
  end

  --[[
    return the spritesheet, which is now a table structured like so
    {
      [1] = quad for the first rectangle in the top left corner
      [2] = quad right next to the top left corner
      and so forth ond so on, one row at a time
    }
  ]]
  return spritesheet
end

-- function extracting the tiles making up solid squares for the ground
function GenerateTiles(atlas)
  -- each tile is 16x16 in size
  local tileSize = 16
  -- create a table of 16x16 quads from the input image
  local tileQuads = GenerateQuads(atlas, tileSize, tileSize)

  -- given the size the solid square can be drawn from the 61st quad
  -- incrementing the tile horizontally by 5 (after 5 cells)
  -- vertically by 90 (after three rows worth of cells),
  local tileIndex = 61
  -- variable to index each tile starting from 1
  local tileCounter = 1
  -- table detailing the tiles
  local tiles = {}

  -- add immediately the quad making up the 5th cell, for the sky
  tiles[tileCounter] = tileQuads[5]
  tileCounter = tileCounter + 1

  -- 10 instances vertically
  for y = 1, 10 do
    -- 6 instances horizontally
    for x = 1, 6 do
      tiles[tileCounter] = tileQuads[tileIndex]
      -- retrieve the following tile in the same row
      tileIndex = tileIndex + 5
      tileCounter = tileCounter + 1
    end
    -- go three rows down
    tileIndex = tileIndex + 90
  end

  -- return the table
  return tiles
end


-- function extracting the top of the tiles to cover the first layer of ground tiles
function GenerateTops(atlas)
  -- similar reasoning to GenerateTiles, but with different starting value
  local topSize = 16
  local topQuads = GenerateQuads(atlas, topSize, topSize)

  local topIndex = 1
  local topCounter = 1

  local tops = {}

  -- 18 instances vertically
  for y = 1, 18 do
    -- 6 instances horizontally
    for x = 1, 6 do
      tops[topCounter] = topQuads[topIndex]
      topIndex = topIndex + 5
      topCounter = topCounter + 1
    end

    topIndex = topIndex + 90
  end

  return tops
end