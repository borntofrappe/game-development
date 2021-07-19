require "src/Dependencies"

local OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = false
}

function love.load()
  math.randomseed(os.time())
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
  love.graphics.setBackgroundColor(0.02, 0.02, 0.02)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 84),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gTextures = {
    ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png")
  }

  gFrames = {
    ["invaders"] = GenerateQuadsInvaders(gTextures["spritesheet"]),
    ["bonus-invader"] = GenerateQuadBonusInvader(gTextures["spritesheet"]),
    ["player"] = GenerateQuadPlayer(gTextures["spritesheet"]),
    ["projectile"] = GenerateQuadProjectile(gTextures["spritesheet"]),
    ["collision-invader"] = GenerateQuadCollisionInvader(gTextures["spritesheet"]),
    ["collision-player"] = GenerateQuadsCollisionPlayer(gTextures["spritesheet"])
  }

  gStateMachine =
    StateMachine:new(
    {
      ["title"] = function()
        return TitleState:new()
      end,
      ["points"] = function()
        return PointsState:new()
      end,
      ["serve"] = function()
        return ServeState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["pause"] = function()
        return PauseState:new()
      end,
      ["gameover"] = function()
        return GameoverState:new()
      end
    }
  )

  gStateMachine:change("title")

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
  --[[
  love.graphics.setColor(1, 1, 1)
  love.graphics.line(WINDOW_PADDING, 0, WINDOW_PADDING, WINDOW_HEIGHT)
  love.graphics.line(WINDOW_WIDTH - WINDOW_PADDING, 0, WINDOW_WIDTH - WINDOW_PADDING, WINDOW_HEIGHT)
  love.graphics.line(0, WINDOW_HEIGHT - WINDOW_PADDING, WINDOW_WIDTH, WINDOW_HEIGHT - WINDOW_PADDING)
  love.graphics.line(0, WINDOW_PADDING, WINDOW_WIDTH, WINDOW_PADDING)
  --]]
  gStateMachine:render()
end
