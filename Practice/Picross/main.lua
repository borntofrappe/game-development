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

  background = love.graphics.newImage("res/graphics/background.jpg")

  gMouseInput = false

  gLevelsCleared = {}

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 52),
    ["medium"] = love.graphics.newFont("res/fonts/font.ttf", 26),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  gSounds = {
    ["confirm"] = love.audio.newSource("res/sounds/confirm.wav", "static"),
    ["eraser"] = love.audio.newSource("res/sounds/eraser.wav", "static"),
    ["pen"] = love.audio.newSource("res/sounds/pen.wav", "static"),
    ["select"] = love.audio.newSource("res/sounds/select.wav", "static"),
    ["victory"] = love.audio.newSource("res/sounds/victory.wav", "static"),
    ["music"] = love.audio.newSource("res/sounds/music.mp3", "static")
  }

  gColors = {
    ["text"] = {
      ["r"] = 0.07,
      ["g"] = 0.07,
      ["b"] = 0.2
    },
    ["shadow"] = {
      ["r"] = 0.05,
      ["g"] = 0.05,
      ["b"] = 0.15,
      ["a"] = 0.15
    },
    ["highlight"] = {
      ["r"] = 0.98,
      ["g"] = 0.85,
      ["b"] = 0.05
    },
    ["overlay"] = {
      ["r"] = 1,
      ["g"] = 1,
      ["b"] = 1
    }
  }

  gStateMachine =
    StateMachine:new(
    {
      ["title"] = function()
        return TitleState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["select"] = function()
        return SelectState:new()
      end,
      ["victory"] = function()
        return VictoryState:new()
      end
    }
  )

  gStateMachine:change("title")

  love.keyboard.keypressed = {}
  love.mouse.buttonpressed = {}

  gSounds["music"]:setLooping(true)
  gSounds["music"]:setVolume(0.1)
  gSounds["music"]:play()
end

function love.keypressed(key)
  love.keyboard.keypressed[key] = true

  if gMouseInput then
    gMouseInput = false
  end
end

function love.keyboard.waspressed(key)
  return love.keyboard.keypressed[key]
end

function love.mousepressed(x, y, button)
  love.mouse.buttonpressed[button] = true

  if not gMouseInput then
    gMouseInput = true
  end
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
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(background, 0, 0)
  gStateMachine:render()
end

function drawBackButton(x, y, r)
  love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, gColors.shadow.a)
  love.graphics.circle("fill", 0, 0, BACK_BUTTON_RADIUS)
  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 0, 0, BACK_BUTTON_RADIUS)

  love.graphics.setLineWidth(3)
  love.graphics.line(7, 9, 17, 19)
  love.graphics.line(17, 9, 7, 19)
end
