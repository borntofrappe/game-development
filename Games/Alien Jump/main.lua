require "src/Dependencies"

function love.load()
  love.window.setTitle("Alien Jump")

  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  backgroundVariant = math.random(#gQuads["backgrounds"])

  gStateStack =
    StateStack(
    {
      StartState()
    }
  )

  love.keyboard.keyPressed = {}
  love.keyboard.keyReleased = {}
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
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

  if love.keyboard.wasPressed("r") then
    backgroundVariant = math.random(#gQuads["backgrounds"])
  end

  love.keyboard.keyPressed = {}
  love.keyboard.keyReleased = {}
end

function love.draw()
  push:start()

  gStateStack:render()

  push:finish()
end
