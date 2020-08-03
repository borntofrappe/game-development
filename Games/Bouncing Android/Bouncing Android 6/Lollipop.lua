Lollipop = {}

function Lollipop:init(image, x, y, origin)
  local lollipop = {}

  lollipop.image = image or love.graphics.newImage('res/lollipop-1.png')
  lollipop.width = lollipop.image:getWidth()
  lollipop.height = lollipop.image:getHeight()
  lollipop.x = x or 0
  lollipop.y = y or 0
  lollipop.origin = origin or 'bottom'

  setmetatable(lollipop, {__index = self})
  return lollipop
end

function Lollipop:render()
  love.graphics.draw(
    self.image, 
    self.x, 
    self.origin == 'top' and self.y + self.height or self.y,
    0,
    1,
    self.origin == 'top' and -1 or 1
  )
end