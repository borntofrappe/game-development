require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Minigames Box")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.96, 0.94, 0.85)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 52),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 28)
  }

  gStates = {"strike", "pop", "tilt", "catch"}
  gState = nil

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["countdown"] = function()
        return CountdownState:new()
      end,
      ["strike"] = function()
        return StrikeState:new()
      end,
      ["pop"] = function()
        return PopState:new()
      end,
      ["tilt"] = function()
        return TiltState:new()
      end,
      ["catch"] = function()
        return CatchState:new()
      end,
      ["feedback"] = function()
        return FeedbackState:new()
      end
    }
  )

  gStateMachine:change("start")

  love.mouse.buttonpressed = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  love.mouse.buttonpressed[button] = true
end

function love.mouse.waspressed(button)
  return love.mouse.buttonpressed[button]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.mouse.buttonpressed = {}
end

function love.draw()
  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING)
  love.graphics.setLineWidth(3)
  love.graphics.setColor(0.28, 0.25, 0.18)
  love.graphics.rectangle("line", 0, 0, PLAYING_WIDTH, PLAYING_HEIGHT)
  gStateMachine:render()
end
