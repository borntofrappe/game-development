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
    vsync = true
  })
end

-- on update print a string in the middle of the screen
function love.draw()
  love.graphics.printf(
    'Hello There',
    0,
    WINDOW_HEIGHT / 2 - 6, -- strings are 6px tall by defaut
    WINDOW_WIDTH, -- centered in connection to the screen's width
    'center')
end
