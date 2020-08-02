Android = {}
local ANDROID_IMAGE = love.graphics.newImage('res/android.png')

GRAVITY_SPEED = 18
GRAVITY_ANGLE = 7

function Android:init(x, y)
  local android = {}

  android.width = ANDROID_IMAGE:getWidth()
  android.height = ANDROID_IMAGE:getHeight()
  android.x = x + android.width / 2
  android.y = y + android.height / 2

  android.dy = -5

  android.angle = 45
  android.dangle = -1

  setmetatable(android, {__index = self})
  return android
end

function Android:update(dt)
  if self.y < WINDOW_HEIGHT then
    self.dy = self.dy + GRAVITY_SPEED * dt
    self.y = self.y + self.dy

    self.dangle = self.dangle + GRAVITY_ANGLE * dt
    self.angle = math.min(180, math.max(30, self.angle + self.dangle))
  end

  if love.mouse.waspressed then
    self.dy = -6
    self.angle = math.min(self.angle, 60)
    self.dangle = -2
  end
end

function Android:render()
  love.graphics.draw(ANDROID_IMAGE, self.x - self.width / 2, self.y - self.height / 2, math.rad(self.angle), 1, 1, self.width / 2, self.height / 2)
end

