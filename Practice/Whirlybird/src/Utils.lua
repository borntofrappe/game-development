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

function GenerateQuadsSprites(atlas)
  local quads = {}

  for i = 1, SPRITES.types do
    quads[i] = {}
    for j = 1, SPRITES.frames do
      quads[i][j] =
        love.graphics.newQuad(
        (j - 1) * SPRITES.width,
        (i - 1) * SPRITES.height,
        SPRITES.width,
        SPRITES.height,
        atlas:getDimensions()
      )
    end
  end

  return quads
end

function GenerateQuadsMarks(atlas)
  local quads = {}

  for i = 1, MARKS.types do
    quads[i] = love.graphics.newQuad((i - 1) * MARKS.width, MARKS.y, MARKS.width, MARKS.height, atlas:getDimensions())
  end

  return quads
end

function GenerateQuadButton(atlas)
  return love.graphics.newQuad(0, BUTTON.y, BUTTON.width, BUTTON.height, atlas:getDimensions())
end
