Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, callback)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["text"] = text,
    ["callback"] = callback
  }

  setmetatable(this, self)
  return this
end

function Button:update(dt)
  if love.mouse.waspressed(1) then
    local x, y = love.mouse:getPosition()
    if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
      self.callback()
    end
  end
end

function Button:render()
  love.graphics.setColor(0.18, 0.19, 0.26)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 4)

  love.graphics.setColor(0.95, 0.98, 0.98)
  love.graphics.printf(
    self.text,
    self.x,
    self.y + self.height / 2 - gFonts.normal:getHeight() / 2,
    self.width,
    "center"
  )
end
