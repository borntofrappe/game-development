Lollipop = Class {}

function Lollipop:init(x, y, flip)
  self.type = math.random(4)
  self.image = love.graphics.newImage("res/graphics/lollipop-" .. self.type .. ".png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.flip = flip
  self.x = x
  self.y = self.flip and y - self.height or y

  local topSize = 70
  self.topRadius = topSize / 2
  local innerWidth = 10
  self.padding = (self.width - innerWidth) / 2
end

function Lollipop:render()
  love.graphics.draw(self.image, self.x, self.flip and self.y + self.height or self.y, 0, 1, self.flip and -1 or 1)
end
