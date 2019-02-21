--[[
  utility functions
  - GenerateQuads() to create quads from the sprite image
  - table.slice to section a table in smaller chunks
  - GenerateQuadsPaddles() to identify the paddles
  - GenerateQuadsBalls() to identify the balls
  - GenerateQuadsBricks() to identify the bricks
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



function table.slice(tbl, first, last, step)
  -- initialize a variable in which to describe the sub section of the table
  local sliced = {}

  --[[
    loop from first to last, at an interval described by step, with the following default values

    first: 1
    last: length of the table
    step: 1

    the length of a table is found by prefacing the name with a `#` pound sign

    #tablename

    a default value can be dictated through the `or` keyword
  ]]
  for i = first or 1, last or #tbl, step or 1 do
    -- add to the sliced table the specified quad
    -- each expanding the sliced table by targeting the index following its length
    sliced[#sliced+1] = tbl[i]
  end

  -- return the subset of the table, identifying the necessary quads
  return sliced
end



function GenerateQuadsPaddles(atlas)
  -- describe the starting coordinates of the paddle
  local x = 0
  local y = 64

  -- initialize a counter variable to identify as many paddles as there are in the sprite image
  local counter = 1
  -- initialize a table in which to describe the quads (much alike GenerateQuads)
  local quads = {}

  -- repeat the logic as there are paddles (four different color)
  for i = 0, 3 do
    -- for each counter variable add a field in the quads describing each paddle (four sizes for the different four colors)
    -- small
    quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
    counter = counter + 1

    -- each time add to the x or y coordinate to identify the different sprites
    -- medium
    quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
    counter = counter + 1

    -- 96 as 32 + 64 (where the previous paddle ends)
    -- large
    quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
    counter = counter + 1

    -- the largest paddle being in a new row
    -- huge
    quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
    counter = counter + 1

    -- reset x to start from the left
    x = 0
    -- set y to find the new row
    y = y + 32
  end

  -- return the table of paddles (16 paddles total, for the paddle of solid blue, gree, red, purple)
  return quads
end


function GenerateQuadsBalls(atlas)
  -- describe the starting coordinates of the balls
  -- described in two rows, each 8px wide and tall
  -- 4 balls in the first row, 3 in the second (the second being 48+8px from the top)
  local x = 96
  local y = 48

  -- initialize a counter variable to identify as many balls as there are in the sprite image
  local counter = 1
  -- initialize a table in which to describe the quads
  local quads = {}

  -- for the first row, target the 4 balls side by side
  for i = 0, 3 do
    -- blue
    quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    -- green
    quads[counter] = love.graphics.newQuad(x + 8, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    -- red
    quads[counter] = love.graphics.newQuad(x + 16, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    -- pink
    quads[counter] = love.graphics.newQuad(x + 24, y, 8, 8, atlas:getDimensions())
    counter = counter + 1
  end

  -- move toward the second row, and back to the horizontal coordinate
  y = y + 8
  x = 96

  -- for the second row, targe the 3 balls side by side
  for i = 0, 2 do
    -- yellow
    quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    -- grey
    quads[counter] = love.graphics.newQuad(x + 8, y, 8, 8, atlas:getDimensions())
    counter = counter + 1

    -- orange
    quads[counter] = love.graphics.newQuad(x + 16, y, 8, 8, atlas:getDimensions())
    counter = counter + 1
  end

  -- return the table of balls (7 in total)
  return quads
end



function GenerateQuadsBricks(atlas)
  -- the bricks are retrieved from the beginning of the breakout image
  -- slicing the table making up the quads
  -- 32 and 15 being the size of the bricks
  -- 21 being the number of bricks
  return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end


function GenerateQuadsPowerups(atlas)
  -- the powerups are retrieved from the last row of the breakout image
  -- slicing the table making up the quads
  -- 16 and 16 being the size of the powerups
  -- 145 being the tile at which the powerups begin
  -- 154 where they end (10 tiles)
  return table.slice(GenerateQuads(atlas, 16, 16), 145, 154, 1)
end


