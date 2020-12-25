require "src/Dependencies"

function love.load()
  love.window.setTitle("The Legend of Zelda.")

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gStateMachine =
    StateMachine(
    {
      ["title"] = function()
        return TitleState()
      end,
      ["play"] = function()
        return PlayState()
      end,
      ["gameover"] = function()
        return GameoverState()
      end
    }
  )

  gStateMachine:change("title")

  love.keyboard.keysPressed = {}
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()

  gStateMachine:render()

  push:finish()
end
