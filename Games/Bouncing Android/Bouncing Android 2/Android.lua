Android = Class{}

function Android:init()
  self.image = love.graphics.newImage('res/graphics/android.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.x = WINDOW_WIDTH / 2 - self.width / 2
  self.y = WINDOW_HEIGHT / 2 - self.height / 2
end

function Android:render()
  love.graphics.draw(self.image, self.x, self.y)
end