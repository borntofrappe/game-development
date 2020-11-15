function getTerrainPoints()
  local points = {}
  local offset = love.math.random(1000)
  local increment = 0.1
  local numberPoints = 50
  local terrainHeightRandom = love.math.random(15, 30)
  local terrainHeightNoise = WINDOW_HEIGHT / 2 - terrainHeightRandom

  for i = 0, numberPoints do
    local x = i * WINDOW_WIDTH / numberPoints
    local y = (love.math.noise(offset) * terrainHeightNoise + love.math.random() * terrainHeightRandom) * -1

    table.insert(points, x)
    table.insert(points, y)

    offset = offset + increment
  end

  return points
end

function formatNumber(number, padding)
  local padding = padding or 4
  return string.format("%0" .. padding .. "d", number)
end

function formatTime(seconds)
  return formatNumber(math.floor(seconds / 60), 2) .. ":" .. formatNumber(math.floor(seconds) % 60, 2)
end

function formatAltitude(y)
  return WINDOW_HEIGHT - math.floor(y)
end

function formatHorizontalSpeed(speed)
  local icon = ""
  if speed ~= 0 then
    icon = speed > 0 and " →" or " ←"
  end
  return math.abs(speed) .. icon
end

function formatVerticalSpeed(speed)
  local icon = ""
  if speed ~= 0 then
    icon = speed > 0 and " ↓" or " ↑"
  end
  return math.abs(speed) .. icon
end
