require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Match Three")
  font = love.graphics.newFont("res/fonts/font.ttf", 16)
  love.graphics.setFont(font)

  gTextures = {
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["match3"] = love.graphics.newImage("res/graphics/match3.png")
  }

  gFrames = {
    ["tiles"] = GenerateQuadsTiles(gTextures["match3"])
  }

  gStateMachine =
    StateMachine(
    {
      ["play"] = function()
        return PlayState()
      end
    }
  )

  gStateMachine:change("play")

  love.keyboard.keypressed = {}

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
  return love.keyboard.keypressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keypressed = {}
end

function love.draw()
  push:start()

  love.graphics.draw(gTextures["background"], 0, 0)

  gStateMachine:render()

  push:finish()
end
