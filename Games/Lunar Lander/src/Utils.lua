function makeTerrain()
  local terrain = {}
  local offset = love.math.random(1000)
  local increment = 0.1
  local points = 50
  local terrainHeightRandom = love.math.random(15, 30)
  local terrainHeightNoise = WINDOW_HEIGHT / 2 - terrainHeightRandom

  for i = 0, points do
    local x = i * WINDOW_WIDTH / points
    local y = WINDOW_HEIGHT - (love.math.noise(offset) * terrainHeightNoise + love.math.random() * terrainHeightRandom)

    table.insert(terrain, x)
    table.insert(terrain, y)

    offset = offset + increment
  end

  return terrain
end

function formatNumber(number, padding)
  local padding = padding or 4
  return string.format("%0" .. padding .. "d", number)
end

function formatTime(seconds)
  return formatNumber(math.floor(seconds / 60), 2) .. ":" .. formatNumber(seconds % 60, 2)
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
