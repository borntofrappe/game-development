require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  gTextures = {
    ["ball"] = love.graphics.newImage("res/graphics/ball.png"),
    ["cannon"] = love.graphics.newImage("res/graphics/cannon.png"),
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
  gStateMachine:render()
end
