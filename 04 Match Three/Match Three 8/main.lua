require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Match Three")

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 40),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gTextures = {
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["match3"] = love.graphics.newImage("res/graphics/match3.png")
  }

  backgroundOffset = 0

  gFrames = {
    ["tiles"] = GenerateQuadsTiles(gTextures["match3"])
  }

  gStateMachine =
    StateMachine(
    {
      ["play"] = function()
        return PlayState()
      end,
      ["title"] = function()
        return TitleScreenState()
      end
    }
  )

  gStateMachine:change("title")

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
  backgroundOffset = (backgroundOffset + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_SCROLL_THRESHOLD
  gStateMachine:update(dt)

  love.keyboard.keypressed = {}
end

function love.draw()
  push:start()

  love.graphics.draw(gTextures["background"], -backgroundOffset, 0)

  gStateMachine:render()

  push:finish()
end
