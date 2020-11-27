Grid = {}
Grid.__index = Grid

function Grid:new()
  local rings = RINGS
  local ringsCount = RINGS_COUNT
  local radius = math.floor((math.min(WINDOW_WIDTH, WINDOW_HEIGHT) - PADDING) / 2)
  local angle = 2 * math.pi / ringsCount

  local cells = {}

  for ring = 1, rings do
    cells[ring] = {}

    local innerRadius = (ring - 1) * radius / rings
    local outerRadius = ring * radius / rings

    for ringCount = 1, ringsCount do
      local angleStart = (ringCount - 1) * angle
      local angleEnd = ringCount * angle
      cells[ring][ringCount] = Cell:new(ring, ringCount, innerRadius, outerRadius, angleStart, angleEnd)
    end
  end

  this = {
    ["rings"] = rings,
    ["radius"] = radius,
    ["angle"] = angle,
    ["cells"] = cells
  }

  setmetatable(this, self)
  return this
end

function Grid:render()
  love.graphics.setColor(0.99, 0.99, 0.99)
  love.graphics.setLineWidth(2)

  for ring = 1, self.rings do
    for i, cell in ipairs(self.cells[ring]) do
      cell:render()
    end
  end
end
