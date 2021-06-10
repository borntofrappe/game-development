Lollipop = Class {}

-- TYPES as * from lollipop-*.png
local TYPES = 6
-- size of the colorful circle
local TOP_SIZE = 70
-- size of the white rectangle
local INNER_WIDTH = 10

function Lollipop:init(x, y, flip)
  self.type = math.random(TYPES)
  self.image = love.graphics.newImage("res/graphics/lollipop-" .. self.type .. ".png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.flip = flip
  self.x = x
  self.y = self.flip and y - self.height or y

  self.topRadius = TOP_SIZE / 2
  self.padding = (self.width - INNER_WIDTH) / 2
end

function Lollipop:render()
  love.graphics.draw(self.image, self.x, self.flip and self.y + self.height or self.y, 0, 1, self.flip and -1 or 1)
end
