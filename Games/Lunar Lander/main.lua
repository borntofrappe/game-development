require "src/Dependencies"

function love.load()
  love.window.setTitle("Lunar Lander")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  font = love.graphics.newFont("res/fonts/font.ttf", 14)
  love.graphics.setFont(font)

  gStateMachine =
    StateMachine(
    {
      ["orbit"] = function()
        return OrbitState()
      end,
      ["platform"] = function()
        return PlatformState()
      end
    }
  )
  gStateMachine:change("orbit", {})

  love.keyboard.keyPressed = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

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
  gStateMachine:render()
end
