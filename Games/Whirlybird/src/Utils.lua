function GenerateQuadsPlayer(atlas)
  local quads = {}

  local x = 0
  local y = 0
  local width = PLAYER_WIDTH
  local height = PLAYER_HEIGHT

  quads[1] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())

  x = x + width
  width = PLAYER_FLYING_WIDTH
  height = PLAYER_FLYING_HEIGHT

  for i = 2, 4 do
    quads[i] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
    x = x + width
  end

  width = PLAYER_FALLING_WIDTH
  height = PLAYER_FALLING_HEIGHT

  for i = 5, 6 do
    quads[i] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
    x = x + width
  end

  return quads
end

function GenerateQuadsInteractables(atlas)
  local x = 0
  local y = 60

  local width = INTERACTABLE_WIDTH
  local heights = INTERACTABLE_HEIGHTS

  local varieties = 4

  local quads = {}

  for i = 1, #heights do
    quads[i] = {}
    x = 0
    local height = heights[i]
    for j = 1, varieties do
      quads[i][j] = love.graphics.newQuad(x, y, INTERACTABLE_WIDTH, height, atlas:getDimensions())
      x = x + width
    end
    y = y + height
  end

  return quads
end

function GenerateQuadsParticles(atlas)
  local x = 198
  local y = 45
  local varieties = 6

  local quads = {}

  for i = 1, varieties do
    quads[i] = love.graphics.newQuad(x, y, PLAYER_PARTICLES_WIDTH, PLAYER_PARTICLES_HEIGHT, atlas:getDimensions())
    y = y + PLAYER_PARTICLES_HEIGHT
  end

  return quads
end

function GenerateQuadsHat(atlas)
  local x = 0
  local y = 42
  local width = 21
  local height = 18
  local varieties = 4

  local quads = {}

  for i = 1, varieties do
    quads[i] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
    x = x + width
  end

  return quads
end
