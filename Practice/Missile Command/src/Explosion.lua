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
    EXPLOSION.interval,
    function()
      self.r = self.r + 1 * self.direction
      if self.r >= EXPLOSION.radius then
        self.r = EXPLOSION.radius
        self.direction = self.direction * -1
      end

      if self.r <= 0 then
        self.inPlay = false
      end
    end,
    true,
    self.label
  )
end

function Explosion:destroys(missile)
  local x = missile.currentPoints[#missile.currentPoints - 1]
  local y = missile.currentPoints[#missile.currentPoints]

  return (self.x - x) ^ 2 + (self.y - y) ^ 2 < self.r ^ 2 and self.direction == 1
end

function Explosion:render()
  love.graphics.setColor(0, 0, 0, 0.35)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
