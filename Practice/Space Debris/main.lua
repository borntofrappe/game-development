require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)
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

  love.graphics.setBackgroundColor(0.05, 0.05, 0.1)

  gSounds = {
    ["collision"] = love.audio.newSource("res/sounds/collision.wav", "static"),
    ["thrust"] = love.audio.newSource("res/sounds/thrust.wav", "static")
  }

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["record"] = function()
        return RecordState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["gameover"] = function()
        return GameoverState:new()
      end
    }
  )

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 16),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 8)
  }

  love.graphics.setFont(gFonts.normal)

  gStateMachine:change("start")

  love.keyboard.keypressed = {}
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

  gStateMachine:render()

  push:finish()
end
