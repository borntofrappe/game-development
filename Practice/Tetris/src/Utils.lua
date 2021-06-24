function GenerateQuads(atlas, tileWidth, tileHeight)
  local quads = {}
  local columns = math.floor(atlas:getWidth() / tileWidth)
  local rows = math.floor(atlas:getHeight() / tileHeight)

  for row = 1, rows do
    for column = 1, columns do
      local x = (column - 1) * tileWidth
      local y = (row - 1) * tileHeight
      quads[#quads + 1] = love.graphics.newQuad(x, y, tileWidth, tileHeight, atlas:getDimensions())
    end
  end

  return quads
end
