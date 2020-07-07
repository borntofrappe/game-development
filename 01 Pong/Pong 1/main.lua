--[[
global variables for the screen size
]]
WINDOW_WIDTH = 640
WINDOW_HEIGHT = 360

-- on load set the size of the window
function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true -- synched to the monitor refresh rate
  })
end

-- on update print a string in the middle of the screen
function love.draw()
  love.graphics.printf(
    'Hello There',
    0,
    WINDOW_HEIGHT / 2 - 6, -- by default strings are 6px tall
    WINDOW_WIDTH, -- align relative to the window's width 
    'center')
end
