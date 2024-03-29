require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  -- in multiples of 8 to maintain a pixelated resolution
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
      ["title"] = function()
        return TitleState:new()
      end,
      ["ready"] = function()
        return ReadyState:new()
      end,
      ["set"] = function()
        return SetState:new()
      end,
      ["go"] = function()
        return GoState:new()
      end,
      ["drive"] = function()
        return DriveState:new()
      end,
      ["finish"] = function()
        return FinishState:new()
      end,
      ["stop"] = function()
        return StopState:new()
      end,
      ["wrap-up"] = function()
        return WrapUpState:new()
      end
    }
  )

  gStateMachine:change("title")

  love.keyboard.keypressed = {}
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
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
