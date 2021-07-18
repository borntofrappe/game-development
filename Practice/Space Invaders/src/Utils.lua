function GenerateQuadsInvaders(atlas)
  local quads = {}

  local X_INITIAL = 0
  local Y_INITIAL = 0
  local WIDTH = INVADER_WIDTH
  local HEIGHT = INVADER_HEIGHT

  for type = 1, INVADER_TYPES do
    quads[type] = {}
    local y = (type - 1) * HEIGHT
    for frame = 1, INVADER_FRAMES do
      local x = (frame - 1) * WIDTH
      quads[type][frame] = love.graphics.newQuad(X_INITIAL + x, Y_INITIAL + y, WIDTH, HEIGHT, atlas:getDimensions())
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

function GenerateQuadCollisionInvader(atlas)
  local X_INITIAL = 48
  local Y_INITIAL = 0
  local WIDTH = COLLISION_INVADER_WIDTH
  local HEIGHT = COLLISION_INVADER_HEIGHT

  return love.graphics.newQuad(X_INITIAL, Y_INITIAL, WIDTH, HEIGHT, atlas:getDimensions())
end
