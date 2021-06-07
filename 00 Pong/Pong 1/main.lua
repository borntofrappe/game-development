--[[
global variables for the screen size
]]
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 608

-- on load set the size of the window
function love.load()
  love.window.setMode(
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
    {
      fullscreen = false,
      resizable = false,
      vsync = true -- synched to the monitor refresh rate
    }
  )
end

function love.draw()
  love.graphics.printf(
    "Hello World",
    0,
    WINDOW_HEIGHT / 2 - 6, -- by default strings are 6px tall
    WINDOW_WIDTH, -- align relative to the window's width
    "center"
  )
end
