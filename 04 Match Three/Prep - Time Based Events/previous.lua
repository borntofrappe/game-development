-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- currentSecond describing the passing seconds, secondTimer to compound the value of dt
currentSecond = 0
secondTimer = 0

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
  secondTimer = secondTimer + dt
  if secondTimer > 1 then
    currentSecond = currentSecond + 1
    secondTimer = secondTimer % 1
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
    'Timer: ' .. tostring(currentSecond),
    0,
    VIRTUAL_HEIGHT / 2 - 16,
    VIRTUAL_WIDTH,
    'center'
  )

  push:finish()
end