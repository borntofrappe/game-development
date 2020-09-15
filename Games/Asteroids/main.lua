require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Asteroids")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gRecord = RECORD
  gPoints = POINTS

  gColors = {
    ["background"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
    ["foreground"] = {["r"] = 0.05, ["g"] = 0.05, ["b"] = 0.05}
  }

  gSounds = {
    ["background-noise"] = love.audio.newSource("res/sounds/background-noise.wav", "static"),
    ["destroy-3"] = love.audio.newSource("res/sounds/destroy-3.wav", "static"),
    ["destroy-2"] = love.audio.newSource("res/sounds/destroy-2.wav", "static"),
    ["destroy-1"] = love.audio.newSource("res/sounds/destroy-1.wav", "static"),
    ["enemy"] = love.audio.newSource("res/sounds/enemy.wav", "static"),
    ["gameover"] = love.audio.newSource("res/sounds/gameover.wav", "static"),
    ["hurt"] = love.audio.newSource("res/sounds/hurt.wav", "static"),
    ["life"] = love.audio.newSource("res/sounds/life.wav", "static"),
    ["record"] = love.audio.newSource("res/sounds/record.wav", "static"),
    ["setup"] = love.audio.newSource("res/sounds/setup.wav", "static"),
    ["shoot"] = love.audio.newSource("res/sounds/shoot.wav", "static"),
    ["teleport"] = love.audio.newSource("res/sounds/teleport.wav", "static"),
    ["victory"] = love.audio.newSource("res/sounds/victory.wav", "static")
  }

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 48),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  love.keyboard.keyPressed = {}

  gStateMachine =
    StateMachine:create(
    {
      ["title"] = function()
        return TitleScreenState:create()
      end,
      ["setup"] = function()
        return SetupState:create()
      end,
      ["play"] = function()
        return PlayState:create()
      end,
      ["teleport"] = function()
        return TeleportState:create()
      end,
      ["pause"] = function()
        return PauseState:create()
      end,
      ["victory"] = function()
        return VictoryState:create()
      end,
      ["gameover"] = function()
        return GameoverState:create()
      end
    }
  )

  gStateMachine:change("title")
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
  love.graphics.setColor(gColors["background"]["r"], gColors["background"]["g"], gColors["background"]["b"])
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  gStateMachine:render()
end

function testAABB(circle1, circle2)
  return (circle1.x - circle2.x) ^ 2 + (circle1.y - circle2.y) ^ 2 < (circle1.r + circle2.r) ^ 2
end

function showRecord()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  local x = math.floor(WINDOW_WIDTH / 4)
  local y = 2
  love.graphics.print(gRecord, x, y)
end

function showStats(score, lives)
  local score = score or 0
  local lives = lives or 0

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  local x = math.floor(WINDOW_WIDTH / 4)
  local y = 22

  love.graphics.printf(score, 0, y, x, "right")
  x = x + 12

  if lives < 6 then
    for life = 1, lives - 1 do
      love.graphics.polygon("fill", x, y + 2, x, y + 18, x - 6, y + 14)
      x = x + 8
    end
  else
    love.graphics.polygon("fill", x, y + 2, x, y + 18, x - 6, y + 14)
    love.graphics.print(" = " .. lives, x, y)
  end
end

function hasWon(asteroids)
  return #asteroids == 0
end

function createLevel(n)
  local asteroids = {}
  local asteroids = {}
  for i = 1, n do
    table.insert(asteroids, Asteroid:create())
  end
  return asteroids
end
