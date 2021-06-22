Info = {}

function Info:new()
  local x = CELL_SIZE * PADDING_COLUMNS + GRID_WIDTH
  local y = 0
  local width = CELL_SIZE * LEVEL_COLUMNS + CELL_SIZE * PADDING_COLUMNS
  local height = GRID_HEIGHT

  local info = {
    {["label"] = "Score", ["value"] = 0},
    {["label"] = "Level", ["value"] = 0},
    {["label"] = "Lines", ["value"] = 0}
  }

  local maxWidth = 0
  for i, detail in ipairs(info) do
    detail.label = detail.label:upper()
    local w = gFont:getWidth(detail.label)
    if w > maxWidth then
      maxWidth = w
    end
  end

  local boxWidth = maxWidth * 2
  local boxHeight = gFont:getHeight() * 2 + gFont:getHeight()

  local boxX = math.floor(x + width / 2 - boxWidth / 2)
  local boxY = CELL_SIZE / 2

  local infoboxes = {}
  for i, detail in ipairs(info) do
    table.insert(infoboxes, Infobox:new(detail.label, detail.value, boxX, boxY, boxWidth, boxHeight))
    boxY = boxY + boxHeight * 1.1
  end

  local this = {
    ["infoboxes"] = infoboxes
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Info:render()
  for i, infobox in ipairs(self.infoboxes) do
    infobox:render()
  end
end
