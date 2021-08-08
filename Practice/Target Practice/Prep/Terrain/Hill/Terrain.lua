Terrain = {}
Terrain.__index = Terrain

local POINTS = {
  ["flat"] = 30,
  ["hill"] = 120
}

POINTS.total = POINTS.flat * 2 + POINTS.hill

local Y_START = WINDOW_HEIGHT * 3 / 4

local HEIGHT_HILL = {
  ["min"] = 0,
  ["max"] = math.floor(WINDOW_HEIGHT / 2)
}

function Terrain:new()
  local points = {}

  local x = 0
  local dx = WINDOW_WIDTH / POINTS.total

  local angle = 0 -- math.pi / 2 -- if you use the sine function instead of cosine
  local dangle = math.pi * 2 / POINTS.hill
  local height = love.math.random(HEIGHT_HILL.min, HEIGHT_HILL.max)

  for point = 1, POINTS.flat do
    table.insert(points, x)
    table.insert(points, Y_START)

    x = x + dx
  end

  for point = 1, POINTS.hill do
    local y = Y_START + math.cos(angle) * height / 2 - height / 2
    -- local y = Y_START + math.sin(angle) * height / 2 - height / 2 -- update the angle to start at math.pi / 2

    table.insert(points, x)
    table.insert(points, y)

    x = x + dx
    angle = angle + dangle
  end

  for point = 1, POINTS.flat + 1 do
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
