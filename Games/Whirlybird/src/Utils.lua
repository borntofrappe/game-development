function GenerateQuadPlayer(atlas)
  return love.graphics.newQuad(0, 0, PLAYER_WIDTH, PLAYER_HEIGHT, atlas:getDimensions())
end

function GenerateQuadsPlatforms(atlas)
  local quads = {}

  for i = 1, 4 do
    quads[i] =
      love.graphics.newQuad(39, 39 + (i - 1) * PLATFORM_HEIGHT, PLATFORM_WIDTH, PLATFORM_HEIGHT, atlas:getDimensions())
  end

  return quads
end
