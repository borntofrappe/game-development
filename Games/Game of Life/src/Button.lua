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
    ["callback"] = callback,
    ["color"] = {
      ["r"] = 1,
      ["g"] = 1,
      ["b"] = 1
    }
  }

  setmetatable(this, self)
  return this
end

function Button:highlight()
  self.panel:highlight()
  self.color = {
    ["r"] = 0,
    ["g"] = 0,
    ["b"] = 0
  }
end

function Button:reset()
  self.panel:reset()
  self.color = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1
  }
end

function Button:render()
  self.panel:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.printf(self.text, self.x, self.y + self.height / 2 - font:getHeight() / 2, self.width, "center")
end
