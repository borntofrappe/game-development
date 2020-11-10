Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, callback)
  local panel = Panel:new(x, y, width, height)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["panel"] = panel,
    ["text"] = text,
    ["callback"] = callback
  }

  setmetatable(this, self)
  return this
end

-- function Button:update(dt)
-- if pressed then
--   self.callback()
-- end
-- end

function Button:render()
  self.panel:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(self.text, self.x, self.y + self.height / 2 - font:getHeight() / 2, self.width, "center")
end
