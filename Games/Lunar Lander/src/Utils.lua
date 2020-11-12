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
  return string.format("%0" .. padding .. "d", number)
end

function formatTime(seconds)
  return formatNumber(math.floor(seconds / 60), 2) .. ":" .. formatNumber(seconds % 60, 2)
end

function formatSpeed(speed, negative, positive)
  local icons = {
    ["horizontal speed"] = {"←", "→"},
    ["vertical speed"] = {"↑", "↓"}
  }
  local icon = ""
  if speed > 0 then
    icon = positive
  elseif speed < 0 then
    icon = negative
  end

  return math.abs(speed) .. " " .. icon
end

function formatKeyValuePair(key, value, whitespace)
  return string.upper(key) .. string.format("%" .. whitespace .. "s", " ") .. value
end

function displayData(data)
  local whitespace = #"score" + 3

  love.graphics.print(
    formatKeyValuePair("score", formatNumber(data["score"], 4), whitespace - #"score"),
    WINDOW_WIDTH / 7,
    8
  )

  love.graphics.print(
    formatKeyValuePair("time", formatTime(data["time"]), whitespace - #"time"),
    WINDOW_WIDTH / 7,
    8 + font:getHeight() * 0.9
  )

  love.graphics.print(
    formatKeyValuePair("fuel", formatNumber(data["fuel"], 4), whitespace - #"fuel"),
    WINDOW_WIDTH / 7,
    8 + font:getHeight() * 1.8
  )

  whitespace = #"horizontal speed" + 2

  love.graphics.print(formatKeyValuePair("altitude", data["altitude"], whitespace - #"altitude"), WINDOW_WIDTH / 2, 8)

  love.graphics.print(
    formatKeyValuePair(
      "horizontal speed",
      formatSpeed(data["horizontal speed"], "←", "→"),
      whitespace - #"horizontal speed"
    ),
    WINDOW_WIDTH / 2,
    8 + font:getHeight() * 0.9
  )
  love.graphics.print(
    formatKeyValuePair("vertical speed", formatSpeed(data["vertical speed"], "↑", "↓"), whitespace - #"vertical speed"),
    WINDOW_WIDTH / 2,
    8 + font:getHeight() * 1.8
  )
end
