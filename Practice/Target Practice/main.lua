require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.04, 0.14, 0.23)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 38),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gTextures = {
    ["cannon"] = love.graphics.newImage("res/graphics/cannon.png"),
    ["cannonball"] = love.graphics.newImage("res/graphics/cannonball.png"),
    ["wheel"] = love.graphics.newImage("res/graphics/wheel.png")
  }

  gStateMachine =
    StateMachine:new(
    {
      ["play"] = function()
        return PlayState:new()
      end
    }
  )

  gStateMachine:change("play")

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
  gStateMachine:render()
end
