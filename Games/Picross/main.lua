require "src/Dependencies"

function love.load()
  love.window.setTitle("Picross")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gStateMachine =
    StateMachine(
    {
      ["start"] = function()
        return StartState()
      end,
      ["select"] = function()
        return SelectState()
      end,
      ["play"] = function()
        return PlayState()
      end
    }
  )

  love.keyboard.keyPressed = {}

  gStateMachine:change("select")
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["background"], 0, 0)

  gStateMachine:render()
end
