LollipopPair = Class{}

local PAIR_SCROLL = -80
local PAIR_WIDTH = Lollipop().width
local PAIR_HEIGHT = Lollipop().height

function LollipopPair:init(image)
  self.image = image or love.graphics.newImage('res/graphics/lollipop-1.png')
  self.gap = math.random(90, 120)
  self.x = WINDOW_WIDTH
  self.y = math.random(PAIR_WIDTH + self.gap, WINDOW_HEIGHT - PAIR_WIDTH)
  self.width = PAIR_WIDTH
  self.lollipops = {
    upper = Lollipop(self.image, self.x, self.y - self.gap - PAIR_HEIGHT, 'top'),
    lower = Lollipop(self.image, self.x, self.y)
  }

  self.remove = false
  self.score = false
end

function LollipopPair:update(dt)
  self.x = self.x + PAIR_SCROLL * dt
  for k, lollipop in pairs(self.lollipops) do
    lollipop.x = self.x
  end

  if self.x < -PAIR_WIDTH then
    self.remove = true
  end
end

function LollipopPair:render()
  for k, lollipop in pairs(self.lollipops) do
    lollipop:render()
  end
end

