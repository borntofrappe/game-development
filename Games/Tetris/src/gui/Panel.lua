Panel = {}
Panel.__index = Panel

function Panel:new(def)
  local def =
    def or
    {
      ["column"] = 1,
      ["row"] = 1,
      ["width"] = 1,
      ["height"] = 1
    }
  this = {
    ["column"] = def.column,
    ["row"] = def.row,
    ["width"] = def.width,
    ["height"] = def.height
  }

  setmetatable(this, self)
  return this
end

function Panel:render()
  love.graphics.setLineWidth(5)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle(
    "line",
    (self.column - 1) * TILE_SIZE,
    (self.row - 1) * TILE_SIZE,
    self.width * TILE_SIZE,
    self.height * TILE_SIZE,
    8
  )
  love.graphics.setColor(
    gColors["background"].r,
    gColors["background"].g,
    gColors["background"].b,
    gColors["background"].a
  )
  love.graphics.rectangle(
    "fill",
    (self.column - 1) * TILE_SIZE,
    (self.row - 1) * TILE_SIZE,
    self.width * TILE_SIZE,
    self.height * TILE_SIZE,
    8
  )
end
