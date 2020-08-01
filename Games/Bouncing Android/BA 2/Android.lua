Android = {}

function Android:init()
  local android = {}
  android.image = love.graphics.newImage('res/android.png')
  android.width = android.image:getWidth()
  android.height = android.image:getHeight()
  android.x = WINDOW_WIDTH / 2 - android.width / 2
  android.y = WINDOW_HEIGHT / 2 - android.height / 2

  self.__index = self
  setmetatable(android, self)
  return android
end

function Android:render()
  love.graphics.draw(self.image, self.x, self.y)
end