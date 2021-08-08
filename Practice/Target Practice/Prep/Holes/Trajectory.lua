Trajectory = {}
Trajectory.__index = Trajectory

function Trajectory:new(terrain, player)
  local a = player.angle
  local v = player.velocity

  local points = {}
  local theta = math.rad(a)

  local t = 0
  local dt = (terrain.points[3] - terrain.points[1]) / (v * math.cos(theta))

  while true do
    dx = v * t * math.cos(theta)
    dy = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2

    table.insert(points, player.x + dx)
    table.insert(points, player.y - dy)

    t = t + dt

    if player.y - dy > WINDOW_HEIGHT then
      break
    end
  end

  local this = {
    ["points"] = points
  }

  setmetatable(this, self)
  return this
end

function Trajectory:render()
  love.graphics.setColor(0.83, 0.87, 0.92)

  love.graphics.setLineWidth(1)
  love.graphics.line(self.points)
end
