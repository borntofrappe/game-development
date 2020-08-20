require "src/Dependencies"

function love.load()
  love.window.setTitle("Space Invaders")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 64),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
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
