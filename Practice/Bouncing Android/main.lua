Class = require "res/lib/class"

require "StateMachine"
require "states/BaseState"
require "states/TitleScreenState"
require "states/WaitingScreenState"
require "states/PlayScreenState"
require "states/GameoverScreenState"

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
      end,
      ["play"] = function()
        return PlayScreenState()
      end,
      ["gameover"] = function()
        return GameoverScreenState()
      end
    }
  )

  gStateMachine:change("title")

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 48),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 22)
  }

  gImages = {
    ["moon"] = love.graphics.newImage("res/graphics/moon.png"),
    ["buildings-1"] = love.graphics.newImage("res/graphics/buildings-1.png"),
    ["buildings-2"] = love.graphics.newImage("res/graphics/buildings-2.png"),
    ["buildings-3"] = love.graphics.newImage("res/graphics/buildings-3.png")
  }

  -- key, offset, speed
  gParallax = {
    {"buildings-3", 0, 5},
    {"buildings-2", 0, 10},
    {"buildings-1", 0, 30}
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
