Lollipop = {}
local LOLLIPOP_IMAGE = love.graphics.newImage('res/lollipop.png')

function Lollipop:init(x, y, origin)
  local lollipop = {}

  lollipop.width = LOLLIPOP_IMAGE:getWidth()
  lollipop.height = LOLLIPOP_IMAGE:getHeight()
  lollipop.x = x or 0
  lollipop.y = y or 0
  lollipop.origin = origin or 'bottom'

  setmetatable(lollipop, {__index = self})
  return lollipop
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