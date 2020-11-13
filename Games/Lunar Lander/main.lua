require "src/Dependencies"

function love.load()
  love.window.setTitle("Lunar Lander")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  font = love.graphics.newFont("res/font.ttf", 14)
  love.graphics.setFont(font)

  data = {
    ["score"] = 0,
    ["time"] = 0,
    ["fuel"] = 1000,
    ["altitude"] = 0,
    ["horizontal speed"] = 0,
    ["vertical speed"] = 0
  }

  terrain = makeTerrain()

  love.keyboard.keyPressed = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.line(terrain)

  displayData(
    {"score", "time", "fuel"},
    {formatNumber, formatTime, formatNumber},
    WINDOW_WIDTH / 6 + 8,
    8,
    font:getWidth("score  "),
    font:getHeight() * 0.9
  )

  displayData(
    {"altitude", "horizontal speed", "vertical speed"},
    {nil, formatHorizontalSpeed, formatVerticalSpeed},
    WINDOW_WIDTH / 2 + 16,
    8,
    font:getWidth("horizontal speed  "),
    font:getHeight() * 0.9
  )
end

function displayData(keys, formattingFunctions, startX, startY, gapX, gapY)
  for i, key in ipairs(keys) do
    local formattingFunction = formattingFunctions[i]
    local value = formattingFunction and formattingFunction(data[key]) or data[key]
    local y = startY + (i - 1) * gapY
    local xKey = startX
    local xValue = startX + gapX

    love.graphics.print(key:upper(), xKey, y)
    love.graphics.print(value, xValue, y)
  end
end
