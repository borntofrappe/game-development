Button = {}

function Button:new(x, y, width, height, text, callback)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["text"] = text,
    ["callback"] = callback,
    ["isHover"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Button:mouseenter()
  self.isHover = true
end

function Button:mouseleave()
  self.isHover = false
end

function Button:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

  if self.isHover then
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
  else
  end
  love.graphics.printf(self.text, self.x, self.y + self.height / 4, self.width, "center")
end
