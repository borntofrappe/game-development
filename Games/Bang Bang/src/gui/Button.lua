Button = {}
Button.__index = Button

function Button:create(x, y, width, height, text, callback, offsetY)
  this = {
    x = x,
    y = y,
    width = width,
    height = height,
    text = text,
    callback = callback,
    offsetY = offsetY or 0
  }

  setmetatable(this, self)

  return this
end

function Button:update(dt)
  if love.mouse.wasPressed(1) then
    local x, y = love.mouse:getPosition()
    if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
      self.callback(dt)
    end
  end
end

function Button:render()
  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b, 1)

  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 8)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(
    self.text,
    self.x,
    self.y + self.height / 2 - gFonts["normal"]:getHeight() / 2 - self.offsetY,
    self.width,
    "center"
  )
end
