Cell = {}

function Cell:new(def)
  local def =
    def or
    {
      ["column"] = 1,
      ["row"] = 1,
      ["isDark"] = true,
      ["hasMine"] = false
    }

  local this = {
    ["column"] = def.column,
    ["row"] = def.row,
    ["x"] = (def.column - 1) * CELL_SIZE,
    ["y"] = (def.row - 1) * CELL_SIZE,
    ["size"] = CELL_SIZE,
    ["isRevealed"] = false,
    ["version"] = def.isDark and "dark" or "light",
    ["hasMine"] = def.hasMine,
    ["neighboringMines"] = 0,
    ["isFlagged"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Cell:render()
  if self.isRevealed then
    if self.hasMine then
      love.graphics.setColor(COLORS["mine"].r, COLORS["mine"].g, COLORS["mine"].b)
      love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
      love.graphics.setColor(0, 0, 0, 0.25)
      love.graphics.circle("fill", self.x + self.size / 2, self.y + self.size / 2, self.size / 5)
    else
      love.graphics.setColor(
        COLORS["cell-revealed-" .. self.version].r,
        COLORS["cell-revealed-" .. self.version].g,
        COLORS["cell-revealed-" .. self.version].b
      )
      love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)

      if self.neighboringMines > 0 then
        love.graphics.setFont(FONTS["bold"])
        love.graphics.setColor(
          COLORS["number-" .. math.min(3, self.neighboringMines)].r,
          COLORS["number-" .. math.min(3, self.neighboringMines)].g,
          COLORS["number-" .. math.min(3, self.neighboringMines)].b
        )

        love.graphics.printf(
          self.neighboringMines,
          self.x,
          self.y + self.size / 2 - FONTS["bold"]:getHeight() / 2,
          self.size,
          "center"
        )
      end
    end
  else
    love.graphics.setColor(
      COLORS["cell-" .. self.version].r,
      COLORS["cell-" .. self.version].g,
      COLORS["cell-" .. self.version].b
    )
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)

    if self.isFlagged then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(
        TEXTURES["flag"],
        self.x + self.size / 2 - TEXTURES["flag"]:getWidth() / 2,
        self.y + self.size / 2 - TEXTURES["flag"]:getHeight() / 2
      )
    end
  end
end
