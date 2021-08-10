Terrain = {}
Terrain.__index = Terrain

local POINTS = 100
local Y_MIN = math.floor(WINDOW_HEIGHT / 2)
local Y_MAX = WINDOW_HEIGHT

function Terrain:new()
  local points = {}

  local y = love.math.random(Y_MIN, Y_MAX)

  for point = 1, POINTS + 1 do
    local x = (point - 1) * WINDOW_WIDTH / POINTS
    table.insert(points, x)
    table.insert(points, y)
  end

  local this = {
    ["points"] = points
  }

  setmetatable(this, self)
  return this
end

function Terrain:render()
  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.setLineWidth(2)
  love.graphics.line(self.points)
end
