Terrain = {}
Terrain.__index = Terrain

local POINTS = {
  ["flat"] = 30,
  ["hill"] = 120
}

POINTS.total = POINTS.flat * 2 + POINTS.hill

local Y_FLAT = {
  ["min"] = math.floor(WINDOW_HEIGHT / 2),
  ["max"] = WINDOW_HEIGHT
}

local Y_UPPER_THRESHOLD = math.floor(WINDOW_HEIGHT / 2.5)

function Terrain:new()
  local points = {}

  local x = 0
  local dx = WINDOW_WIDTH / POINTS.total

  local angle = 0
  local dangle = math.pi * 2 / POINTS.hill

  local yStart = love.math.random(Y_FLAT.min, Y_FLAT.max)
  local yEnd = love.math.random(Y_FLAT.min, Y_FLAT.max)

  local height1 = love.math.random(0, yStart - Y_UPPER_THRESHOLD)
  local height2 = yEnd - (yStart - height1)

  local p1 = love.math.random(math.floor(POINTS.hill / 4), math.floor(POINTS.hill * 3 / 4))
  local p2 = POINTS.hill - p1

  local angle = 0
  local dangle1 = math.pi / p1
  local dangle2 = math.pi / p2

  for point = 1, POINTS.flat do
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

  for point = 1, POINTS.flat + 1 do
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
  love.graphics.setLineWidth(2)
  love.graphics.line(self.points)
end
