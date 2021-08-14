function GenerateQuadsStructures(atlas)
  local quads = {}

  for i = 1, math.floor(atlas:getWidth() / STRUCTURE_SIZE) do
    table.insert(
      quads,
      love.graphics.newQuad((i - 1) * STRUCTURE_SIZE, 0, STRUCTURE_SIZE, STRUCTURE_SIZE, atlas:getDimensions())
    )
  end

  return quads
end

function GenerateQuadMissile(atlas)
  return love.graphics.newQuad(67, 0, 16, 13, atlas:getDimensions())
end
