Terrain = {}
Terrain.__index = Terrain

function Terrain:new()
  -- 400 points
  --
  local numberPoints = {
    ["total"] = 250
  }
  numberPoints.platform = math.floor(numberPoints.total / WINDOW_WIDTH * PLATFORM_WIDTH)
  numberPoints.hill = numberPoints.total - numberPoints.platform * 2

  numberPoints.total = numberPoints.platform * 2 + numberPoints.hill

  local yPlatformHeight = {
    ["min"] = math.floor(WINDOW_HEIGHT / 1.5),
    ["max"] = WINDOW_HEIGHT
  }

  local yPlatformMaxY = math.floor(WINDOW_HEIGHT / 2.5)

  local points = {}

  local x = 0
  local dx = WINDOW_WIDTH / numberPoints.total

  local yStart = love.math.random(yPlatformHeight.min, yPlatformHeight.max)
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

  local pointsPolygon = {0, WINDOW_HEIGHT}
  for p, point in ipairs(points) do
    table.insert(pointsPolygon, point)
  end

  table.insert(pointsPolygon, WINDOW_WIDTH)
  table.insert(pointsPolygon, WINDOW_HEIGHT)
  table.insert(pointsPolygon, 0)
  table.insert(pointsPolygon, WINDOW_HEIGHT)

  local this = {
    ["points"] = points,
    ["polygons"] = love.math.triangulate(pointsPolygon)
  }

  setmetatable(this, self)
  return this
end

function Terrain:updatePolygon()
  local pointsPolygon = {0, WINDOW_HEIGHT}
  for p, point in ipairs(self.points) do
    table.insert(pointsPolygon, point)
  end

  table.insert(pointsPolygon, WINDOW_WIDTH)
  table.insert(pointsPolygon, WINDOW_HEIGHT)
  table.insert(pointsPolygon, 0)
  table.insert(pointsPolygon, WINDOW_HEIGHT)

  self.polygons = love.math.triangulate(pointsPolygon)
end

function Terrain:render()
  love.graphics.setColor(0.63, 0.92, 0.45)
  for i, polygon in ipairs(self.polygons) do
    love.graphics.polygon("fill", polygon)
  end

  love.graphics.setLineWidth(5)
  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.line(self.points)
end
