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

  --[[
    gQuads = {
      ["textures"] = GenerateQuadsTextures(gTextures.spritesheet),
      ["gems"] = GenerateQuadsGems(gTextures.spritesheet),
      ["tools"] = GenerateQuadsTools(gTextures.spritesheet),
    }
  ]]
  gStateMachine =
    StateMachine:new(
    {
      ["dig"] = function()
        return DigState:new()
      end
    }
  )

  gStateMachine:change("dig")

  love.keyboard.keypressed = {}
  love.mouse.buttonpressed = {}
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

function love.mousepressed(x, y, button)
  love.mouse.buttonpressed[button] = true
end

function love.mouse.waspressed(button)
  return love.mouse.buttonpressed[button]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keypressed = {}
  love.mouse.buttonpressed = {}
end

function love.draw()
  push:start()

  gStateMachine:render()

  push:finish()
end
