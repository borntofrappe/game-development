require "src/Dependencies"

function love.load()
  love.window.setTitle("StateStack")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gStateStack =
    StateStack(
    {
      PlayState(),
      DialogueState()
    }
  )

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
