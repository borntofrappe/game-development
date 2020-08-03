LollipopPair = {}

local PAIR_SCROLL = -80
local PAIR_WIDTH = Lollipop:init().width
local PAIR_HEIGHT = Lollipop:init().height

function LollipopPair:init(image)
  local pair = {}

  pair.gap = math.random(85, 120)
  pair.x = WINDOW_WIDTH
  pair.y = math.random(PAIR_WIDTH + pair.gap, WINDOW_HEIGHT - PAIR_WIDTH)
  pair.lollipops = {
    upper = Lollipop:init(image, pair.x, pair.y - pair.gap - PAIR_HEIGHT, 'top'),
    lower = Lollipop:init(image, pair.x, pair.y, 'bottom')
  }

  pair.remove = false

  setmetatable(pair, {__index = self})
  return pair
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