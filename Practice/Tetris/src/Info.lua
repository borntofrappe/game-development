Info = {}

function Info:new()
  local width = CELL_SIZE * INFO_COLUMNS
  local height = CELL_SIZE * ROWS

  local info = {
    {["label"] = "Score", ["value"] = 0},
    {["label"] = "Level", ["value"] = 1},
    {["label"] = "Lines", ["value"] = 0}
  }

  local maxWidth = 0
  for i, detail in ipairs(info) do
    detail.label = detail.label:upper()
    local width = gFont:getWidth(detail.label)
    if width > maxWidth then
      maxWidth = width
    end
  end

  local boxWidth = maxWidth * 2
  local boxHeight = gFont:getHeight() * 2 + gFont:getHeight()

  local boxX = math.floor(width / 2 - boxWidth / 2)
  local boxY = CELL_SIZE / 2

  local infoboxes = {}
  for i, detail in ipairs(info) do
    infoboxes[detail.label:lower()] = Infobox:new(detail.label, detail.value, boxX, boxY, boxWidth, boxHeight)
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
  for k, infobox in pairs(self.infoboxes) do
    infobox:render()
  end
end
