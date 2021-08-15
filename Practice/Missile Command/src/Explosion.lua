Explosion = {}

function Explosion:new(x, y, label)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = 0,
    ["direction"] = 1,
    ["label"] = label,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Explosion:trigger()
  Timer:every(
    EXPLOSION_INTERVAL,
    function()
      self.r = self.r + EXPLOSION_RADIUS_INCREMENT * self.direction
      if self.r >= EXPLOSION_RADIUS_MAX then
        self.r = EXPLOSION_RADIUS_MAX
        self.direction = self.direction * -1
      end

      if self.r == 0 then
        self.inPlay = false
      end
    end,
    true,
    self.label
  )
end

function Explosion:withinRange(missile)
  local x = missile.currentPoints[#missile.currentPoints - 1]
  local y = missile.currentPoints[#missile.currentPoints]

  return (self.x - x) ^ 2 + (self.y - y) ^ 2 < self.r ^ 2
end

function Explosion:render()
  love.graphics.setColor(0, 0, 0, 0.35)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
