require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  gTerrain = getTerrain()

  gFonts = {
    ["large"] = love.graphics.newFont("res/font.ttf", 44),
    ["normal"] = love.graphics.newFont("res/font.ttf", 20)
  }

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["play"] = function()
        return PlayState:new()
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
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setLineWidth(2)
  love.graphics.line(gTerrain)
  gStateMachine:render()
end
