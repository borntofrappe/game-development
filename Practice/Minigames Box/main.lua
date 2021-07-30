require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Minigames Box")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.12, 0.13, 0.1)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 52),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 28)
  }

  gStates = {"strike", "pop"}

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
      ["feedback"] = function()
        return FeedbackState:new()
      end
    }
  )

  gStateMachine:change("start")

  love.keyboard.keypressed = {}
  love.mouse.buttonpressed = {}
end

function love.keypressed(key)
  love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
  return love.keyboard.keypressed[key]
end

function love.mousepressed(x, y, button)
  love.mouse.buttonpressed[button] = true
end

function love.mouse.waspressed(button)
  return love.mouse.buttonpressed[button]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keypressed = {}
  love.mouse.buttonpressed = {}
end

function love.draw()
  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING)
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.rectangle("line", 0, 0, PLAYING_WIDTH, PLAYING_HEIGHT)
  gStateMachine:render()
end
