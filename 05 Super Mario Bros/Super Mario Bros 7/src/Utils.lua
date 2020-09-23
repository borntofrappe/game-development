function GenerateQuads(atlas, tileWidth, tileHeight)
  local sheetWidth = atlas:getWidth() / tileWidth
  local sheetHeight = atlas:getHeight() / tileHeight

  local counter = 1
  local spritesheet = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      local sprite = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
      spritesheet[counter] = sprite
      counter = counter + 1
    end
  end

  return spritesheet
end

function GenerateQuadsTiles(atlas)
  local quads = {}

  local columns = 6
  local rows = 10
  local x = 0
  local y = 0
  local width = 80
  local height = 64

  local columns_tiles = 5
  local rows_tiles = 4
  local x_tiles = 0
  local y_tiles = 0
  local width_tiles = 16
  local height_tiles = 16

  for column = 1, columns do
    y = 0
    for row = 1, rows do
      quads[(column - 1) * rows + row] = {}
      x_tiles = 0
      y_tiles = 0
      for row_tiles = 1, rows_tiles do
        x_tiles = 0
        for column_tiles = 1, columns_tiles do
          quads[(column - 1) * rows + row][(row_tiles - 1) * columns_tiles + column_tiles] =
            love.graphics.newQuad(x + x_tiles, y + y_tiles, width_tiles, height_tiles, atlas:getDimensions())
          x_tiles = x_tiles + width_tiles
        end
        y_tiles = y_tiles + height_tiles
      end
      y = y + height
    end
    x = x + width
  end

  return quads
end

function GenerateQuadsTileTops(atlas)
  local quads = {}

  local columns = 6
  local rows = 18
  local x = 0
  local y = 0
  local width = 80
  local height = 64

  local columns_tiles = 5
  local rows_tiles = 4
  local x_tiles = 0
  local y_tiles = 0
  local width_tiles = 16
  local height_tiles = 16

  for column = 1, columns do
    y = 0
    for row = 1, rows do
      quads[(column - 1) * rows + row] = {}
      x_tiles = 0
      y_tiles = 0
      for row_tiles = 1, rows_tiles do
        x_tiles = 0
        for column_tiles = 1, columns_tiles do
          quads[(column - 1) * rows + row][(row_tiles - 1) * columns_tiles + column_tiles] =
            love.graphics.newQuad(x + x_tiles, y + y_tiles, width_tiles, height_tiles, atlas:getDimensions())
          x_tiles = x_tiles + width_tiles
        end
        y_tiles = y_tiles + height_tiles
      end
      y = y + height
    end
    x = x + width
  end

  return quads
end

function GenerateQuadsObjects(atlas, width, height)
  local quads = {}
  local x = 0
  local y = 0

  local colors = math.floor(atlas:getHeight() / height)
  local varieties = math.floor(atlas:getWidth() / width)

  for i = 1, colors do
    quads[i] = {}
    x = 0
    for j = 1, varieties do
      quads[i][j] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
      x = x + width
    end
    y = y + height
  end

  return quads
end
