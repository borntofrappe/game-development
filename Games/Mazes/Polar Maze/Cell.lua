Cell = {}
Cell.__index = Cell

function Cell:new(ring, ringCount, innerRadius, outerRadius, angleStart, angleEnd)
  local x1 = innerRadius * math.cos(angleStart)
  local y1 = innerRadius * math.sin(angleStart)
  local x2 = outerRadius * math.cos(angleStart)
  local y2 = outerRadius * math.sin(angleStart)

  local x3 = innerRadius * math.cos(angleEnd)
  local y3 = innerRadius * math.sin(angleEnd)
  local x4 = outerRadius * math.cos(angleEnd)
  local y4 = outerRadius * math.sin(angleEnd)

  this = {
    ["ring"] = ring,
    ["ringCount"] = ringCount,
    ["innerRadius"] = innerRadius,
    ["outerRadius"] = outerRadius,
    ["angleStart"] = angleStart,
    ["angleEnd"] = angleEnd,
    ["x1"] = x1,
    ["y1"] = y1,
    ["x2"] = x2,
    ["y2"] = y2,
    ["x3"] = x3,
    ["y3"] = y3,
    ["x4"] = x4,
    ["y4"] = y4,
    ["gates"] = {
      ["up"] = true,
      ["right"] = true,
      ["down"] = true,
      ["left"] = true
    },
    ["visited"] = false
  }

  setmetatable(this, self)
  return this
end

function Cell:render()
  if self.gates.up then
    love.graphics.arc("line", "open", 0, 0, self.outerRadius, self.angleStart, self.angleEnd)
  end

  if self.gates.right then
    love.graphics.line(self.x3, self.y3, self.x4, self.y4)
  end

  if self.gates.down then
    love.graphics.arc("line", "open", 0, 0, self.innerRadius, self.angleStart, self.angleEnd)
  end

  if self.gates.left then
    love.graphics.line(self.x1, self.y1, self.x2, self.y2)
  end
end
