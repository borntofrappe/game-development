Android = Class{}

GRAVITY_SPEED = 18
GRAVITY_ANGLE = 8

function Android:init(x, y)
  self.image = love.graphics.newImage('res/graphics/android.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.x = x + self.width / 2
  self.y = y + self.height / 2

  self.dy = -8

  self.angle = 45
  self.dangle = -1.5
end


function Android:update(dt)
  self.dy = self.dy + GRAVITY_SPEED * dt
  self.y = self.y + self.dy

  self.dangle = self.dangle + GRAVITY_ANGLE * dt
  self.angle = math.min(180, math.max(30, self.angle + self.dangle))

  if love.mouse.waspressed then
    self.dy = -6.5
    self.angle = math.min(self.angle, 60)
    self.dangle = -2.5
  end
end

function Android:render()
  love.graphics.draw(self.image, self.x - self.width / 2, self.y - self.height / 2, math.rad(self.angle), 1, 1, self.width / 2, self.height / 2)
end

