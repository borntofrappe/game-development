require "src/Dependencies"

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

function love.load()
  love.window.setTitle("Lunar Lander")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  font = love.graphics.newFont("res/font.ttf", 14)
  love.graphics.setFont(font)

  terrain = makeTerrain()

  data = {
    ["score"] = 0,
    ["time"] = 0,
    ["fuel"] = 1000,
    ["altitude"] = 1234,
    ["horizontal speed"] = 24,
    ["vertical speed"] = -12
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.setLineWidth(1)
  love.graphics.line(terrain)

  displayData()
end

function displayData()
  local whitespace = #"score" + 3

  love.graphics.print(
    formatKeyValuePair("score", formatNumber(data["score"], 4), whitespace - #"score"),
    WINDOW_WIDTH / 6,
    8
  )

  love.graphics.print(
    formatKeyValuePair("time", formatTime(data["time"]), whitespace - #"time"),
    WINDOW_WIDTH / 6,
    8 + font:getHeight()
  )

  love.graphics.print(
    formatKeyValuePair("fuel", formatNumber(data["fuel"], 4), whitespace - #"fuel"),
    WINDOW_WIDTH / 6,
    8 + font:getHeight() * 2
  )

  whitespace = #"horizontal speed" + 2

  love.graphics.print(
    formatKeyValuePair("altitude", data["altitude"], whitespace - #"altitude"),
    WINDOW_WIDTH / 2 + 8,
    8
  )

  love.graphics.print(
    formatKeyValuePair(
      "horizontal speed",
      formatSpeed(data["horizontal speed"], "←", "→"),
      whitespace - #"horizontal speed"
    ),
    WINDOW_WIDTH / 2 + 8,
    8 + font:getHeight()
  )
  love.graphics.print(
    formatKeyValuePair("vertical speed", formatSpeed(data["vertical speed"], "↑", "↓"), whitespace - #"vertical speed"),
    WINDOW_WIDTH / 2 + 8,
    8 + font:getHeight() * 2
  )
end
