PopState = BaseState:new()

function PopState:enter()
  local balloons = {}

  local yStart = WINDOW_HEIGHT * 3 / 8

  local r = 25
  for i = 1, 3 do
    local balloon = {
      ["x"] = WINDOW_WIDTH / 2 + (i - 2) * r * 2.5,
      ["y"] = i % 2 == 0 and yStart - r / 2 or yStart,
      ["r"] = r
    }

    table.insert(balloons, balloon)
  end

  self.balloons = balloons

  local weight = {
    ["x"] = WINDOW_WIDTH / 2 - 20,
    ["y"] = WINDOW_HEIGHT * 5 / 8 - 20,
    ["size"] = 40
  }

  self.weight = weight

  local lines = {}
  for _, balloon in ipairs(balloons) do
    local line = {
      ["x1"] = balloon.x,
      ["y1"] = balloon.y,
      ["x2"] = weight.x + weight.size / 2,
      ["y2"] = weight.y + weight.size / 2
    }

    table.insert(lines, line)
  end

  self.lines = lines
end

function PopState:update(dt)
end

function PopState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setLineWidth(1)
  for _, line in ipairs(self.lines) do
    love.graphics.line(line.x1, line.y1, line.x2, line.y2)
  end

  for _, balloon in ipairs(self.balloons) do
    love.graphics.circle("fill", balloon.x, balloon.y, balloon.r)
  end

  love.graphics.rectangle("fill", self.weight.x, self.weight.y, self.weight.size, self.weight.size)
end
