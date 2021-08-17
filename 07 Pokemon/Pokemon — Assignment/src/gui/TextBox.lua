TextBox = Class {}

function TextBox:init(def)
  local def = def or {}

  self.chunks = def.chunks or {"MISSING CHUNK"}
  self.chunk = def.chunk or 1

  self.callback = def.callback or function()
      self:hide()
    end

  self.x = def.x or 4
  self.y = def.y or 4
  self.padding = def.padding or 4

  self.width = def.width or VIRTUAL_WIDTH - 8
  self.height = def.height

  if not self.height then
    local maxLines = 1
    for i, t in ipairs(self.chunks) do
      local _, lines = t:gsub("\n", "")

      if (lines + 1) > maxLines then
        maxLines = (lines + 1)
      end
    end
    self.height = gFonts["small"]:getHeight() * maxLines + 8
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
      ["x"] = self.x,
      ["y"] = self.y,
      ["width"] = self.width,
      ["height"] = self.height
    }
  )

  self.showTextBox = true
end

function TextBox:next()
  if self.chunk == #self.chunks then
    self.callback()
  else
    self.chunk = self.chunk + 1
  end
end

function TextBox:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gSounds["blip"]:play()
    self:next()
  end
end

function TextBox:render()
  if self.showTextBox then
    self.panel:render()

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.print(self.chunks[self.chunk], self.x + self.padding, self.y + self.padding)
  end
end

function TextBox:show()
  self.chunk = 1
  self.showTextBox = true
end

function TextBox:hide()
  self.showTextBox = false
end
