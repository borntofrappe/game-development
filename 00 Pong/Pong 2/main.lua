-- require the push library
push = require "push"

--[[
global variables for the screen size
actual and virtual
the virtual measures refer to the resolution of the screen and are used by the push library to 'project' so to speak the pixelated look to the regular sizes
]]
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 608

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- on load set the size of the window using the push library to apply the desired resolution
function love.load()
  -- filter to avoid blur
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- push:setupScreen works similarly to setMode, but with two additional arguments in the virtual dimensions
  push:setupScreen(
    VIRTUAL_WIDTH,
    VIRTUAL_HEIGHT,
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
    {
      fullscreen = false,
      resizable = false,
      vsync = true
    }
  )
end

-- function responding to a key being pressed
-- receiving as argument the key being pressed
function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

-- on update print a string in the middle of the screen
function love.draw()
  -- wrap any drawing logic in between the push:start and push:finish functions
  push:start()

  -- ! use the virtual dimensions, which are projected to the real ones through the push libraru
  love.graphics.printf(
    "Playing pong here",
    0,
    VIRTUAL_HEIGHT / 2 - 6, -- strings are 6px tall by defaut
    VIRTUAL_WIDTH, -- centered in connection to the screen's width
    "center"
  )

  push:finish()
end
