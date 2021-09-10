require "src/Dependencies"

function love.load()
  love.window.setTitle("Berzerk")

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gTexture = love.graphics.newImage("res/graphics/spritesheet.png")

  gQuads = {
    ["player"] = GenerateQuadsPlayer(gTexture),
    ["enemy"] = GenerateQuadsEnemy(gTexture)
  }

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 24),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 8)
  }

  gSounds = {
    ["buzz"] = love.audio.newSource("res/sounds/buzz.wav", "static"),
    ["enemy-shoot"] = love.audio.newSource("res/sounds/enemy-shoot.wav", "static"),
    ["enemy-shot"] = love.audio.newSource("res/sounds/enemy-shot.wav", "static"),
    ["level"] = love.audio.newSource("res/sounds/level.wav", "static"),
    ["player-shoot"] = love.audio.newSource("res/sounds/player-shoot.wav", "static"),
    ["projectile-collision"] = love.audio.newSource("res/sounds/projectile-collision.wav", "static")
  }

  -- gStateStack = StateStack:new({TitleState:new()}) -- uncomment in the final version
  gStateStack = StateStack:new({PlayState:new()})

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
  gStateStack:update(dt)

  love.keyboard.keypressed = {}
end

function love.draw()
  push:start()

  gStateStack:render()

  push:finish()
end
