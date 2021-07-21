require "src/Dependencies"

local OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = false
}

local background

function love.load()
  math.randomseed(os.time())
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  background = love.graphics.newImage("res/graphics/background.png")

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 52),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 14)
  }

  gSounds = {
    ["confirm"] = love.audio.newSource("res/sounds/confirm.wav", "static"),
    ["eraser"] = love.audio.newSource("res/sounds/eraser.wav", "static"),
    ["pen"] = love.audio.newSource("res/sounds/pen.wav", "static"),
    ["select"] = love.audio.newSource("res/sounds/select.wav", "static"),
    ["victory"] = love.audio.newSource("res/sounds/victory.wav", "static"),
    ["music"] = love.audio.newSource("res/sounds/music.mp3", "static")
  }

  gStateMachine =
    StateMachine:new(
    {
      ["title"] = function()
        return TitleState:new()
      end,
      ["play"] = function()
        return PlayState:new()
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
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(background, 0, 0)
  gStateMachine:render()
end
