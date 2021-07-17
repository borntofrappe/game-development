require "src/Dependencies"

local OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = false
}

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
  -- math.randomseed(os.time())
  love.graphics.setBackgroundColor(0.02, 0.02, 0.02)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 96),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
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
      ["points"] = function()
        return PointsState:new()
      end
    }
  )

  gTextures = {
    ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png")
  }

  gFrames = {
    ["invaders"] = GenerateQuadsInvaders(gTextures["spritesheet"]),
    ["bonus-invader"] = GenerateQuadBonusInvader(gTextures["spritesheet"]),
    ["player"] = GenerateQuadPlayer(gTextures["spritesheet"])
  }

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
