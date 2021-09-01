require "src/Dependencies"

function love.load()
  love.window.setTitle("berzerk")

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFont = love.graphics.newFont("res/fonts/font.ttf", 8)
  love.graphics.setFont(gFont)

  gStateMachine =
    StateMachine:new(
    {
      ["title"] = function()
        return TitleState:new()
      end
    }
  )

  gStateMachine:change("title")

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

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  gStateMachine:render()

  push:finish()
end
