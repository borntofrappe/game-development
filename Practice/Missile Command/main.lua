require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  gTextures = {
    ["title"] = love.graphics.newImage("res/graphics/title.png")
  }

  gFonts = {
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 32)
  }

  love.graphics.setFont(gFonts.normal)

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end
    }
  )

  gStateMachine:change("start")

  love.keyboard.keypressed = {}
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
  gStateMachine:render()
end
