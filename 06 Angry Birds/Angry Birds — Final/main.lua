require "src/Dependencies"

function love.load()
  love.window.setTitle("Angry Birds")
  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gTextures = {
    ["aliens"] = love.graphics.newImage("res/graphics/aliens.png"),
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["ground"] = love.graphics.newImage("res/graphics/ground.png"),
    ["obstacles"] = love.graphics.newImage("res/graphics/obstacles.png")
  }

  gFrames = {
    ["aliens"] = GenerateQuadsAliens(gTextures["aliens"]),
    ["background"] = GenerateQuads(gTextures["background"], VIRTUAL_WIDTH, VIRTUAL_HEIGHT),
    ["ground"] = GenerateQuads(gTextures["ground"], 35, 35),
    ["obstacles"] = GenerateQuadsObstacles(gTextures["obstacles"])
  }

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 56),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gSounds = {
    ["bounce"] = love.audio.newSource("res/sounds/bounce.wav", "static"),
    ["break1"] = love.audio.newSource("res/sounds/break1.wav", "static"),
    ["break2"] = love.audio.newSource("res/sounds/break2.wav", "static"),
    ["break3"] = love.audio.newSource("res/sounds/break3.wav", "static"),
    ["break4"] = love.audio.newSource("res/sounds/break4.wav", "static"),
    ["kill"] = love.audio.newSource("res/sounds/kill.wav", "static"),
    ["music"] = love.audio.newSource("res/sounds/music.wav", "static")
  }

  gStateMachine =
    StateMachine(
    {
      ["start"] = function()
        return StartState()
      end,
      ["play"] = function()
        return PlayState()
      end
    }
  )

  gStateMachine:change("start")

  gSounds["music"]:setLooping(true)
  gSounds["music"]:setVolume(0.1)
  gSounds["music"]:play()

  love.keyboard.keyPressed = {}
  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}

  gBackgroundVariety = math.random(#gFrames["background"])
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

function love.mousepressed(x, y, button)
  love.mouse.buttonPressed[button] = true
end

function love.mousereleased(x, y, button)
  love.mouse.buttonReleased[button] = true
end

function love.mouse.wasPressed(key)
  return love.mouse.buttonPressed[key]
end

function love.mouse.wasReleased(key)
  return love.mouse.buttonReleased[key]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
  love.keyboard.keyPressed = {}
end

function love.draw()
  push:start()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(gTextures["background"], gFrames["background"][gBackgroundVariety], 0, 0)
  for i = 1, math.floor(VIRTUAL_WIDTH / TILE_SIZE) + 1 do
    love.graphics.draw(
      gTextures["ground"],
      gFrames["ground"][gBackgroundVariety],
      (i - 1) * TILE_SIZE,
      VIRTUAL_HEIGHT - TILE_SIZE / 2
    )
  end

  gStateMachine:render()

  push:finish()
end
