require "src/Dependencies"

function love.load()
  love.window.setTitle("Alien Jump")

  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gStateStack =
    StateStack(
    {
      StartState()
    }
  )

  gAlienVariant = math.random(2) == 1 and "blue" or "pink"
  gBackgroundVariant = math.random(#gQuads["backgrounds"])

  gScore = {
    ["hi"] = 0,
    ["current"] = 0
  }

  love.keyboard.keyPressed = {}
  love.keyboard.keyReleased = {}
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  love.keyboard.keyPressed[string.lower(key)] = true
end

function love.keyreleased(key)
  love.keyboard.keyReleased[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.keyboard.wasReleased(key)
  return love.keyboard.keyReleased[key]
end

function love.update(dt)
  gStateStack:update(dt)

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  love.keyboard.keyPressed = {}
  love.keyboard.keyReleased = {}
end

function love.draw()
  push:start()

  gStateStack:render()

  if gScore.hi > 0 then
    displayRecord(gScore.hi)
  end

  displayScore(gScore.current)

  push:finish()
end

function numberToDigits(num)
  local digits = {}
  local string = tostring(num)
  for i = 1, #string do
    local char = string:sub(i, i)
    local digit = tonumber(char)
    digits[i] = digit
  end

  return digits
end

function displayScore(score)
  local scoreDigits = numberToDigits(score)
  for i, digit in ipairs(scoreDigits) do
    love.graphics.draw(
      gTextures["numbers"],
      gQuads["numbers"][digit + 1],
      VIRTUAL_WIDTH - 4 - NUMBER_SIZE * #scoreDigits + NUMBER_SIZE * (i - 1),
      6
    )
  end
end

function displayRecord(record)
  love.graphics.draw(gTextures["star"], 4, 2)

  local recordDigits = numberToDigits(record)
  for i, digit in ipairs(recordDigits) do
    love.graphics.draw(gTextures["numbers"], gQuads["numbers"][digit + 1], 20 + NUMBER_SIZE * (i - 1), 6)
  end
end

function formatScore(score)
  return string.format("%04d", score)
end
