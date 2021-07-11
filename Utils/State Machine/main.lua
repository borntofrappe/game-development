require "StateMachine"
require "states/BaseState"
require "states/StartState"
require "states/EndState"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

function love.load()
  love.window.setTitle("State Machine")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.94, 0.94, 0.94)

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["end"] = function()
        return EndState:new()
      end
    }
  )

  gStateMachine:change("start")

  love.keyboard.keypressed = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

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
