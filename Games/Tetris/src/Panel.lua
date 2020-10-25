Panel = {}
Panel.__index = Panel

function Panel:new(def)
  local def =
    def or
    {
      ["x"] = 16,
      ["y"] = 16,
      ["width"] = TILE_SIZE * 5,
      ["height"] = TILE_SIZE * 3,
      ["padding"] = 8
    }
  this = {
    ["x"] = def.x,
    ["y"] = def.y,
    ["width"] = def.width,
    ["height"] = def.height,
    ["padding"] = def.padding
  }

  setmetatable(this, self)
  return this
end

function Panel:render()
  love.graphics.setLineWidth(5)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 8)
  love.graphics.setColor(
    gColors["background"].r,
    gColors["background"].g,
    gColors["background"].b,
    gColors["background"].a
  )
  love.graphics.rectangle("fill", self.x + 1, self.y + 1, self.width - 2, self.height - 2, 8)
end
