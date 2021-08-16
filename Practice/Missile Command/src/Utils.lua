function GenerateQuadsStructures(atlas)
  local quads = {}

  for i = 1, math.floor(atlas:getWidth() / STRUCTURE_WIDTH) do
    table.insert(
      quads,
      love.graphics.newQuad((i - 1) * STRUCTURE_WIDTH, 0, STRUCTURE_WIDTH, STRUCTURE_HEIGHT, atlas:getDimensions())
    )
  end

  return quads
end

function GenerateQuadMissile(atlas)
  return love.graphics.newQuad(77, 0, MISSILE_WIDTH, MISSILE_HEIGHT, atlas:getDimensions())
end
