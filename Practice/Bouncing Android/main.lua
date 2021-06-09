Class = require "res/lib/class"

require "StateMachine"
require "states/BaseState"
require "states/TitleScreenState"
require "states/WaitingScreenState"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 550

local background = love.graphics.newImage("res/graphics/background.png")

function love.load()
  love.window.setTitle("Bouncing Android")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  gStateMachine =
    StateMachine(
    {
      ["title"] = function()
        return TitleScreenState()
      end,
      ["waiting"] = function()
        return WaitingScreenState()
      end
    }
  )

  gStateMachine:change("title")

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 48),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 22)
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  love.mouse.waspressed = true
end

function love.update(dt)
  gStateMachine:update(dt)

  love.mouse.waspressed = false
end

function love.draw()
  love.graphics.draw(background, 0, 0)
  gStateMachine:render()
end
