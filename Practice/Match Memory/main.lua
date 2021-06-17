require "src/Dependencies"

function love.load()
  love.window.setTitle("Match memory")

  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(
    VIRTUAL_WIDTH,
    VIRTUAL_HEIGHT,
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
    {
      fullscreen = false,
      resizable = true,
      vsync = true
    }
  )

  gStateMachine =
    StateMachine(
    {
      ["start"] = function()
        return StartState()
      end,
      ["play"] = function()
        return PlayState()
      end,
      ["victory"] = function()
        return VictoryState()
      end
    }
  )

  gTexture = love.graphics.newImage("res/graphics/spritesheet.png")
  gFrames = GenerateQuads(gTexture, TILE_WIDTH, TILE_HEIGHT)

  gStateMachine:change("start")

  love.graphics.setFont(gFonts["normal"])

  love.keyboard.keypressed = {}
end

function love.keypressed(key)
  love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
  return love.keyboard.keypressed[key]
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keypressed = {}
end

function love.draw()
  push:start()

  love.graphics.setColor(gColors.background.r, gColors.background.g, gColors.background.b)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  gStateMachine:render()

  push:finish()
end
