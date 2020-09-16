Lollipop = Class {}

function Lollipop:init(image, x, y, origin)
  self.image = image or love.graphics.newImage("res/graphics/lollipop-1.png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.x = x or 0
  self.y = y or 0
  self.origin = origin or "bottom"
end

function Lollipop:render()
  love.graphics.draw(
    self.image,
    self.x,
    self.origin == "top" and self.y + self.height or self.y,
    0,
    1,
    self.origin == "top" and -1 or 1
  )
end
