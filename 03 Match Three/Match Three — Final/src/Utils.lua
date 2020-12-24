function GenerateQuadsTiles(atlas)
  local quads = {}

  local x = 0
  local y = 0
  local width = 32
  local height = 32

  local colors = 18
  local varieties = 6

  for i = 1, colors do
    x = i > colors / 2 and width * varieties or 0
    table.insert(quads, {})
    for j = 1, varieties do
      table.insert(quads[i], love.graphics.newQuad(x, y, width, height, atlas:getDimensions()))
      x = x + width
    end
    y = i == colors / 2 and 0 or y + height
  end

  return quads
end
