-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- first timer
-- updated every second
currentSecond1 = 0
secondTimer1 = 0
-- second timer
-- updated every 2 second
currentSecond2 = 0
secondTimer2 = 0
-- third timer
-- updated every 3 second
currentSecond3 = 0
secondTimer3 = 0

-- in the load function set up the screen with the push library
function love.load()
  -- title of the screen
  love.window.setTitle('Time keeps passing by')

  -- table for the fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- virtualization through the push library
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  -- table in which to store the last recorded key press
  love.keyboard.keyPressed = {}

end

-- in the resize function update the resolution through the push library
function love.resize(width, height)
  push:resize(width, height)
end

-- in the keypressed function keep track of the key being pressed in keyPressed
function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

-- create a function to check whether a specific key was recorded in the keyPressed table
function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

-- in the update function update secondTimer as to have currentSecond progressively include higher and higher values
function love.update(dt)
  secondTimer1 = secondTimer1 + dt
  if secondTimer1 > 1 then
    currentSecond1 = currentSecond1 + 1
    secondTimer1 = secondTimer1 % 1
  end


  secondTimer2 = secondTimer2 + dt
  if secondTimer2 > 2 then
    currentSecond2 = currentSecond2 + 1
    secondTimer2 = secondTimer2 % 1
  end

  secondTimer3 = secondTimer3 + dt
  if secondTimer3 > 3 then
    currentSecond3 = currentSecond3 + 1
    secondTimer3 = secondTimer3 % 1
  end

  -- listen for a key press on the escape key, at which point quit the application
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}
end

-- in the draw function render the currentSecond variable, in the middle of the screen
function love.draw()
  push:start()

  love.graphics.setColor(1,1,1,1)
  love.graphics.setFont(gFonts['big'])

  love.graphics.printf(
    'Timer 1: ' .. tostring(currentSecond1),
    0,
    VIRTUAL_HEIGHT / 4 - 16,
    VIRTUAL_WIDTH,
    'center'
  )
  love.graphics.printf(
    'Timer 2: ' .. tostring(currentSecond2),
    0,
    VIRTUAL_HEIGHT / 2 - 16,
    VIRTUAL_WIDTH,
    'center'
  )
  love.graphics.printf(
    'Timer 3: ' .. tostring(currentSecond3),
    0,
    VIRTUAL_HEIGHT * 3 / 4 - 16,
    VIRTUAL_WIDTH,
    'center'
  )

  push:finish()
end