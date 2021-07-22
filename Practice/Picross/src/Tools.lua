Tools = {}

function Tools:new(selection)
  local pen = {
    ["x"] = WINDOW_WIDTH / 4 + 19,
    ["y"] = WINDOW_HEIGHT / 2,
    ["r"] = 25,
    ["scale"] = 1
  }

  local eraser = {
    ["x"] = pen.x - 38,
    ["y"] = pen.y + 38,
    ["r"] = 25,
    ["scale"] = 0.7
  }

  local this = {
    ["selection"] = selection,
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
    love.graphics.setColor(0.05, 0.05, 0.15, 0.15)
  else
    love.graphics.setColor(0.98, 0.85, 0.05)
  end
  love.graphics.scale(self.pen.scale, self.pen.scale)
  love.graphics.circle("fill", 0, 0, self.pen.r)

  love.graphics.setColor(0.07, 0.07, 0.2)
  love.graphics.circle("line", 0, 0, self.pen.r)

  love.graphics.polygon("fill", 5, -10, -9, 4, -9, 9, -3, 9, 10, -5)

  love.graphics.pop()

  love.graphics.push()
  love.graphics.translate(self.eraser.x, self.eraser.y)

  if self.selection == "pen" then
    love.graphics.setColor(0.05, 0.05, 0.15, 0.15)
  else
    love.graphics.setColor(0.98, 0.85, 0.05)
  end
  love.graphics.scale(self.eraser.scale, self.eraser.scale)
  love.graphics.circle("fill", 0, 0, self.eraser.r)

  love.graphics.setColor(0.07, 0.07, 0.2)
  love.graphics.circle("line", 0, 0, self.eraser.r)

  love.graphics.line(-6, -6, 6, 6)
  love.graphics.line(-6, 6, 6, -6)

  love.graphics.pop()
end
