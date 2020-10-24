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
  love.graphics.setLineWidth(6)
  love.graphics.setColor(0.07, 0.05, 0)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 8)
  love.graphics.setColor(0.15, 0.1, 0.08)
  love.graphics.rectangle("fill", self.x + 2, self.y + 2, self.width - 4, self.height - 4, 8)
end
