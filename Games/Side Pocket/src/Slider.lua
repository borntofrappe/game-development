Slider = {}
Slider.__index = Slider

function Slider:new(def)
  local def =
    def or
    {
      ["x"] = 8,
      ["y"] = 8,
      ["width"] = 36,
      ["height"] = 16,
      ["lineWidth"] = 2,
      ["rx"] = 8,
      ["offset"] = 3,
      ["radius"] = 5,
      ["value"] = 0,
      ["direction"] = 1
    }

  def.panel =
    Panel:new(
    {
      ["x"] = def.x,
      ["y"] = def.y,
      ["width"] = def.width,
      ["height"] = def.height,
      ["lineWidth"] = def.lineWidth,
      ["rx"] = def.rx
    }
  )

  this = def

  setmetatable(this, self)
  return this
end

function Slider:update(dt)
  self.value = self.value + self.direction * SLIDER_SPEED * dt
  if self.value >= 100 then
    self.value = 100
    self.direction = -1
  elseif self.value <= 0 then
    self.value = 0
    self.direction = 1
  end
end

function Slider:render()
  self.panel:render()
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.circle(
    "fill",
    self.x + self.offset + self.radius + ((self.width - (self.offset + self.radius) * 2) * self.value / 100),
    self.y + self.height / 2,
    self.radius
  )
end
