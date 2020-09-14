require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Asteroids")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gRecord = 3500

  gColors = {
    ["background"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
    ["foreground"] = {["r"] = 0, ["g"] = 0, ["b"] = 0}
  }

  gSounds = {
    ["destroy-3"] = love.audio.newSource("res/sounds/destroy-3.wav", "static"),
    ["destroy-2"] = love.audio.newSource("res/sounds/destroy-2.wav", "static"),
    ["destroy-1"] = love.audio.newSource("res/sounds/destroy-1.wav", "static"),
    ["gameover"] = love.audio.newSource("res/sounds/gameover.wav", "static"),
    ["hurt"] = love.audio.newSource("res/sounds/hurt.wav", "static"),
    ["shoot"] = love.audio.newSource("res/sounds/shoot.wav", "static"),
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
      ["play"] = function()
        return PlayState:create()
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

function showStats(score, lives)
  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  local x = math.floor(WINDOW_WIDTH / 4)
  local y = 2
  love.graphics.print(gRecord, x, y)

  y = y + 20
  love.graphics.printf(score, 0, y, x, "right")
  x = x + 4
  for life = 1, lives - 1 do
    x = x + 8
    love.graphics.polygon("fill", x, y + 4, x, y + 18, x - 5, y + 14)
  end
end
