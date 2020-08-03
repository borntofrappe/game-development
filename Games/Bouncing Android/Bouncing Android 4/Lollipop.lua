Lollipop = Class{}

local LOLLIPOP_IMAGE = love.graphics.newImage('res/graphics/lollipop-1.png')
local LOLLIPOP_SCROLL = -80

function Lollipop:init()
  self.width = LOLLIPOP_IMAGE:getWidth()
  self.height = LOLLIPOP_IMAGE:getHeight()
  self.x = WINDOW_WIDTH
  self.y = math.random(self.width, WINDOW_HEIGHT - self.width)
  self.remove = false
end

function Lollipop:update(dt)
  self.x = self.x + LOLLIPOP_SCROLL * dt

  if self.x < -self.width then
    self.remove = true
  end
end

function Lollipop:render()
  love.graphics.draw(LOLLIPOP_IMAGE, self.x, self.y)
end