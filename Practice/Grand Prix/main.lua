require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 16),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 8)
  }

  gTextures = {
    ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png")
  }

  gQuads = {
    ["cars"] = GenerateQuadsCars(gTextures.spritesheet),
    ["textures"] = GenerateQuadsTextures(gTextures.spritesheet)
  }

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["set"] = function()
        return SetState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["finish"] = function()
        return FinishState:new()
      end,
      ["stop"] = function()
        return StopState:new()
      end,
      ["gameover"] = function()
        return GameoverState:new()
      end
    }
  )

  gStateMachine:change("start")

  love.keyboard.keypressed = {}
end

function love.resize(width, height)
  push:resize(width, height)
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
  push:start()

  gStateMachine:render()

  push:finish()
end
