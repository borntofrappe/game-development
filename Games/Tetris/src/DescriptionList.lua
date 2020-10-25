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
    ["column"] = def.column,
    ["row"] = def.row,
    ["width"] = def.width,
    ["height"] = def.height,
    ["padding"] = 8,
    ["panel"] = Panel:new(
      {
        ["column"] = def.column,
        ["row"] = def.row,
        ["width"] = def.width,
        ["height"] = def.height
      }
    )
  }

  setmetatable(this, self)
  return this
end

function DescriptionList:render()
  self.panel:render()

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.print(
    self.term,
    (self.column - 1) * TILE_SIZE + self.padding,
    (self.row - 1) * TILE_SIZE + self.padding
  )

  love.graphics.printf(
    self.description,
    (self.column - 1) * TILE_SIZE - self.padding,
    (self.row - 1 + self.height) * TILE_SIZE - gFonts["normal"]:getHeight() - self.padding,
    self.width * TILE_SIZE,
    "right"
  )
end
