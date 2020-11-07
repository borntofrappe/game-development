require "src/Dependencies"

function love.load()
  love.window.setTitle("Alien Jump")
  love.keyboard.keyPressed = {}

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  isPlaying = true
  translateX = 0
  walkingAnimation =
    Animation(
    {
      frames = {4, 5},
      interval = 0.1
    }
  )

  idleAnimation =
    Animation(
    {
      frames = {1},
      interval = 1
    }
  )

  jumpingAnimation =
    Animation(
    {
      frames = {2},
      interval = 1
    }
  )

  squattingAnimation =
    Animation(
    {
      frames = {3},
      interval = 1
    }
  )

  alienAnimation = walkingAnimation
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
  alienAnimation:update(dt)
  if isPlaying then
    translateX = translateX + SCROLL_SPEED * dt
    if translateX >= VIRTUAL_WIDTH then
      translateX = 0
    end
  end

  isPlaying = true
  alienAnimation = walkingAnimation
  if love.keyboard.isDown("down") then
    alienAnimation = squattingAnimation
    isPlaying = false
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
  love.graphics.translate(translateX, 0)

  love.graphics.draw(
    gTextures["alien"],
    gQuads["alien"][alienAnimation:getCurrentFrame()],
    8,
    VIRTUAL_HEIGHT - ALIEN_HEIGHT
  )
  push:finish()
end
