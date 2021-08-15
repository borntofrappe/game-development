Missile = {}

function Missile:new(x1, y1, x2, y2, label)
  local dx = (x2 - x1)
  local dy = (y2 - y1)

  local numberPoints = math.max(math.abs(dx), math.abs(dy))

  local points = {}

  table.insert(points, x1)
  table.insert(points, y1)

  for i = 1, numberPoints, LINE_RESOLUTION do
    table.insert(points, x1 + math.floor(i * dx) / numberPoints)
    table.insert(points, y1 + math.floor(i * dy) / numberPoints)
  end

  table.insert(points, x2)
  table.insert(points, y2)

  local this = {
    ["points"] = points,
    ["currentPoints"] = {},
    ["label"] = label,
    ["inPlay"] = true,
    ["d"] = (dx ^ 2 + dy ^ 2) ^ 0.5
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Missile:launch(updateSpeed)
  local index = 0

  Timer:every(
    updateSpeed * self.d,
    function()
      index = index + 2

      if index > #self.points then
        self.inPlay = false
      else
        local currentPoints = {}
        for i = 1, index do
          table.insert(currentPoints, self.points[i])
        end

        self.currentPoints = currentPoints
      end
    end,
    true,
    self.label
  )
end

function Missile:render()
  if #self.currentPoints > 2 then
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(0.5)
    love.graphics.line(self.currentPoints)
  end
end
