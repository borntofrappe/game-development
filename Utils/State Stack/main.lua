require "StateStack"
require "states/BaseState"
require "states/PlayState"
require "states/DialogueState"

WINDOW_WIDTH = 580
WINDOW_HEIGHT = 460

function love.load()
  love.window.setTitle("State Stack")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gStateStack =
    StateStack:new(
    {
      PlayState:new()
    }
  )
  --[[ equivalent
    gStateStack = StateStack:new()
    gStateStack:push(PlayState:new())
  ]]
  love.graphics.setBackgroundColor(0.95, 0.95, 0.95)
  love.keyboard.keyPressed = {}
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  gStateStack:update(dt)
  love.keyboard.keyPressed = {}
end

function love.draw()
  gStateStack:render()
end
