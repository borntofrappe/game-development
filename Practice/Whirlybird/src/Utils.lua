function GenerateQuadsPlayer(atlas)
  local quads = {}

  for k, state in pairs(PLAYER) do
    quads[k] = {}
    for frame = 1, state.frames do
      quads[k][frame] =
        love.graphics.newQuad(
        state.x + (frame - 1) * state.width,
        state.y,
        state.width,
        state.height,
        atlas:getDimensions()
      )
    end
  end

  return quads
end

function GenerateQuadsInteractables(atlas)
  local quads = {}

  for k, interactable in pairs(INTERACTABLES) do
    quads[k] = {}
    for frame = 1, interactable.frames do
      quads[k][frame] =
        love.graphics.newQuad(
        interactable.x + (frame - 1) * interactable.width,
        interactable.y,
        interactable.width,
        interactable.height,
        atlas:getDimensions()
      )
    end
  end

  return quads
end

function GenerateQuadsParticles(atlas)
  local quads = {}

  for i = 1, PARTICLES.frames do
    quads[i] =
      love.graphics.newQuad(
      PARTICLES.x,
      PARTICLES.y + (i - 1) * PARTICLES.height,
      PARTICLES.width,
      PARTICLES.height,
      atlas:getDimensions()
    )
  end

  return quads
end

function GenerateQuadsHat(atlas)
  local quads = {}

  for i = 1, HAT.frames do
    quads[i] = love.graphics.newQuad((i - 1) * HAT.width, HAT.y, HAT.width, HAT.height, atlas:getDimensions())
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
