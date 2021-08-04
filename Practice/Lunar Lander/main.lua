require "src/Dependencies"

local GRAVITY = 20

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.1, 0.08, 0.12)

  gTerrain = getTerrain()
  gWorld = love.physics.newWorld(0, GRAVITY)

  gFonts = {
    ["large"] = love.graphics.newFont("res/font.ttf", 44),
    ["normal"] = love.graphics.newFont("res/font.ttf", 18),
    ["small"] = love.graphics.newFont("res/font.ttf", 14)
  }

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["land"] = function()
        return LandState:new()
      end,
      ["crash"] = function()
        return CrashState:new()
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
  love.graphics.setColor(0.97, 0.95, 1)
  love.graphics.setLineWidth(2)
  love.graphics.line(gTerrain)

  gStateMachine:render()
end
