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
    ["collision-player"] = GenerateQuadsCollisionPlayer(gTextures["spritesheet"]),
    ["collision-projectiles"] = GenerateQuadsCollisionProjectiles(gTextures["spritesheet"])
  }

  gSounds = {
    ["bonus-invader"] = love.audio.newSource("res/sounds/bonus-invader.wav", "static"),
    ["collision-invader"] = love.audio.newSource("res/sounds/collision-invader.wav", "static"),
    ["collision-player"] = love.audio.newSource("res/sounds/collision-player.wav", "static"),
    ["high-score-state"] = love.audio.newSource("res/sounds/high-score-state.wav", "static"),
    ["pause-state"] = love.audio.newSource("res/sounds/pause-state.wav", "static"),
    ["projectile-player"] = love.audio.newSource("res/sounds/projectile-player.wav", "static"),
    ["round-cleared"] = love.audio.newSource("res/sounds/round-cleared.wav", "static"),
    ["serve-state"] = love.audio.newSource("res/sounds/serve-state.wav", "static"),
    ["title-state"] = love.audio.newSource("res/sounds/title-state.wav", "static"),
    ["update-interval"] = love.audio.newSource("res/sounds/update-interval.wav", "static")
  }

  gHighScore = 1000

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
      ["high-score"] = function()
        return HighScoreState:new()
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
  love.graphics.rectangle(
    "line",
    WINDOW_PADDING,
    WINDOW_PADDING + DATA_HEIGHT + PLAYING_AREA_BONUS_HEIGHT,
    PLAYING_AREA_WIDTH,
    PLAYING_AREA_HEIGHT
  )
  --]]
  gStateMachine:render()
end
