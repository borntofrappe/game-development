function GenerateQuadsInvaders(atlas)
  local quads = {}

  local WIDTH = INVADER_WIDTH
  local HEIGHT = INVADER_HEIGHT

  for i = 1, INVADERS do
    quads[i] = {}
    local y = (i - 1) * HEIGHT
    for j = 1, VARIETIES do
      local x = (j - 1) * WIDTH
      quads[i][j] = love.graphics.newQuad(x, y, WIDTH, HEIGHT, atlas:getDimensions())
    end
  end

  return quads
end

function GenerateQuadBonusInvader(atlas)
  local WIDTH = INVADER_BONUS_WIDTH
  local HEIGHT = INVADER_BONUS_HEIGHT
  local Y_INITIAL = INVADERS * INVADER_HEIGHT

  return love.graphics.newQuad(0, Y_INITIAL, WIDTH, HEIGHT, atlas:getDimensions())
end
