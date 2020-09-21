require "src/Dependencies"

function love.load()
  love.window.setTitle("Snake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["title"] = love.graphics.newFont("res/fonts/font-bold.ttf", 64),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gStatMachine =
    StateMachine:create(
    {
      ["title"] = function()
        return TitleScreenState:create()
      end,
      ["play"] = function()
        return PlayState:create()
      end
    }
  )

  gStatMachine:change("title")

  love.keyboard.keyPressed = {}
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
  if key == "escape" then
    love.event.quit()
  end

  if key == "g" then
    showGrid = not showGrid
  end
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  gStatMachine:update(dt)
  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.clear(0.035, 0.137, 0.298, 1)
  gStatMachine:render()
end
