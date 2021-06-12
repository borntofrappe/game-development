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

  gSounds = {
    ["destroy-1"] = love.audio.newSource("res/sounds/destroy-1.wav", "static"),
    ["destroy-2"] = love.audio.newSource("res/sounds/destroy-2.wav", "static"),
    ["destroy-3"] = love.audio.newSource("res/sounds/destroy-3.wav", "static"),
    ["gameover"] = love.audio.newSource("res/sounds/gameover.wav", "static"),
    ["hurt"] = love.audio.newSource("res/sounds/hurt.wav", "static"),
    ["record"] = love.audio.newSource("res/sounds/record.wav", "static"),
    ["select"] = love.audio.newSource("res/sounds/select.wav", "static"),
    ["spawn"] = love.audio.newSource("res/sounds/spawn.wav", "static"),
    ["shoot"] = love.audio.newSource("res/sounds/shoot.wav", "static"),
    ["teleport"] = love.audio.newSource("res/sounds/teleport.wav", "static"),
    ["victory"] = love.audio.newSource("res/sounds/victory.wav", "static")
  }

  gStateMachine:change("title")

  gRecord = {
    ["current"] = false,
    ["points"] = RECORD
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

function displayRecord(record)
  love.graphics.setFont(gFonts.small)
  love.graphics.print(record, gFonts.small:getHeight() / 2 + math.floor(WINDOW_WIDTH / 4), 6)
end

function displayStats(score, lives)
  love.graphics.setFont(gFonts.small)
  love.graphics.printf(score, 0, 28, math.floor(WINDOW_WIDTH / 4), "right")

  for i = 1, lives - 1 do
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
