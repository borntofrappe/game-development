function GenerateQuads(atlas, width, height)
  local quads = {}
  for x = 1, math.floor(atlas:getWidth() / width) do
    for y = 1, math.floor(atlas:getHeight() / height) do
      table.insert(
        quads,
        love.graphics.newQuad((x - 1) * width, (y - 1) * height, width, height, atlas:getDimensions())
      )
    end
  end
  return quads
end
