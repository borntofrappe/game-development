require "src/Dependencies"

function love.load()
  love.window.setTitle("Whirlybird")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 48),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 20)
  }

  gColors = {
    ["background"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
    ["grey"] = {["r"] = 91 / 255, ["g"] = 96 / 255, ["b"] = 99 / 255}
  }

  gStateMachine =
    StateMachine(
    {
      ["start"] = function()
        return StartState()
      end
    }
  )

  gStateMachine:change("start")

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
  love.graphics.setColor(gColors["background"]["r"], gColors["background"]["g"], gColors["background"]["b"])
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  gStateMachine:render()
end
