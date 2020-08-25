require "src/Dependencies"

function love.load()
  love.window.setTitle("Space Invaders")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

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
    ["bullet"] = GenerateQuadBullet(gTextures["space-invaders"])
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

function showScore(score)
  local scoreString = tostring(score)
  local scoreZeros = "00000"

  local scoreText = "Score  " .. string.sub(scoreZeros, 1, #scoreZeros - #scoreString) .. scoreString

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.printf(scoreText:upper(), 0, 8, WINDOW_WIDTH, "center")
end
