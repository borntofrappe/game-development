TextBox = {}

local MARGIN = 2
local PADDING = 3

function TextBox:new(text)
  local text = text or string.upper("Missing text")
  local _, newLineCharacters = text:gsub("\n", "")
  local width = VIRTUAL_WIDTH - MARGIN * 2
  local height = gFont:getHeight() * (newLineCharacters + 1) + PADDING * 2 - 1 -- -1 for a font-specific pixel adjustment
  local x = MARGIN
  local y = VIRTUAL_HEIGHT - MARGIN - height
  local fill = {
    ["r"] = 0.173,
    ["g"] = 0.11,
    ["b"] = 0.106
  }

  local panel = Panel:new(x, y, width, height, fill)

  local this = {
    ["panel"] = panel,
    ["x"] = x + PADDING,
    ["y"] = y + PADDING,
    ["width"] = width - PADDING * 2,
    ["height"] = height - PADDING * 2,
    ["text"] = text
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function TextBox:render()
  self.panel:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(self.text, self.x, self.y, self.width, "left")
end
