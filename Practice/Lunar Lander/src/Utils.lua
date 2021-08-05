local POINTS = 100

local Y_BASELINE = WINDOW_HEIGHT / 2
local Y_NOISE = WINDOW_HEIGHT / 2 - 15
local Y_RANDOM = WINDOW_HEIGHT - Y_BASELINE - Y_NOISE

local OFFSET_NOISE_INITIAL_MAX = 10000
local OFFSET_NOISE_INCREMENT = 0.07

local PLATFORMS = 4
local PLATFORM_MIN_WIDTH = 22
local PLATFORM_POINTS = math.ceil(POINTS / WINDOW_WIDTH * PLATFORM_MIN_WIDTH)

function getTerrain()
  local points = {}
  local platforms = {}

  local counter = 0
  local platformPointsStart = {}
  repeat
    local platformPointStart = love.math.random(POINTS - PLATFORM_POINTS * PLATFORMS)

    local platformOverlaps = false
    for _, point in ipairs(platformPointsStart) do
      if platformPointStart >= point and platformPointStart < point + PLATFORM_POINTS then
        platformOverlaps = true
        break
      end
    end

    if not platformOverlaps then
      table.insert(platformPointsStart, platformPointStart)
      counter = counter + 1
    end
  until counter == PLATFORMS

  local platformPoints = {}
  for _, platformPointStart in ipairs(platformPointsStart) do
    local x1 = (platformPointStart - 1) * WINDOW_WIDTH / POINTS
    local x2 = (platformPointStart + PLATFORM_POINTS - 1) * WINDOW_WIDTH / POINTS
    table.insert(platforms, {x1, x2})

    for point = platformPointStart, platformPointStart + PLATFORM_POINTS do
      platformPoints[point] = true
    end
  end

  local offset = love.math.random(OFFSET_NOISE_INITIAL_MAX)
  for point = 1, POINTS + 1 do
    local x = (point - 1) * WINDOW_WIDTH / POINTS
    local y = Y_BASELINE + love.math.noise(offset) * Y_NOISE

    if not platformPoints[point] then
      offset = offset + OFFSET_NOISE_INCREMENT
      y = y + love.math.random() * Y_RANDOM
    end

    table.insert(points, x)
    table.insert(points, y)
  end

  return points, platforms
end
