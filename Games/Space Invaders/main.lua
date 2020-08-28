require "src/Dependencies"

function love.load()
  love.window.setTitle("Space Invaders")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gRecord = 1000

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 72),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gTextures = {
    ["space-invaders"] = love.graphics.newImage("res/graphics/space-invaders.png")
  }

  gFrames = {
    ["player"] = GenerateQuadPlayer(gTextures["space-invaders"]),
    ["aliens"] = GenerateQuadsAliens(gTextures["space-invaders"]),
    ["bullet"] = GenerateQuadBullet(gTextures["space-invaders"]),
    ["particles"] = GenerateQuadsParticles(gTextures["space-invaders"])
  }

  gSounds = {
    ["explosion"] = love.audio.newSource("res/sounds/explosion.wav", "static"),
    ["hit"] = love.audio.newSource("res/sounds/hit.wav", "static"),
    ["menu"] = love.audio.newSource("res/sounds/menu.wav", "static"),
    ["move"] = love.audio.newSource("res/sounds/move.wav", "static"),
    ["pause"] = love.audio.newSource("res/sounds/pause.wav", "static"),
    ["shoot"] = love.audio.newSource("res/sounds/shoot.wav", "static")
  }

  gStateMachine =
    StateMachine(
    {
      ["title"] = function()
        return TitleScreenState()
      end,
      ["round"] = function()
        return RoundState()
      end,
      ["play"] = function()
        return PlayState()
      end,
      ["pause"] = function()
        return PauseState()
      end,
      ["score"] = function()
        return ScoreTableState()
      end,
      ["hit"] = function()
        return HitState()
      end,
      ["gameover"] = function()
        return GameoverState()
      end,
      ["record"] = function()
        return RecordState()
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
  gStateMachine:render()
  -- showGrid()
end

function testAABB(box1, box2)
  if box1.x + box1.width < box2.x or box1.x > box2.x + box2.width then
    return false
  end

  if box1.y + box1.height < box2.y or box1.y > box2.y + box2.height then
    return false
  end

  return true
end

function showInfo(info)
  local score = info.score or 0
  local health = info.health or 3

  local scoreString = tostring(score)
  local scoreZeros = "00000"

  local scoreText = "Score  " .. string.sub(scoreZeros, 1, #scoreZeros - #scoreString) .. scoreString

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.printf(scoreText:upper(), 0, 16, WINDOW_WIDTH / 2, "right")

  local healthText = "= " .. health
  love.graphics.draw(gTextures["space-invaders"], gFrames["player"], WINDOW_WIDTH / 8 * 5, 16)
  love.graphics.print(healthText:upper(), WINDOW_WIDTH / 8 * 5 + 46, 16)
end

function showGrid()
  love.graphics.setColor(1, 1, 1, 1)
  local cols = 8
  for x = 1, cols do
    love.graphics.rectangle("fill", WINDOW_WIDTH / cols * x - 1, 0, 2, WINDOW_HEIGHT)
  end

  local rows = 6
  for y = 1, rows do
    love.graphics.rectangle("fill", 0, WINDOW_HEIGHT / rows * y - 1, WINDOW_WIDTH, 2)
  end
end
