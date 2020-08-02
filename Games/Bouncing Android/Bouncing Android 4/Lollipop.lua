Lollipop = {}
local LOLLIPOP_IMAGE = love.graphics.newImage('res/lollipop.png')
local LOLLIPOP_SCROLL = -80

function Lollipop:init()
  local lollipop = {}

  lollipop.r = LOLLIPOP_IMAGE:getWidth() / 2
  lollipop.x = WINDOW_WIDTH + lollipop.r
  lollipop.y = math.random(WINDOW_HEIGHT / 2, WINDOW_HEIGHT - lollipop.r * 2)
  lollipop.remove = false

  setmetatable(lollipop, {__index = self})
  return lollipop
end

function Lollipop:update(dt)
  self.x = self.x + LOLLIPOP_SCROLL * dt

  if self.x < -self.r then
    self.remove = true
  end
end

function Lollipop:render()
  love.graphics.rectangle('fill', self.x - 5, self.y, 10, WINDOW_HEIGHT - self.y)
  love.graphics.draw(LOLLIPOP_IMAGE, self.x - self.r, self.y - self.r)
end