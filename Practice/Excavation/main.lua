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
    ["textures"] = GenerateQuadsTextures(gTextures.spritesheet),
    ["gems"] = GenerateQuadsGems(gTextures.spritesheet),
    ["selection"] = GenerateQuadSelection(gTextures.spritesheet),
    ["tools"] = GenerateQuadsTools(gTextures.spritesheet)
  }

  gStateStack = StateStack:new({PlayState:new()})

  love.keyboard.keypressed = {}
  -- love.mouse.buttonpressed = {}
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

--[[
  function love.mousepressed(x, y, button)
    love.mouse.buttonpressed[button] = true
  end
  
  function love.mouse.waspressed(button)
    return love.mouse.buttonpressed[button]
  end
]]
function love.update(dt)
  gStateStack:update(dt)

  love.keyboard.keypressed = {}
  -- love.mouse.buttonpressed = {}
end

function love.draw()
  push:start()

  gStateStack:render()

  push:finish()
end
