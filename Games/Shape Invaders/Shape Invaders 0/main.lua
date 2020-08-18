require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)

  gFonts = {
    ["title"] = love.graphics.newFont("res/fonts/font-title.ttf", 64),
    ["text"] = love.graphics.newFont("res/fonts/font-text.ttf", 20)
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
