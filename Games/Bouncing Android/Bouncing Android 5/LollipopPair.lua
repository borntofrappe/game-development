LollipopPair = Class{}

local PAIR_SCROLL = -80
local PAIR_WIDTH = Lollipop().width
local PAIR_HEIGHT = Lollipop().height
local PAIR_GAP = 100

function LollipopPair:init()
  self.x = WINDOW_WIDTH
  self.y = math.random(PAIR_WIDTH + PAIR_GAP, WINDOW_HEIGHT - PAIR_WIDTH)
  self.lollipops = {
    upper = Lollipop(self.x, self.y - PAIR_GAP - PAIR_HEIGHT, 'top'),
    lower = Lollipop(self.x, self.y)
  }

  self.remove = false
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