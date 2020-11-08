require "src/Dependencies"

function love.load()
  love.window.setTitle("Alien Jump")

  math.randomseed(os.time())
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gBackgroundVariant = math.random(#gQuads["backgrounds"])
  gStateStack =
    StateStack(
    {
      StartState()
    }
  )

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

  love.graphics.setColor(1, 1, 1)
  love.graphics.print(string.upper("Hi " .. formatScore(gScore.hi) .. " " .. formatScore(gScore.current)), 6, 4)
  push:finish()
end

function formatScore(score)
  return string.format("%04d", score)
end
