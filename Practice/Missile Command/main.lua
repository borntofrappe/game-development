require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  gTextures = {
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["title"] = love.graphics.newImage("res/graphics/title.png"),
    ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png")
  }

  gQuads = {
    ["structures"] = GenerateQuadsStructures(gTextures.spritesheet),
    ["missile"] = GenerateQuadMissile(gTextures.spritesheet)
  }

  gFonts = {
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 32),
    ["small"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  love.graphics.setFont(gFonts.normal)

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["serve"] = function()
        return ServeState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end
    }
  )

  gStateMachine:change(
    "play",
    {
      ["data"] = Data:new()
    }
  )

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
