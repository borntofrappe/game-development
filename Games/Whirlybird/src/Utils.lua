function GenerateQuadPlayer(atlas)
  return love.graphics.newQuad(0, 0, PLAYER_WIDTH, PLAYER_HEIGHT, atlas:getDimensions())
end

function GenerateQuadsInteractables(atlas)
  local x = 0
  local y = 60

  local width = INTERACTABLE_WIDTH
  local heights = INTERACTABLE_HEIGHTS

  local types = 4

  local quads = {}

  for i = 1, #heights do
    quads[i] = {}
    x = 0
    local height = heights[i]
    for j = 1, types do
      quads[i][j] = love.graphics.newQuad(x, y, INTERACTABLE_WIDTH, height, atlas:getDimensions())
      x = x + width
    end
    y = y + height
  end

  return quads
end
