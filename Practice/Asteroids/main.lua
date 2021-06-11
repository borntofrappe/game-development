require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Asteroids")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.98, 0.98, 0.98)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 52),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 20)
  }

  gStateMachine =
    StateMachine(
    {
      ["title"] = function()
        return TitleState()
      end,
      ["spawn"] = function()
        return SpawnState()
      end,
      ["play"] = function()
        return PlayState()
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
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.1, 0.1, 0.1)
  gStateMachine:render()
end
