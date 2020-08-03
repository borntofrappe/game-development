Lollipop = Class{}

local LOLLIPOP_IMAGE = love.graphics.newImage('res/graphics/lollipop-1.png')

function Lollipop:init(x, y, origin)
  self.width = LOLLIPOP_IMAGE:getWidth()
  self.height = LOLLIPOP_IMAGE:getHeight()
  self.x = x or 0
  self.y = y or 0
  self.origin = origin or 'bottom'
end

function Lollipop:render()
  love.graphics.draw(
    LOLLIPOP_IMAGE, 
    self.x, 
    self.origin == 'top' and self.y + self.height or self.y,
    0,
    1,
    self.origin == 'top' and -1 or 1
  )
end
