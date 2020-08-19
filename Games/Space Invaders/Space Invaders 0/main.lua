require "src/Dependencies"

function love.load()
  love.window.setTitle("Space Invaders")

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 32),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  gStateMachine =
    StateMachine(
    {
      ["title"] = function()
        return TitleScreenState()
      end
    }
  )

  gStateMachine:change("title")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  gStateMachine:update(dt)
end

function love.draw()
  gStateMachine:render()
end
