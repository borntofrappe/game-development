require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Space Invaders")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gRecord = 1000

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 72),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gTextures = {
    ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png")
  }

  gFrames = {
    ["player"] = GenerateQuadPlayer(gTextures["spritesheet"]),
    ["aliens"] = GenerateQuadsAliens(gTextures["spritesheet"]),
    ["bullet"] = GenerateQuadBullet(gTextures["spritesheet"]),
    ["particles"] = GenerateQuadsParticles(gTextures["spritesheet"])
  }

  gSounds = {
    ["explosion"] = love.audio.newSource("res/sounds/explosion.wav", "static"),
    ["hit"] = love.audio.newSource("res/sounds/hit.wav", "static"),
    ["menu"] = love.audio.newSource("res/sounds/menu.wav", "static"),
    ["move"] = love.audio.newSource("res/sounds/move.wav", "static"),
    ["pause"] = love.audio.newSource("res/sounds/pause.wav", "static"),
    ["record"] = love.audio.newSource("res/sounds/record.wav", "static"),
    ["shoot"] = love.audio.newSource("res/sounds/shoot.wav", "static"),
    ["spawn"] = love.audio.newSource("res/sounds/spawn.wav", "static")
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
      ["points"] = function()
        return PointsState()
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

function showGameInfo(info)
  local score = info.score or 0
  local health = info.health or 3

  local scoreString = tostring(score)
  local scoreZeros = "00000"

  local scoreText = "Score  " .. string.sub(scoreZeros, 1, #scoreZeros - #scoreString) .. scoreString

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.printf(scoreText:upper(), 0, 16, WINDOW_WIDTH / 2, "right")

  local healthText = "= " .. health
  love.graphics.draw(gTextures["spritesheet"], gFrames["player"], WINDOW_WIDTH / 8 * 5, 16)
  love.graphics.print(healthText:upper(), WINDOW_WIDTH / 8 * 5 + 46, 16)
end

function createAliens()
  local aliens = {}

  for row = 1, ROWS do
    aliens[row] = {}
    for column = 1, COLUMNS do
      local alien = Alien(row, column)
      aliens[row][column] = alien
    end
  end

  return aliens
end
