LollipopPair = {}

local PAIR_SCROLL = -80
local PAIR_WIDTH = Lollipop:init().width
local PAIR_HEIGHT = Lollipop:init().height
local PAIR_GAP = 100

function LollipopPair:init()
  local pair = {}

  pair.x = WINDOW_WIDTH
  pair.y = math.random(PAIR_WIDTH + PAIR_GAP, WINDOW_HEIGHT - PAIR_WIDTH)
  pair.lollipops = {
    upper = Lollipop:init(pair.x, pair.y - PAIR_GAP - PAIR_HEIGHT, 'top'),
    lower = Lollipop:init(pair.x, pair.y)
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