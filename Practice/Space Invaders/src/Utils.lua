function GenerateQuadsInvaders(atlas)
  local quads = {}

  local X_INITIAL = 0
  local Y_INITIAL = 0
  local WIDTH = INVADER_WIDTH
  local HEIGHT = INVADER_HEIGHT

  for i = 1, INVADERS do
    quads[i] = {}
    local y = (i - 1) * HEIGHT
    for j = 1, VARIETIES do
      local x = (j - 1) * WIDTH
      quads[i][j] = love.graphics.newQuad(X_INITIAL + x, Y_INITIAL + y, WIDTH, HEIGHT, atlas:getDimensions())
    end
  end

  return quads
end

function GenerateQuadBonusInvader(atlas)
  local X_INITIAL = 0
  local Y_INITIAL = 63
  local WIDTH = INVADER_BONUS_WIDTH
  local HEIGHT = INVADER_BONUS_HEIGHT

  return love.graphics.newQuad(X_INITIAL, Y_INITIAL, WIDTH, HEIGHT, atlas:getDimensions())
end

function GenerateQuadPlayer(atlas)
  local X_INITIAL = 0
  local Y_INITIAL = 81
  local WIDTH = PLAYER_WIDTH
  local HEIGHT = PLAYER_HEIGHT

  return love.graphics.newQuad(X_INITIAL, Y_INITIAL, WIDTH, HEIGHT, atlas:getDimensions())
end

function GenerateQuadProjectile(atlas)
  local X_INITIAL = 29
  local Y_INITIAL = 87
  local WIDTH = PROJECTILE_WIDTH
  local HEIGHT = PROJECTILE_HEIGHT

  return love.graphics.newQuad(X_INITIAL, Y_INITIAL, WIDTH, HEIGHT, atlas:getDimensions())
end
