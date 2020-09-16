Android = Class {}

PADDING = 15
GRAVITY_SPEED = 18
GRAVITY_ANGLE = 8

function Android:init(x, y)
  self.image = love.graphics.newImage("res/graphics/android.png")
  self.x = x
  self.y = y
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.dy = -8

  self.angle = 45
  self.dangle = -1.5
end

function Android:collides(lollipop)
  if lollipop.origin == "top" then
    if
      (((self.x + self.width / 2) - (lollipop.x + lollipop.width / 2)) ^ 2 +
        ((self.y - self.height / 2) - (lollipop.y + lollipop.height - lollipop.width / 2)) ^ 2) ^
        0.5 <
        lollipop.width / 2
     then
      return true
    end
  else
    if
      (((self.x + self.width / 2) - (lollipop.x + lollipop.width / 2)) ^ 2 +
        (self.y - (lollipop.y + lollipop.width / 2)) ^ 2) ^
        0.5 <
        lollipop.width / 2
     then
      return true
    end
  end

  if self.x < lollipop.x + PADDING or self.x > lollipop.x + lollipop.width - PADDING then
    return false
  end

  if self.y < lollipop.y or self.y > lollipop.y + lollipop.height then
    return false
  end

  return true
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
  love.graphics.draw(self.image, self.x, self.y, math.rad(self.angle), 1, 1, self.width / 2, self.height / 2)
end
