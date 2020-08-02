Lollipop = {}
local LOLLIPOP_IMAGE = love.graphics.newImage('res/lollipop.png')
local LOLLIPOP_SCROLL = -80

function Lollipop:init()
  local lollipop = {}

  lollipop.width = LOLLIPOP_IMAGE:getWidth()
  lollipop.height = LOLLIPOP_IMAGE:getHeight()
  lollipop.x = WINDOW_WIDTH
  lollipop.y = math.random(WINDOW_HEIGHT / 2, WINDOW_HEIGHT - lollipop.width)
  lollipop.remove = false

  setmetatable(lollipop, {__index = self})
  return lollipop
end

function Lollipop:update(dt)
  self.x = self.x + LOLLIPOP_SCROLL * dt

  if self.x < -self.width then
    self.remove = true
  end
end

function Lollipop:render()
  love.graphics.draw(LOLLIPOP_IMAGE, self.x, self.y)
end