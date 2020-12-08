require "src/Dependencies"

function love.load()
  love.window.setTitle("Bang bang")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.98, 0.98, 0.98)

  gStateMachine =
    StateMachine:create(
    {
      ["title"] = function()
        return TitleState:create()
      end,
      ["play"] = function()
        return PlayState:create()
      end
    }
  )

  gStateMachine:change("title")
  love.keyboard.keyPressed = {}
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
  gStateMachine:render()
end
