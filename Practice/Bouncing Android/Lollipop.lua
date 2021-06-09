Lollipop = Class {}

local SCROLL = 80
function Lollipop:init()
  self.type = math.random(4)
  self.image = love.graphics.newImage("res/graphics/lollipop-" .. self.type .. ".png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  local topSize = 70
  self.topRadius = topSize / 2
  local innerWidth = 10
  self.padding = (self.width - innerWidth) / 2

  self.x = WINDOW_WIDTH + 20
  self.y = math.random(topSize * 1.25, WINDOW_HEIGHT - topSize * 1.25)

  self.dx = -SCROLL
  self.visible = true
end

function Lollipop:update(dt)
  self.x = self.x + self.dx * dt

  if self.x < -self.width then
    self.visible = false
  end
end

function Lollipop:render()
  love.graphics.draw(self.image, self.x, self.y)
end
