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

function GenerateQuadsEntities(atlas)
  local varietiesMovement = 3
  local directions = {"down", "left", "right", "up"}

  local quads = {}
  local counter = 1

  local characterColumns = math.floor(atlas:getWidth() / TILE_SIZE / varietiesMovement)
  local characterRows = math.floor(atlas:getHeight() / TILE_SIZE / #directions)

  for characterRow = 1, characterRows do
    for characterColumn = 1, characterColumns do
      quads[counter] = {}
      for i, direction in ipairs(directions) do
        quads[counter][direction] = {}
        for j = 1, varietiesMovement do
          quads[counter][direction][j] =
            love.graphics.newQuad(
            (j - 1) * TILE_SIZE + (characterColumn - 1) * TILE_SIZE * varietiesMovement,
            (i - 1) * TILE_SIZE + (characterRow - 1) * TILE_SIZE * #directions,
            TILE_SIZE,
            TILE_SIZE,
            atlas:getDimensions()
          )
        end
      end
      counter = counter + 1
    end
  end

  return quads
end
