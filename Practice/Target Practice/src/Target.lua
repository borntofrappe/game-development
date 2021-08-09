Target = {}
Target.__index = Target

-- x, y describe the bottom center of the target
-- be sure to have target.x describe the left edge so that [target.x, target.x + Target.width] describe the horizontal spread
function Target:new(x, y)
  local width = 20
  local height = 36
  local radius = 24

  local legs = {
    {
      ["x1"] = x,
      ["y1"] = y,
      ["x2"] = x,
      ["y2"] = y - height
    },
    {
      ["x1"] = x + width,
      ["y1"] = y,
      ["x2"] = x,
      ["y2"] = y - height
    },
    {
      ["x1"] = x - width,
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
  love.graphics.setColor(0.27, 0.65, 0.92)
  love.graphics.circle("fill", self.body.x, self.body.y, self.body.innerRadius)
end
