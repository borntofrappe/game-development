Tools = {}

function Tools:new()
  local pen = {
    ["x"] = WINDOW_WIDTH / 4 + 19,
    ["y"] = WINDOW_HEIGHT / 2,
    ["r"] = 25,
    ["scale"] = 0
  }

  local eraser = {
    ["x"] = pen.x - 38,
    ["y"] = pen.y + 38,
    ["r"] = 25,
    ["scale"] = 0
  }

  local this = {
    ["selection"] = nil,
    ["pen"] = pen,
    ["eraser"] = eraser
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Tools:select(selection)
  self.selection = selection
end

function Tools:render()
  love.graphics.setLineWidth(3)
  love.graphics.push()
  love.graphics.translate(self.pen.x, self.pen.y)

  if self.selection == "eraser" then
    love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, gColors.shadow.a)
  else
    love.graphics.setColor(gColors.highlight.r, gColors.highlight.g, gColors.highlight.b)
  end
  love.graphics.scale(self.pen.scale, self.pen.scale)
  love.graphics.circle("fill", 0, 0, self.pen.r)

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.circle("line", 0, 0, self.pen.r)

  love.graphics.polygon("fill", 5, -10, -9, 4, -9, 9, -3, 9, 10, -5)

  love.graphics.pop()

  love.graphics.push()
  love.graphics.translate(self.eraser.x, self.eraser.y)

  if self.selection == "pen" then
    love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, gColors.shadow.a)
  else
    love.graphics.setColor(gColors.highlight.r, gColors.highlight.g, gColors.highlight.b)
  end
  love.graphics.scale(self.eraser.scale, self.eraser.scale)
  love.graphics.circle("fill", 0, 0, self.eraser.r)

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.circle("line", 0, 0, self.eraser.r)

  love.graphics.line(-6, -6, 6, 6)
  love.graphics.line(-6, 6, 6, -6)

  love.graphics.pop()
end
