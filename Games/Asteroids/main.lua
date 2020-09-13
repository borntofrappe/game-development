require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Asteroids")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gColors = {
    ["background"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
    ["foreground"] = {["r"] = 0, ["g"] = 0, ["b"] = 0}
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
  if circle1.x > circle2.x + circle2.r or circle1.x < circle2.x - circle2.r then
    return false
  end

  if circle1.y > circle2.y + circle2.r or circle1.y < circle2.y - circle2.r then
    return false
  end

  return true
end
