require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 56),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 20)
  }

  gTerrain = Terrain:new()
  gCannon = Cannon:new(gTerrain)
  gTarget = Target:new(gTerrain)

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["victory"] = function()
        return VictoryState:new()
      end,
      ["gameover"] = function()
        return GameoverState:new()
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
  gCannon:render()
  gTarget:render()
  gTerrain:render()

  gStateMachine:render()
end
