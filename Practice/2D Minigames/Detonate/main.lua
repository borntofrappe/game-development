require "Firework"
require "Target"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

local target
local firework

function love.load()
  math.randomseed(os.time())
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Detonate")
  love.graphics.setBackgroundColor(0, 0.05, 0.1)

  target = Target:new()
  firework = Firework:new()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    if target.inFocus then
      -- victory
    else
      -- loss
      firework.inPlay = false
    end
  end
end

function love.update(dt)
  if firework.inPlay then
    firework:update(dt)
    if firework.y > target.y and firework.y < target.y + target.size then
      target.inFocus = true
    else
      target.inFocus = false
    end

    if firework.y < -firework.r then
      firework.inPlay = false
    end
  end
end

function love.draw()
  target:render()
  firework:render()
end
