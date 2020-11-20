Timer = require "Timer"

WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480

function love.load()
  love.window.setTitle("Interval")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  seconds = 0
  Timer:every(
    1,
    function()
      seconds = seconds + 1
    end,
    "seconds"
  )
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "s" then
    Timer:remove("seconds")
  end

  if key == "c" then
    local isCounting = false
    for i, interval in ipairs(Timer.intervals) do
      if interval.label == "seconds" then
        isCounting = true
        break
      end
    end

    if not isCounting then
      Timer:every(
        1,
        function()
          seconds = seconds + 1
        end,
        "seconds"
      )
    end
  end
end

function love.update(dt)
  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.printf("Seconds: " .. seconds, 0, WINDOW_HEIGHT / 2 - 18, WINDOW_WIDTH, "center")
  love.graphics.printf('Press "s" to stop counting', 0, WINDOW_HEIGHT / 2 + 18, WINDOW_WIDTH, "center")
  love.graphics.printf('Press "c" to count again', 0, WINDOW_HEIGHT / 2 + 36, WINDOW_WIDTH, "center")
end
