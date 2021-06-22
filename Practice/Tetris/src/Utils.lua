function GenerateQuads(atlas, tileWidth, tileHeight)
  local quads = {}
  local columns = math.floor(atlas:getWidth() / tileWidth)
  local rows = math.floor(atlas:getHeight() / tileHeight)

  for r = 1, rows do
    for c = 1, columns do
      local x = (c - 1) * tileWidth
      local y = (r - 1) * tileHeight
      quads[#quads + 1] = love.graphics.newQuad(x, y, tileWidth, tileHeight, atlas:getDimensions())
    end
  end

  return quads
end
