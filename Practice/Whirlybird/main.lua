require "src/Dependencies"

local OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = false
}

function love.load()
  love.window.setTitle("Whirlybird")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
  love.graphics.setBackgroundColor(1, 1, 1)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 48),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gSounds = {
    ["bounce"] = love.audio.newSource("res/sounds/bounce.wav", "static"),
    ["destroy"] = love.audio.newSource("res/sounds/destroy.wav", "static"),
    ["fly"] = love.audio.newSource("res/sounds/fly.wav", "static"),
    ["hurt"] = love.audio.newSource("res/sounds/hurt.wav", "static"),
    ["jump"] = love.audio.newSource("res/sounds/jump.wav", "static")
  }

  gTextures = {
    ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png")
  }

  gFrames = {
    ["player"] = GenerateQuadsPlayer(gTextures["spritesheet"])
  }

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["gameover"] = function()
        return GameoverState:new()
      end
    }
  )

  gStateMachine:change("start")

  love.keyboard.keypressed = {}
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
  gStateMachine:render()
end
