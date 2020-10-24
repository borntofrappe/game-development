DescriptionList = {}
DescriptionList.__index = DescriptionList

function DescriptionList:new(def)
  local def =
    def or
    {
      ["term"] = "Term",
      ["description"] = "Description"
    }

  this = {
    ["term"] = def.term,
    ["description"] = def.description,
    ["x"] = def.x,
    ["y"] = def.y,
    ["width"] = def.width,
    ["height"] = def.height,
    ["padding"] = def.padding,
    ["panel"] = Panel:new(
      {
        ["x"] = def.x,
        ["y"] = def.y,
        ["width"] = def.width,
        ["height"] = def.height,
        ["padding"] = def.padding
      }
    )
  }

  setmetatable(this, self)
  return this
end

function DescriptionList:render()
  self.panel:render()

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0.07, 0.07, 0.07)
  love.graphics.print(self.term, self.x + self.padding, self.y + self.padding)

  love.graphics.printf(
    self.description,
    self.x + self.padding,
    self.y + self.height - self.padding - gFonts["normal"]:getHeight(),
    self.width - self.padding * 2,
    "right"
  )
end
