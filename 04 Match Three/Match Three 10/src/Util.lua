--[[
  utility function(s)
  - GenerateQuads() to create quads from a sprite image, given a width and a height
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