TextBox = Class {}

function TextBox:init(def)
  local def = def or {}

  self.text = def.text or {"MISSING TEXT"}
  self.chunk = def.chunk or 1

  self.callback = def.callback or function()
    end

  self.x = def.x or 4
  self.y = def.y or 4
  self.padding = def.padding or 4

  self.width = def.width or VIRTUAL_WIDTH - 8
  self.height = def.height

  if not self.height then
    local maxLines = 1
    for i, t in ipairs(self.text) do
      local lines = 1
      for n in string.gmatch(t, "\n") do
        lines = lines + 1
      end
      if lines > maxLines then
        maxLines = lines
      end
    end
    self.height = 16 * maxLines + 8
  end

  self.font = def.font or gFonts["small"]
  self.color =
    def.color or
    {
      ["r"] = 1,
      ["g"] = 1,
      ["b"] = 1
    }

  self.panel =
    Panel(
    {
      x = self.x,
      y = self.y,
      width = self.width,
      height = self.height
    }
  )
end

function TextBox:next()
  if self.chunk == #self.text then
    self.callback()
  else
    self.chunk = self.chunk + 1
  end
end

function TextBox:render()
  self.panel:render()

  love.graphics.setFont(self.font)
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.print(self.text[self.chunk], self.x + self.padding, self.y + self.padding)
end
