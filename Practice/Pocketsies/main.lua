require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.14, 0.14, 0.14)

  gTextures = {
    ["particle"] = love.graphics.newImage("res/particle.png")
  }

  gFonts = {
    ["large"] = love.graphics.newFont("res/font.ttf", 48),
    ["normal"] = love.graphics.newFont("res/font.ttf", 22)
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
  gStateMachine:render()
end
