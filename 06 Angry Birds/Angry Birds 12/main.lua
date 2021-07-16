require "src/Dependencies"

local backgroundVariety

function love.load()
  love.window.setTitle("Angry Birds")
  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gTextures = {
    ["aliens"] = love.graphics.newImage("res/graphics/aliens.png"),
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["obstacles"] = love.graphics.newImage("res/graphics/obstacles.png")
  }

  gFrames = {
    ["aliens"] = GenerateQuadsAliens(gTextures["aliens"]),
    ["background"] = GenerateQuadsBackground(gTextures["background"]),
    ["obstacles"] = GenerateQuadsObstacles(gTextures["obstacles"])
  }

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 56),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
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

  love.keyboard.keyPressed = {}
  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}

  backgroundVariety = math.random(#gFrames["background"])
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

  love.graphics.draw(gTextures["background"], gFrames["background"][backgroundVariety], 0, 0)

  gStateMachine:render()

  push:finish()
end
