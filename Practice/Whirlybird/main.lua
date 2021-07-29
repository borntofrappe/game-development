require "src/Dependencies"

local OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = false
}

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Whirlybird")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
  love.graphics.setBackgroundColor(1, 1, 1)

  gHiScore = 0

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 54),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 22)
  }

  gSounds = {
    ["bounce"] = love.audio.newSource("res/sounds/bounce.wav", "static"),
    ["destroy"] = love.audio.newSource("res/sounds/destroy.wav", "static"),
    ["fly"] = love.audio.newSource("res/sounds/fly.wav", "static"),
    ["hurt"] = love.audio.newSource("res/sounds/hurt.wav", "static"),
    ["jump"] = love.audio.newSource("res/sounds/jump.wav", "static")
  }

  gTextures = {
    ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png"),
    ["spritesheet-gameover"] = love.graphics.newImage("res/graphics/spritesheet-gameover.png")
  }

  gFrames = {
    ["player"] = GenerateQuadsPlayer(gTextures["spritesheet"]),
    ["interactables"] = GenerateQuadsInteractables(gTextures["spritesheet"]),
    ["particles"] = GenerateQuadsParticles(gTextures["spritesheet"]),
    ["hat"] = GenerateQuadsHat(gTextures["spritesheet"]),
    ["sprites"] = GenerateQuadsSprites(gTextures["spritesheet-gameover"]),
    ["marks"] = GenerateQuadsMarks(gTextures["spritesheet-gameover"]),
    ["button"] = GenerateQuadButton(gTextures["spritesheet-gameover"])
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
      ["hurt"] = function()
        return HurtState:new()
      end,
      ["falling"] = function()
        return FallingState:new()
      end,
      ["gameover"] = function()
        return GameoverState:new()
      end
    }
  )

  gStateMachine:change("start")

  love.keyboard.keypressed = {}
  love.mouse.buttonpressed = {}
end

function love.keypressed(key)
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
  gStateMachine:render()
end

function renderScore(score)
  love.graphics.setFont(gFonts.normal)
  love.graphics.setColor(0.35, 0.37, 0.39)
  love.graphics.print(score .. " HI:" .. gHiScore, 8, 8)
end
