require "src/Dependencies"

function love.load()
  love.window.setTitle("Space Invaders")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  gTextures = {
    ["space-invaders"] = love.graphics.newImage("res/graphics/space-invaders.png")
  }

  gFrames = {
    ["player"] = GenerateQuadPlayer(gTextures["space-invaders"])
  }

  gStateMachine =
    StateMachine(
    {
      ["title"] = function()
        return TitleScreenState()
      end,
      ["play"] = function()
        return PlayState()
      end
    }
  )

  gStateMachine:change("play")

  love.keyboard.keypressed = {}
end

function love.keypressed(key)
  love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
  return love.keyboard.keypressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)
  love.keyboard.keypressed = {}
end

function love.draw()
  gStateMachine:render()
end
