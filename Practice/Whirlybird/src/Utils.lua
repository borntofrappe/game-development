function GenerateQuadsPlayer(atlas)
  local quads = {}

  local x = 0
  local y = 0

  for i, type in ipairs(PLAYER.data) do
    for j, variety in ipairs(type.varieties) do
      quads[variety] = love.graphics.newQuad(x, y, type.width, type.height, atlas:getDimensions())
      x = x + type.width
    end
  end

  return quads
end
