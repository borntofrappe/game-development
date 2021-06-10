Class = require "res/lib/class"

require "globals"

require "Android"
require "Lollipop"
require "LollipopPair"

require "StateMachine"
require "states/BaseState"
require "states/TitleScreenState"
require "states/WaitingScreenState"
require "states/PlayScreenState"
require "states/GameoverScreenState"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 550

function love.load()
  love.window.setTitle("Bouncing Android")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  math.randomseed(os.time())

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
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gImages.background, 0, 0)
  gStateMachine:render()
end
