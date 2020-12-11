Button = {}
Button.__index = Button

function Button:create(x, y, width, height, text, callback)
  local panel = Panel:create(x, y, width, height)
  this = {
    x = x,
    y = y,
    width = width,
    height = height,
    text = text,
    panel = panel,
    callback = callback
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
  self.panel:render()

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(
    self.text,
    self.x,
    self.y + self.height / 2 - gFonts["normal"]:getHeight() / 2,
    self.width,
    "center"
  )
end
