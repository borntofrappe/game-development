Cell = {}
Cell.__index = Cell

function Cell:new(def)
  local def =
    def or
    {
      ["column"] = 1,
      ["row"] = 1,
      ["isEven"] = false,
      ["hasMine"] = false,
      ["neighborsWithMine"] = 0
    }

  local version = def.isEven and "light" or "dark"
  local size = CELL_SIZE

  this = {
    ["column"] = def.column,
    ["row"] = def.row,
    ["version"] = version,
    ["size"] = size,
    ["isRevealed"] = true,
    ["hasMine"] = def.hasMine,
    ["neighborsWithMine"] = def.neighborsWithMine
  }

  setmetatable(this, self)
  return this
end

function Cell:render()
  if self.isRevealed then
    if self.hasMine then
      love.graphics.setColor(gColors["mine"].r, gColors["mine"].g, gColors["mine"].b)
      love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
      love.graphics.setColor(0, 0, 0, 0.25)
      love.graphics.circle(
        "fill",
        (self.column - 1) * self.size + self.size / 2,
        (self.row - 1) * self.size + self.size / 2,
        self.size / 5
      )
    else
      love.graphics.setColor(
        gColors["cell-revealed-" .. self.version].r,
        gColors["cell-revealed-" .. self.version].g,
        gColors["cell-revealed-" .. self.version].b
      )
      love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)

      if self.neighborsWithMine > 0 then
        local version = math.min(self.neighborsWithMine, 3)
        love.graphics.setFont(gFonts["bold"])
        love.graphics.setColor(
          gColors["number-" .. version].r,
          gColors["number-" .. version].g,
          gColors["number-" .. version].b
        )
        love.graphics.printf(
          self.neighborsWithMine,
          (self.column - 1) * self.size,
          (self.row - 1) * self.size + self.size / 2 - gFonts["bold"]:getHeight() / 2,
          self.size,
          "center"
        )
      end
    end
  else
    love.graphics.setColor(
      gColors["cell-" .. self.version].r,
      gColors["cell-" .. self.version].g,
      gColors["cell-" .. self.version].b
    )
    love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
  end
end
