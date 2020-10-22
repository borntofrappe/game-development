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
      end,
      ["victory"] = function()
        return VictoryState()
      end
    }
  )

  gSounds["music"]:setLooping(true)
  gSounds["music"]:setVolume(0.1)
  gSounds["music"]:play()

  gMouseInput = false

  love.keyboard.keyPressed = {}
  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}

  gStateMachine:change("start")
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.mousepressed(x, y, button)
  gMouseInput = true
  love.mouse.buttonPressed[button] = true
end

function love.mousereleased(x, y, button)
  love.mouse.buttonReleased[button] = true
end

function love.mouse.wasPressed(button)
  return love.mouse.buttonPressed[button]
end

function love.mouse.wasReleased(button)
  return love.mouse.buttonReleased[button]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keyPressed = {}
  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["background"], 0, 0)

  gStateMachine:render()
end
