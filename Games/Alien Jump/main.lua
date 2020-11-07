require "src/Dependencies"

function love.load()
  love.window.setTitle("Alien Jump")
  love.keyboard.keyPressed = {}

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  translateX = 0
  backgroundVariant = math.random(#gQuads["backgrounds"])
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = gTextures
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    translateX = translateX + SCROLL_SPEED * dt
    if translateX >= VIRTUAL_WIDTH then
      translateX = 0
    end
  end

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("r") then
    backgroundVariant = math.random(#gQuads["backgrounds"])
  end

  love.keyboard.keyPressed = {}
end

function love.draw()
  push:start()
  love.graphics.translate(-translateX, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][backgroundVariant], 0, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][backgroundVariant], VIRTUAL_WIDTH, 0)
  push:finish()
end
