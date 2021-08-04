local POINTS = 100
local Y_BASELINE = WINDOW_HEIGHT / 2
local Y_GAP = WINDOW_HEIGHT / 2 - 15
local Y_GAP_RANDOM = WINDOW_HEIGHT - Y_BASELINE - Y_GAP
local OFFSET_INITIAL_MAX = 1000
local OFFSET_INCREMENT = 0.08

local PLATFORMS = 4
local PLATFORM_MIN_WIDTH = 20
local POINTS_PER_PLATFORM = math.ceil(POINTS / WINDOW_WIDTH * PLATFORM_MIN_WIDTH)

function getTerrain()
  local platforms = 0
  local platformsStart = {}

  repeat
    local platformStart = love.math.random(POINTS - POINTS_PER_PLATFORM * PLATFORMS)

    local overlapsPlatformStart = false
    for _, point in ipairs(platformsStart) do
      if platformStart >= point and platformStart < point + POINTS_PER_PLATFORM then
        overlapsPlatformStart = true
        break
      end
    end
    if not overlapsPlatformStart then
      table.insert(platformsStart, platformStart)
      platforms = platforms + 1
    end
  until platforms == PLATFORMS

  local pointsPlatforms = {}
  for _, platformStart in ipairs(platformsStart) do
    for point = platformStart, platformStart + POINTS_PER_PLATFORM do
      pointsPlatforms[point] = true
    end
  end

  local points = {}

  local offset = love.math.random(OFFSET_INITIAL_MAX)
  for point = 1, POINTS + 1 do
    local x = (point - 1) * WINDOW_WIDTH / POINTS
    local y = Y_BASELINE + love.math.noise(offset) * Y_GAP

    if not pointsPlatforms[point] then
      offset = offset + OFFSET_INCREMENT
      y = y + love.math.random(Y_GAP_RANDOM)
    end

    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end
