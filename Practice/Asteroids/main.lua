require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Asteroids")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.98, 0.98, 0.98)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 48),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 20),
    ["small"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  gStateMachine =
    StateMachine(
    {
      ["title"] = function()
        return TitleState()
      end,
      ["spawn"] = function()
        return SpawnState()
      end,
      ["play"] = function()
        return PlayState()
      end,
      ["victory"] = function()
        return VictoryState()
      end,
      ["gameover"] = function()
        return GameoverState()
      end,
      ["teleport"] = function()
        return TeleportState()
      end
    }
  )

  gStateMachine:change("title")

  gRecord = RECORD
  gStats = {
    ["score"] = 0,
    ["level"] = 1,
    ["lives"] = LIVES
  }

  love.keyboard.keyPressed = {}
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.1, 0.1, 0.1)
  gStateMachine:render()
end

function displayRecord()
  love.graphics.setFont(gFonts.small)
  love.graphics.print(gRecord, gFonts.small:getHeight() / 2 + math.floor(WINDOW_WIDTH / 4), 6)
end

function displayStats()
  love.graphics.setFont(gFonts.small)
  love.graphics.printf(gStats.score, 0, 28, math.floor(WINDOW_WIDTH / 4), "right")

  for i = 1, gStats.lives - 1 do
    love.graphics.polygon(
      "fill",
      i * gFonts.small:getHeight() / 2 + WINDOW_WIDTH / 4,
      28,
      i * gFonts.small:getHeight() / 2 + WINDOW_WIDTH / 4,
      28 + gFonts.small:getHeight(),
      i * gFonts.small:getHeight() / 2 + WINDOW_WIDTH / 4 + gFonts.small:getHeight() / 3,
      28 + gFonts.small:getHeight() * 2 / 3
    )
  end
end
