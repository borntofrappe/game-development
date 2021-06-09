LollipopPair = Class {}

local SCROLL = 80
local GAP_MIN = 70
local GAP_MAX = 120

function LollipopPair:init()
  local gap = math.random(GAP_MIN, GAP_MAX)
  self.x = WINDOW_WIDTH + 20
  self.y = math.random(gap + 20, WINDOW_HEIGHT - 20)

  self.lollipops = {
    Lollipop(self.x, self.y),
    Lollipop(self.x, self.y - gap, true)
  }

  self.width = self.lollipops[1].image:getWidth()
  self.height = self.lollipops[1].image:getHeight()

  self.dx = -SCROLL
  self.visible = true
  self.scored = false
end

function LollipopPair:update(dt)
  self.x = self.x + self.dx * dt

  if self.x < -self.width then
    self.visible = false
  end

  for k, lollipop in pairs(self.lollipops) do
    lollipop.x = self.x
  end
end

function LollipopPair:render()
  for k, lollipop in pairs(self.lollipops) do
    lollipop:render(d)
  end
end
