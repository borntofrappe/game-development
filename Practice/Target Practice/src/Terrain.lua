Terrain = {}
Terrain.__index = Terrain

function Terrain:new(cannon)
  local numberPoints = {
    ["platform"] = math.floor(WINDOW_WIDTH / cannon.x) * 2,
    ["hill"] = 150
  }

  numberPoints.total = numberPoints.platform * 2 + numberPoints.hill

  local yPlatformHeight = {
    ["min"] = math.floor(WINDOW_HEIGHT / 2),
    ["max"] = WINDOW_HEIGHT
  }

  local yPlatformMaxY = math.floor(WINDOW_HEIGHT / 2.5)

  local points = {}

  local x = 0
  local dx = WINDOW_WIDTH / numberPoints.total

  local yStart = cannon.y + cannon.height - cannon.offsetY
  local yEnd = love.math.random(yPlatformHeight.min, yPlatformHeight.max)

  local height1 = love.math.random(0, yStart - yPlatformMaxY)
  local height2 = yEnd - (yStart - height1)

  local p1 = love.math.random(math.floor(numberPoints.hill / 4), math.floor(numberPoints.hill * 3 / 4))
  local p2 = numberPoints.hill - p1

  local angle = 0
  local dangle1 = math.pi / p1
  local dangle2 = math.pi / p2

  for point = 1, numberPoints.platform do
    table.insert(points, x)
    table.insert(points, yStart)

    x = x + dx
  end

  for point = 1, p1 do
    local y = yStart + height1 / 2 * math.cos(angle) - height1 / 2
    table.insert(points, x)
    table.insert(points, y)

    x = x + dx
    angle = angle + dangle1
  end

  for point = 1, p2 do
    local y = yEnd + height2 / 2 * math.cos(angle) - height2 / 2
    table.insert(points, x)
    table.insert(points, y)

    x = x + dx
    angle = angle + dangle2
  end

  for point = 1, numberPoints.platform + 1 do
    table.insert(points, x)
    table.insert(points, yEnd)

    x = x + dx
  end

  local this = {
    ["points"] = points
  }

  setmetatable(this, self)
  return this
end

function Terrain:render()
  love.graphics.setColor(0.46, 0.83, 0.75)
  love.graphics.setLineWidth(8)
  love.graphics.line(self.points)
end
