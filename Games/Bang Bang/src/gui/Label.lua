Label = {}
Label.__index = Label

function Label:create(x, y, text)
  this = {
    x = x,
    y = y,
    text = text
  }

  setmetatable(this, self)

  return this
end

function Label:render()
  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b, 1)
  love.graphics.print(self.text, self.x, self.y)
end
