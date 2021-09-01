function GenerateQuadsPlayer(atlas)
  local x = 0
  local y = 8
  --[[
    1 default
    2,3 walking
    4 shooting
    5 losing
  ]]
  local types = 5

  local quads = {}

  for i = 1, types do
    table.insert(
      quads,
      love.graphics.newQuad(x + (i - 1) * SPRITE_SIZE, y, SPRITE_SIZE, SPRITE_SIZE, atlas:getDimensions())
    )
  end

  return quads
end
