require "src/Dependencies"

function love.load()
  love.window.setTitle("Whirlybird")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["big"] = love.graphics.newFont("res/fonts/font.ttf", 48),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 20)
  }

  gColors = {
    ["background"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
    ["grey"] = {["r"] = 91 / 255, ["g"] = 96 / 255, ["b"] = 99 / 255}
  }

  gTextures = {
    ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png")
  }

  gFrames = {
    ["player"] = GenerateQuadPlayer(gTextures["spritesheet"]),
    ["platforms"] = GenerateQuadsPlatforms(gTextures["spritesheet"])
  }

  gStateMachine =
    StateMachine(
    {
      ["start"] = function()
        return StartState()
      end,
      ["play"] = function()
        return PlayState()
      end
    }
  )

  gStateMachine:change("start", {})

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
  love.graphics.setColor(gColors["background"]["r"], gColors["background"]["g"], gColors["background"]["b"])
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  gStateMachine:render()
end

function testAABB(box1, box2)
  if box1.x + box1.width < box2.x or box1.x > box2.x + box2.width then
    return false
  end

  if box1.y + box1.height < box2.y or box1.y > box2.y + box2.height then
    return false
  end

  return true
end
