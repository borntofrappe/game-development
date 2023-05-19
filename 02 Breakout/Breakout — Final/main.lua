require "src/Dependencies"

function love.load()
  love.window.setTitle("Breakout")
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["small"] = love.graphics.newFont("res/fonts/font.ttf", 8),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16),
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 32),
    ["humongous"] = love.graphics.newFont("res/fonts/font.ttf", 56)
  }

  gTextures = {
    ["arrows"] = love.graphics.newImage("res/graphics/arrows.png"),
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["breakout"] = love.graphics.newImage("res/graphics/breakout.png"),
    ["hearts"] = love.graphics.newImage("res/graphics/hearts.png"),
    ["particle"] = love.graphics.newImage("res/graphics/particle.png")
  }

  gSounds = {
    ["brick-hit-1"] = love.audio.newSource("res/sounds/brick-hit-1.wav", "static"),
    ["brick-hit-2"] = love.audio.newSource("res/sounds/brick-hit-2.wav", "static"),
    ["confirm"] = love.audio.newSource("res/sounds/confirm.wav", "static"),
    ["high_score"] = love.audio.newSource("res/sounds/high_score.wav", "static"),
    ["hurt"] = love.audio.newSource("res/sounds/hurt.wav", "static"),
    ["no-select"] = love.audio.newSource("res/sounds/no-select.wav", "static"),
    ["paddle_hit"] = love.audio.newSource("res/sounds/paddle_hit.wav", "static"),
    ["pause"] = love.audio.newSource("res/sounds/pause.wav", "static"),
    ["recover"] = love.audio.newSource("res/sounds/recover.wav", "static"),
    ["score"] = love.audio.newSource("res/sounds/score.wav", "static"),
    ["select"] = love.audio.newSource("res/sounds/select.wav", "static"),
    ["victory"] = love.audio.newSource("res/sounds/victory.wav", "static"),
    ["wall_hit"] = love.audio.newSource("res/sounds/wall_hit.wav", "static"),
    ["music"] = love.audio.newSource("res/sounds/music.wav", "static")
  }

  gFrames = {
    ["paddles"] = GenerateQuadsPaddles(gTextures["breakout"]),
    ["balls"] = GenerateQuadsBalls(gTextures["breakout"]),
    ["bricks"] = GenerateQuadsBricks(gTextures["breakout"]),
    ["hearts"] = GenerateQuads(gTextures["hearts"], 10, 9),
    ["arrows"] = GenerateQuads(gTextures["arrows"], 24, 24)
  }

  gStateMachine =
    StateMachine(
    {
      ["start"] = function()
        return StartState()
      end,
      ["play"] = function()
        return PlayState()
      end,
      ["pause"] = function()
        return PauseState()
      end,
      ["serve"] = function()
        return ServeState()
      end,
      ["gameover"] = function()
        return GameoverState()
      end,
      ["victory"] = function()
        return VictoryState()
      end,
      ["highscores"] = function()
        return HighScoresState()
      end,
      ["enterhighscore"] = function()
        return EnterHighScoreState()
      end,
      ["paddleselect"] = function()
        return PaddleSelectState()
      end
    }
  )

  gStateMachine:change("start")

  love.keyboard.keypressed = {}

  gSounds["music"]:setLooping(true)
  gSounds["music"]:play()
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
  gStateMachine:update(dt)

  love.keyboard.keypressed = {}
end

function love.draw()
  push:start()

  love.graphics.draw(gTextures["background"], 0, 0)

  gStateMachine:render()

  -- displayFPS()

  push:finish()
end

function displayFPS()
  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 8, 8)
end

function displayHealth(health, maxHealth)
  local x = VIRTUAL_WIDTH - 8 - 10 - 12 * (maxHealth - 1)
  for i = 0, maxHealth - 1 do
    if health > i then
      love.graphics.draw(gTextures["hearts"], gFrames["hearts"][1], x, 8)
    else
      love.graphics.draw(gTextures["hearts"], gFrames["hearts"][2], x, 8)
    end
    x = x + 12
  end
end

function displayScore(score)
  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(score, 0, 22, VIRTUAL_WIDTH - 8, "right")
end

function loadHighScores()
  love.filesystem.setIdentity("breakout")

  if not love.filesystem.getInfo("highscores.lst") then
    local highScores = ""
    for i = 10, 1, -1 do
      highScores = highScores .. "GBR\n"
      highScores = highScores .. 500 + 1500 * (i - 1) .. "\n"
    end
    love.filesystem.write("highscores.lst", string.sub(highScores, 1, #highScores - 1))
  end

  local highScores = {}
  local counter = 1
  local isName = true

  for i = 1, 10 do
    highScores[i] = {
      name = nil,
      score = nil
    }
  end

  for line in love.filesystem.lines("highscores.lst") do
    if isName then
      highScores[counter].name = string.sub(line, 1, 3)
    else
      highScores[counter].score = tonumber(line)
      counter = counter + 1
    end
    isName = not isName
  end

  return highScores
end
