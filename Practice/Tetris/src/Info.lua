Info = {}

function Info:new()
  local columnStart = PADDING_COLUMNS + BORDER_COLUMNS * 2 + GRID_COLUMNS
  local rowStart = 0

  local x = CELL_SIZE * columnStart
  local y = CELL_SIZE * rowStart

  local width = CELL_SIZE * (INFO_COLUMNS + PADDING_COLUMNS)
  local height = CELL_SIZE * GRID_ROWS

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
