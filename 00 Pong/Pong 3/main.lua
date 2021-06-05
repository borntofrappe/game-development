-- require the push library
push = require 'push'

--[[
global variables for the screen size
actual and virtual
the virtual measures refer to the resolution of the screen and are used by the push library to 'project' so to speak the pixelated look to the regular sizes
]]
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 608

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- on load set the size of the window, using the push library to apply the desired resolution
function love.load()
  -- filter to avoid blur
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- create a new font through the local ttf file
  newFont = love.graphics.newFont('font.ttf', 8)
  -- set the font to be used in the application
  love.graphics.setFont(newFont)

  -- push:setupScreen works similarly to setMode, but with two additional arguments in the virtual dimensions
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- function responding to a key being pressed
-- receiving as argument the key being pressed
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

-- on update print a string in the middle of the screen
function love.draw()
  -- wrap any drawing logic in between the push:start and push:finish functions
  push:start()

  -- before any other visual, include a solid color as background
  love.graphics.clear(6/255, 17/255, 23/255, 1)

  -- include a simple string of text centered in the first half of the project's height
  -- ! use the virtual dimensions, which are projected to the real ones through the push libraru
  love.graphics.printf(
    'Playing Pong Here',
    0,
    VIRTUAL_HEIGHT / 4 - 8, -- font is now 8px tall
    VIRTUAL_WIDTH, -- centered in connection to the screen's width
    'center')

  -- include two rectangles for the paddles
  -- with 5px of padding from the window's edges
  love.graphics.rectangle('fill', 5, VIRTUAL_HEIGHT / 4, 5, 20)

  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT * 3 / 4, 5, 20)

  -- include a rectangle for the puck
  -- a circle could be very well be drawn with the circle function, as follows
  -- love.graphics.circle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 4)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 5, 5)

  push:finish()
end