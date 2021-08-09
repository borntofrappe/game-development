Target = {}
Target.__index = Target

function Target:new(terrain)
  local width = 30
  local height = 36
  local radius = 24

  local x = WINDOW_WIDTH - PLATFORM_WIDTH / 2
  local y = terrain and terrain.points[#terrain.points] or WINDOW_HEIGHT

  local legs = {
    {
      ["x1"] = x,
      ["y1"] = y,
      ["x2"] = x,
      ["y2"] = y - height
    },
    {
      ["x1"] = x + width / 2,
      ["y1"] = y,
      ["x2"] = x,
      ["y2"] = y - height
    },
    {
      ["x1"] = x - width / 2,
      ["y1"] = y,
      ["x2"] = x,
      ["y2"] = y - height
    }
  }

  local body = {
    ["x"] = x,
    ["y"] = y - height,
    ["radius"] = radius,
    ["innerRadius"] = radius * 0.5
  }

  local this = {
    ["x"] = x - width / 2,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["legs"] = legs,
    ["body"] = body
  }

  setmetatable(this, self)
  return this
end

function Target:render()
  love.graphics.setColor(0.51, 0.27, 0.25)
  love.graphics.setLineWidth(8)

  for i, leg in ipairs(self.legs) do
    love.graphics.line(leg.x1, leg.y1, leg.x2, leg.y2)
  end

  love.graphics.setColor(0.18, 0.19, 0.26)
  love.graphics.circle("fill", self.body.x, self.body.y, self.body.radius)
  love.graphics.setColor(0.98, 0.32, 0.44)
  love.graphics.circle("fill", self.body.x, self.body.y, self.body.innerRadius)
end
