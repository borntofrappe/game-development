require "Firework"
require "Target"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

local state = "waiting"
local target
local firework

function love.load()
  math.randomseed(os.time())
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Detonate")
  love.graphics.setBackgroundColor(0, 0.05, 0.1)

  target = Target:new()
  firework = Firework:new()
  state = "playing"
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    if state == "playing" then
      state = "waiting"
      firework.dy = 0
      firework.r = 0

      if target.inFocus then
        firework:explode()
      else
        firework:fizzle()
      end
    elseif state == "waiting" then
      target = Target:new()
      firework = Firework:new()
      state = "playing"
    end
  end
end

function love.update(dt)
  if state == "playing" then
    firework:trail()

    if firework.y > target.y and firework.y < target.y + target.size then
      target.inFocus = true
    else
      target.inFocus = false
    end

    if firework.y < -firework.r then
      state = "waiting"
    end
  end

  firework:update(dt)
end

function love.draw()
  if state == "playing" then
    target:render()
  end
  firework:render()
end
