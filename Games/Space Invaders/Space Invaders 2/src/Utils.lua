function GenerateQuadPlayer(atlas)
  local x = 0
  local y = 81
  local width = 27
  local height = 21
  return love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
end

function GenerateQuadsAliens(atlas)
  local quads = {}
  local x = 0
  local y = 0
  local width = 24
  local height = 21

  for i = 1, 3 do
    x = 0
    quads[i] = {}
    for j = 1, 2 do
      quads[i][j] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
      x = x + width
    end
    y = y + height
  end

  return quads
end
