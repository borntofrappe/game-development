Terrain = {}
Terrain.__index = Terrain

local POINTS = {
  ["flat"] = 30,
  ["hill"] = 120
}

POINTS.total = POINTS.flat * 2 + POINTS.hill

local Y_START = WINDOW_HEIGHT * 3 / 4

local HEIGHT_HILL = {
  ["min"] = math.floor(WINDOW_HEIGHT / 10),
  ["max"] = math.floor(WINDOW_HEIGHT / 5)
}

function Terrain:new()
  local points = {}

  local x = 0
  local y = Y_START
  local height = love.math.random(HEIGHT_HILL.min, HEIGHT_HILL.max)
  local dx = WINDOW_WIDTH / POINTS.total

  for point = 1, POINTS.flat do
    table.insert(points, x)
    table.insert(points, Y_START)

    x = x + dx
  end

  local angle = math.pi / 2
  local dangle = (angle + math.pi * 3 / 2) / (POINTS.hill + 1)

  for point = 1, POINTS.hill + 1 do
    local y = Y_START - height + math.sin(angle) * height

    table.insert(points, x)
    table.insert(points, y)

    x = x + dx
    angle = math.min(angle + math.pi * 2, angle + dangle)
  end

  for point = 1, POINTS.flat do
    table.insert(points, x)
    table.insert(points, Y_START)

    x = x + dx
  end

  local this = {
    ["points"] = points
  }

  setmetatable(this, self)
  return this
end

function Terrain:render()
  love.graphics.setColor(0.49, 0.85, 0.79)
  love.graphics.setLineWidth(2)
  love.graphics.line(self.points)
end
