Button = {}

function Button:new(x, y, width, height, text, callback)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["text"] = text,
    ["callback"] = callback,
    ["isMouseover"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Button:mouseenter()
  self.isMouseover = true
end

function Button:mouseleave()
  self.isMouseover = false
end

function Button:render()
  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)

  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

  if self.isMouseover then
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(COLORS.background.r, COLORS.background.g, COLORS.background.b)
  else
  end
  love.graphics.printf(self.text, self.x, self.y + self.height / 4, self.width, "center")
end
