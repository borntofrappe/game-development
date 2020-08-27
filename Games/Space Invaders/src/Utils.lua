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

  for i = 1, 3 do
    x = 0
    quads[i] = {}
    for j = 1, 2 do
      quads[i][j] = love.graphics.newQuad(x, y, ALIEN_WIDTH, ALIEN_HEIGHT, atlas:getDimensions())
      x = x + ALIEN_WIDTH
    end
    y = y + ALIEN_HEIGHT
  end

  return quads
end

function GenerateQuadBullet(atlas)
  local x = 29
  local y = 87
  local width = 3
  local height = 15
  return love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
end

function GenerateQuadBulletParticles(atlas)
  local quads = {}
  local x = 48
  local y = 0
  local width = 24
  local height = 21

  for i = 1, 3 do
    quads[i] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
    y = y + height
  end

  return quads
end

function GenerateQuadPlayerParticles(atlas)
  local quads = {}
  local x = 48
  local y = 63
  local width = 30
  local height = 12

  for i = 1, 2 do
    quads[i] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
    y = y + height
  end

  return quads
end
