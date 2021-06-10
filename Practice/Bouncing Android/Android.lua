Android = Class {}

local JUMP = 4
local GRAVITY_CHANGE = 12
local ANGLE_CHANGE = 0.15

function Android:init()
  self.image = love.graphics.newImage("res/graphics/android.png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.x = WINDOW_WIDTH / 2
  self.y = WINDOW_HEIGHT / 2
  -- immediately jump upwards
  self.dy = -JUMP

  self.angle = 0
  self.dangle = 0

  -- highlight collision
  self.collided = false
end

-- self.x and self.y describe the center of the android
function Android:collides(lollipop)
  if self.y + self.height / 2 < lollipop.y or self.y - self.height / 2 > lollipop.y + lollipop.height then
    return false
  end

  if self.x + self.width / 2 < lollipop.x or self.x - self.width / 2 > lollipop.x + lollipop.width then
    return false
  end

  if lollipop.flip then
    if self.y - self.height / 2 > lollipop.y + lollipop.height - lollipop.topRadius * 2 then
      local cx = lollipop.x + lollipop.topRadius
      local cy = lollipop.y + lollipop.height - lollipop.topRadius
      return ((self.x - cx) ^ 2 + (self.y - cy) ^ 2) ^ 0.5 < lollipop.topRadius + self.width / 2
    end
  else
    if self.y - self.height / 2 < lollipop.y + lollipop.topRadius * 2 then
      local cx = lollipop.x + lollipop.topRadius
      local cy = lollipop.y + lollipop.topRadius
      return ((self.x - cx) ^ 2 + (self.y - cy) ^ 2) ^ 0.5 < lollipop.topRadius + self.width / 2
    end
  end

  if
    self.x + self.width / 2 < lollipop.x + lollipop.padding or
      self.x - self.width / 2 > lollipop.x + lollipop.width - lollipop.padding
   then
    return false
  end

  return true
end

function Android:update(dt)
  -- update y and angle
  self.y = self.y + self.dy
  self.dy = self.dy + GRAVITY_CHANGE * dt

  self.angle = math.min(math.pi * 6 / 7, self.angle + self.dangle)
  self.dangle = self.dangle + ANGLE_CHANGE * dt

  -- jump
  if love.mouse.waspressed then
    self.dy = -JUMP
    self.dangle = 0
    self.angle = math.pi / 7
  end

  -- bottom edge collision
  if self.y + self.height / 2 >= WINDOW_HEIGHT then
    self.y = WINDOW_HEIGHT - self.height / 2
    self.collided = true
  end
end

function Android:render()
  love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.width / 2, self.height / 2)
end
