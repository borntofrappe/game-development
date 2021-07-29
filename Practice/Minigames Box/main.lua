require "src/Dependencies"

function love.load()
  love.window.setTitle("Minigames Box")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.12, 0.13, 0.1)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 52),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 28)
  }

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["countdown"] = function()
        return CountdownState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["bowling"] = function()
        return BowlingState:new()
      end
    }
  )

  gStateMachine:change("bowling")

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
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.rectangle(
    "line",
    WINDOW_PADDING,
    WINDOW_PADDING,
    WINDOW_WIDTH - WINDOW_PADDING * 2,
    WINDOW_HEIGHT - WINDOW_PADDING * 2
  )
  gStateMachine:render()
end
