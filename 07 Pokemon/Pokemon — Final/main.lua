require "src/Dependencies"

function love.load()
  love.window.setTitle("Pokemon")
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gStateStack =
    StateStack(
    {
      StartState()
    }
  )

  gSounds["battle_music"]:setLooping(true)
  gSounds["field_music"]:setLooping(true)
  gSounds["intro_music"]:setLooping(true)
  gSounds["victory"]:setLooping(true)

  love.audio.setVolume(0.5)

  love.keyboard.keyPressed = {}
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  gStateStack:update(dt)
  love.keyboard.keyPressed = {}
end

function love.draw()
  push:start()
  gStateStack:render()
  push:finish()
end
