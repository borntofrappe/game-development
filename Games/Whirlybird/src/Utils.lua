function GenerateQuadPlayer(atlas)
  return love.graphics.newQuad(0, 0, PLAYER_WIDTH, PLAYER_HEIGHT, atlas:getDimensions())
end
