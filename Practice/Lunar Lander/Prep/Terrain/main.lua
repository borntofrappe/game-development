WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

local lines
local index

function love.load()
  love.window.setTitle("Terrain")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.12, 0.12, 0.12)

  local baseline = {
    ["keyword"] = "baseline",
    ["points"] = {}
  }
  local random = {
    ["keyword"] = "random",
    ["points"] = {}
  }
  local noise = {
    ["keyword"] = "noise",
    ["points"] = {}
  }
  local platform = {
    ["keyword"] = "platform",
    ["points"] = {}
  }

  local points = 100

  local yBaseline = WINDOW_HEIGHT * 3 / 4
  local yGap = WINDOW_HEIGHT / 2.5

  local offsetNoise = love.math.random(1000)
  local offsetIncrement = 0.15

  local offsetNoisePlatform = offsetNoise

  local pointsPerPlatform = math.ceil(points / WINDOW_WIDTH * 25) -- at least 20px wide
  local platforms = 3
  local platformsStart = {}

  repeat
    local platformStart = love.math.random(points - pointsPerPlatform * platforms)
    local overlapsPlatformStart = false
    for _, point in ipairs(platformsStart) do
      if platformStart >= point and platformStart < point + pointsPerPlatform then
        overlapsPlatformStart = true
        break
      end
    end
    if not overlapsPlatformStart then
      table.insert(platformsStart, platformStart)
      platforms = platforms - 1
    end
  until platforms == 0

  local pointsPlatforms = {}
  for _, platformStart in ipairs(platformsStart) do
    for point = platformStart, platformStart + pointsPerPlatform do
      pointsPlatforms[point] = true
    end
  end

  for point = 1, points + 1 do
    local x = (point - 1) * WINDOW_WIDTH / points
    local yRandom = yBaseline + love.math.random() * yGap - yGap / 2
    local yNoise = yBaseline + love.math.noise(offsetNoise) * yGap - yGap / 2
    local yPlatform = yBaseline + love.math.noise(offsetNoisePlatform) * yGap - yGap / 2

    table.insert(baseline.points, x)
    table.insert(random.points, x)
    table.insert(noise.points, x)
    table.insert(platform.points, x)

    table.insert(baseline.points, yBaseline)
    table.insert(random.points, yRandom)
    table.insert(noise.points, yNoise)
    table.insert(platform.points, yPlatform)

    offsetNoise = offsetNoise + offsetIncrement

    if not pointsPlatforms[point] then
      offsetNoisePlatform = offsetNoisePlatform + offsetIncrement
    end
  end

  lines = {}
  table.insert(lines, baseline)
  table.insert(lines, random)
  table.insert(lines, noise)
  table.insert(lines, platform)
  index = 1
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "right" then
    index = index == #lines and 1 or index + 1
  end

  if key == "left" then
    index = index == 1 and #lines or index - 1
  end
end

function love.draw()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.printf(lines[index].keyword:upper(), 0, WINDOW_HEIGHT / 4 - 4, WINDOW_WIDTH, "center")

  love.graphics.setLineWidth(2)
  love.graphics.line(lines[index].points)
end
