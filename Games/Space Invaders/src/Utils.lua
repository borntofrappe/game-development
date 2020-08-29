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
  local width = ALIEN_WIDTH
  local height = ALIEN_HEIGHT

  for i = 1, 3 do
    x = 0
    quads[i] = {}
    for j = 1, 2 do
      quads[i][j] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
      x = x + width
    end
    y = y + height
  end

  x = 0
  y = 63
  width = 39
  height = 18

  quads[4] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())

  return quads
end

function GenerateQuadBullet(atlas)
  local x = 29
  local y = 87
  local width = 3
  local height = 15
  return love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
end

function GenerateQuadsParticles(atlas)
  local quads = {}
  local x = 48
  local y = 0
  local width = 24
  local height = 21

  for i = 1, 3 do
    quads[i] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
    y = y + height
  end

  x = 42
  y = 66
  width = 30
  height = 18

  for i = 4, 5 do
    quads[i] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
    y = y + height
  end

  return quads
end
