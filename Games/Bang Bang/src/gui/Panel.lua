Panel = {}
Panel.__index = Panel

function Panel:create(x, y, width, height)
  this = {
    x = x,
    y = y,
    width = width,
    height = height
  }

  setmetatable(this, self)

  return this
end

function Panel:render()
  love.graphics.setLineWidth(4)
  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b, 1)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
